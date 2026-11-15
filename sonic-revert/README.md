# Sonic Revert

Serve this folder over HTTP; opening `index.html` directly as a file will not load the Unity game.

With Node.js installed, run from this folder:

```powershell
npx.cmd --yes http-server . -a 127.0.0.1 -p 8080 -c-1
```

Open <http://127.0.0.1:8080>, click the game, and press Enter. Use the arrow keys to navigate menus and move, Space to jump, and Tab for the pause/course menu.

## Ads and tracking

The page has no third-party scripts. Inside the Unity data archive, the following settings are disabled: Unity Connect, analytics submission, analytics and ads initialization, crash reporting, purchasing, and performance reporting. Unity configuration, event, and crash-reporting URLs are cleared. Compiled Unity engine modules remain for runtime compatibility.

The page's Content Security Policy permits local assets and Photon multiplayer connections. It blocks other external scripts and connections, embedded frames, and plugins. Referrer information is disabled.

## Repaired game files

The supplied data and WebAssembly code files were both empty. They were restored from the matching [CycloKid/sonic-revert archive](https://github.com/CycloKid/sonic-revert/tree/938c293b495adfec91a0b199700e3d2cd22c0252). Its loader and framework matched the supplied copies byte for byte, and both restored files were verified against their Git LFS SHA-256 checksums before editing:

| File | Original SHA-256 |
| --- | --- |
| `Sonic Revert.data.unityweb` | `25de89c576472cbbd88727c4885be9726a36ade0a61dd44e2777e120f9b9dc8b` |
| `Sonic Revert.wasm.code.unityweb` | `848cd082b74d7c23bd32a8e3c5689e015ad9b780048ccf4d205f24ecc5cb7be3` |

The data archive was then updated with UnityPy to disable the services above. All 92,429 serialized objects were checked: only PlayerSettings and UnityConnectSettings changed; other objects retain their original bytes.

## Verification

Tested in Chrome on November 15, 2026: title/menu startup, tutorial, Green Hill course loading, movement, jumping, pause, course selection, and connection to the Photon multiplayer lobby. Offline gameplay made no external requests. Lobby traffic consisted of Photon WebSockets and region-latency checks, with no Content Security Policy violations or ad/analytics requests. A multiplayer race with another player was not tested.

The existing runtime produces harmless favicon 404 and Photon latency-check ETag/CORS console messages; these do not prevent the tested flows.
