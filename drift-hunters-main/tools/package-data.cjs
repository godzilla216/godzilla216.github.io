// Split the patched Unity archive into regular Git files; no dependencies.
// Run after remove-promotions.py, or use --check to verify packaged assets.
const fs = require("node:fs");
const path = require("node:path");
const crypto = require("node:crypto");
const zlib = require("node:zlib");

const build = path.resolve(__dirname, "../Build");
const source = path.join(build, "ItchIO.data.unityweb");
const manifestPath = path.join(build, "ItchIO.json");
const partSize = 16 * 1024 * 1024;
const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
const hash = (bytes) => crypto.createHash("sha256").update(bytes).digest("hex");

function verify() {
  if (!Array.isArray(manifest.dataParts) || !manifest.dataParts.length) {
    throw new Error("No data parts in Build/ItchIO.json");
  }
  const digest = crypto.createHash("sha256");
  let total = 0;
  const names = new Set();
  for (const part of manifest.dataParts) {
    if (!/^ItchIO\.data\.unityweb\.part\d+$/.test(part.url) || names.has(part.url)) {
      throw new Error("Invalid or duplicate part name");
    }
    names.add(part.url);
    const bytes = fs.readFileSync(path.join(build, part.url));
    if (bytes.length !== part.size || !bytes.length || bytes.length > partSize) {
      throw new Error("Invalid part size: " + part.url);
    }
    digest.update(bytes);
    total += bytes.length;
  }
  if (manifest.dataUrl !== manifest.dataParts[0].url || digest.digest("hex") !== manifest.dataSha256) {
    throw new Error("Game data checksum or entry URL does not match");
  }
  console.log("Verified " + manifest.dataParts.length + " regular Git files (" + total + " bytes), SHA-256 " + manifest.dataSha256);
}

if (process.argv.includes("--check") || !fs.existsSync(source)) {
  verify();
} else {
  const archive = fs.readFileSync(source);
  if (archive.subarray(0, 40).toString().startsWith("version https://git-lfs.github.com/spec/")) {
    throw new Error("The source is an LFS pointer. Restore the full matching archive before packaging.");
  }
  if (zlib.gunzipSync(archive).subarray(0, 16).toString() !== "UnityWebData1.0\0") {
    throw new Error("The source is not a valid Unity data archive");
  }
  const parts = [];
  for (let offset = 0; offset < archive.length; offset += partSize) {
    const bytes = archive.subarray(offset, offset + partSize);
    const url = "ItchIO.data.unityweb.part" + String(parts.length).padStart(2, "0");
    fs.writeFileSync(path.join(build, url), bytes);
    parts.push({ url, size: bytes.length });
  }
  manifest.dataUrl = parts[0].url;
  manifest.dataParts = parts;
  manifest.dataSha256 = hash(archive);
  verify();
  fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2) + "\n");
  // The exact archive has been preserved in verified parts; remove the large
  // intermediate so uploading this project does not include a giant file.
  fs.unlinkSync(source);
}
