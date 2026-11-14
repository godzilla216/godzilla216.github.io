"""Reapply the promotion patch to the matching original data file.

Requires Python and UnityPy (`python -m pip install UnityPy`). The game itself
only needs a browser; this script is for maintaining the compiled assets.
"""
import gzip
import hashlib
import struct
from pathlib import Path

import UnityPy

TARGET = Path(__file__).resolve().parents[1] / "Build" / "ItchIO.data.unityweb"
SOURCE_SHA256 = "b50603116417bb1d472acf0c2e76a5b560da960486081b4f257b0afcb8d9ab09"
PROMOTIONS = {"AppStore", "PlayMarket", "WatchVideo"}


def patch():
    compressed = TARGET.read_bytes()
    if hashlib.sha256(compressed).hexdigest() != SOURCE_SHA256:
        raise ValueError("Expected the original matching data file; refusing to patch a different build or patch twice.")
    raw = gzip.decompress(compressed)
    if raw[:16] != b"UnityWebData1.0\0":
        raise ValueError("Invalid Unity data header")
    directory_end = struct.unpack_from("<I", raw, 16)[0]
    offset = 20
    files = []
    while offset < directory_end:
        start, size, name_size = struct.unpack_from("<III", raw, offset)
        offset += 12
        name = raw[offset:offset + name_size]
        offset += name_size
        files.append((name, raw[start:start + size]))

    patched_names = set()
    for index, (name, content) in enumerate(files):
        if name != b"data.unity3d":
            continue
        env = UnityPy.load(content)
        for obj in env.objects:
            if obj.type.name != "GameObject" or obj.assets_file.name != "level0":
                continue
            data = obj.read()
            if data.m_Name in PROMOTIONS:
                before = obj.get_raw_data()
                data.m_IsActive = False
                data.save()
                after = obj.data
                # Each change must be exactly one boolean, with all references kept.
                assert len(before) == len(after)
                assert sum(a != b for a, b in zip(before, after)) == 1
                # Startup scripts reactivate the store GameObjects on desktop.
                # Keep their Image and Button behaviours disabled as well.
                for pair in data.m_Component:
                    component = pair.component.deref()
                    if component.type.name == "MonoBehaviour":
                        component_raw = bytearray(component.get_raw_data())
                        # Unity 5.6 MonoBehaviour: 12-byte GameObject PPtr,
                        # then the enabled byte, padding, Script PPtr and name.
                        assert len(component_raw) >= 32
                        assert struct.unpack_from("<iq", component_raw, 0) == (0, obj.path_id)
                        assert component_raw[12] == 1
                        component_raw[12] = 0
                        component.set_raw_data(bytes(component_raw))
                patched_names.add(data.m_Name)
        assert patched_names == PROMOTIONS, patched_names
        updated = env.file.save(packer="original")
        check = UnityPy.load(updated)
        found = set()
        for obj in check.objects:
            if obj.type.name == "GameObject" and obj.assets_file.name == "level0":
                data = obj.read()
                if data.m_Name in PROMOTIONS:
                    assert not data.m_IsActive
                    for pair in data.m_Component:
                        component = pair.component.deref()
                        if component.type.name == "MonoBehaviour":
                            assert component.get_raw_data()[12] == 0
                    found.add(data.m_Name)
        assert found == PROMOTIONS
        files[index] = (name, updated)

    assert patched_names == PROMOTIONS
    header = bytearray(b"UnityWebData1.0\0" + struct.pack("<I", directory_end))
    content = bytearray()
    for name, data in files:
        header.extend(struct.pack("<III", directory_end + len(content), len(data), len(name)))
        header.extend(name)
        content.extend(data)
    assert len(header) == directory_end
    # Preserve Unity's gzip filename/comment marker, which its loader detects.
    marker = b"UnityWeb Compressed Content (gzip)\0"
    header_end = compressed.index(marker) + len(marker)
    result = compressed[:header_end] + gzip.compress(header + content, compresslevel=6, mtime=0)[10:]
    assert gzip.decompress(result) == header + content
    TARGET.write_bytes(result)
    print("Disabled:", ", ".join(sorted(patched_names)))
    print("Patched SHA-256:", hashlib.sha256(result).hexdigest())


if __name__ == "__main__":
    patch()
