# Drift Hunters

Run `node server.cjs` from this folder, then open http://localhost:8080.
Node.js is the only server dependency. To use another port, set `PORT` before
starting the server. Opening `index.html` directly cannot load Unity's files.

The empty game data archive has been restored from the matching
[game data archive](https://media.githubusercontent.com/media/EmulatorOS/gfile/main/drift/Build/ItchIO.data.unityweb).
The original code, framework, and memory files match the companion build
byte for byte. All game assets are now local; gameplay needs no external host.

Git LFS is not required. The patched archive is stored as nine ordinary
`Build/ItchIO.data.unityweb.part*` files, each at most 16 MiB. The browser loads
and assembles these files automatically using `dataParts` in `Build/ItchIO.json`.
Keep every part when cloning, downloading, or deploying this folder. This also
works on static hosting; no server-side joining or download from GitHub is used.
`.gitattributes` disables LFS filters for the build assets, and `.gitignore`
excludes the temporary full archive.

Run `node tools/package-data.cjs --check` to check all part sizes and the
reassembled archive's SHA-256 checksum.

The App Store, Google Play, and Watch Video controls are disabled in the scene,
including their image/button behaviours because startup scripts reactivate the
store GameObjects. External advertising/tracking resources and frames are
blocked by Content Security Policy, and promotional popups are disabled.

`TemplateData/game.js` checks downloads and data-directory bounds, displays
recoverable errors with a reload button, detects graphics context loss, and
releases completed download buffers. This is a compiled Unity 5.6 asm.js build
with a fixed 1 GiB heap. Its existing memory setting is retained; changing it
does not enable memory growth. A current desktop browser is recommended.

To reproduce the scene patch, restore the original matching data archive,
as `Build/ItchIO.data.unityweb`, install `UnityPy==1.25.4` for Python, then run
`python tools/remove-promotions.py` followed by `node tools/package-data.cjs`.
The script validates the source hash, patches only the three promotion objects
and their behaviours, verifies the saved bundle, and preserves Unity's gzip
marker. The packager verifies the split archive before removing the temporary
full file. Python and UnityPy are not needed to play.

Original data SHA-256: `b50603116417bb1d472acf0c2e76a5b560da960486081b4f257b0afcb8d9ab09`.
Patched data SHA-256: `474cb92b5eb1815aa90dc68e6472bc204829b6265fd37e95aaf9fd872c75a491`.

Verified in Chrome: garage without promotion badges, selecting Nishuri, loading
the track and driving; missing/empty/corrupt data, failed network requests,
missing loader, and direct-file startup all show a useful error instead of
leaving the loading screen stuck.
The split package was also verified by loading all nine parts and driving in
Chrome. Missing, empty, truncated, and interrupted middle-part downloads show
the reload message. Git stores the parts unchanged even with an inherited LFS
filter configured.
