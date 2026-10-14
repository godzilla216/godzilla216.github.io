# Retro Bowl College: GameMaker project rebuilt from the HTML5 build

Open `RetroBowlCollege/RetroBowlCollege.yyp` in GameMaker (2023.x or newer recommended; the game was built with a 2023 runtime).
The project uses the 2.3 / 2022 LTS file format, so newer versions of the IDE will offer to upgrade it on first open. Accept the upgrade.

## What was recovered
- 408 sprites (all frames, origins, bounding boxes, nine-slice), cut from the texture pages
- 27 sounds, 5 fonts (with glyph bitmaps), 24 paths, 1 shader
- 159 objects with all events, parents, sprites and variable definitions
- 57 rooms with layers, views, 832 placed instances, per-instance variable overrides and creation code
- 797 scripts: all game GML decompiled from the compiled JavaScript, including structs, methods, `with`, `switch`, and `repeat`
- The Poki extension (`uph_poki.js`) and its GML helpers (`scripts/poki_gml`)
- 24 included data files (`datafiles/`: teams, names, language strings, schedules, and so on)

## Known gaps
- **Music is missing from the export.** `snd_music.ogg` and `snd_music_co.ogg` were not in the folder,
  so they are 1-second silent `.wav` placeholders. Swap in the real tracks if you have them.
- Function parameter names were not kept by the compiler. They appear as `_arg0`, `_arg1`, and so on.
- `#macro` and `enum` names were inlined to numbers at compile time and cannot be recovered.
- Fonts use **Press Start 2P** and the game's other fonts. Install them so GameMaker can regenerate the bitmaps;
  the extracted bitmaps are included either way.
- `scripts/switch_stubs` holds no-op stand-ins for the Nintendo Switch functions the code references.
- This was not compiled in GameMaker during conversion, so expect a few compile errors on first build.

## Re-running the converter
`converter/` holds the Node.js scripts (`npm install acorn@8.12.1 pngjs@7.0.0`, then
`node build.js "<html5 export folder>" "<new empty output folder>"`).
