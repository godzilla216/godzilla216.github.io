# JanissaryBattles

The page uses a local, ad-free game bootstrap, runtime, and project data.
The advertising script, embedded ad SDK, More Games button, introductory
promotion, website banners, and promotional links have been removed. The SDK's event interface
remains in place so the game can continue without waiting for advertisements.
Game images, audio, physics, and supporting scripts still load from the
existing CDN; an internet connection is required.

The local files are based on the versions the original page loaded from
`yrgen73/janibatt`:

- `scripts/main.js`: `2be2779d6614a2a81660ba5a02fdded10d3ec337`
- `scripts/c3runtime.js`: `e4f1f41eabd5fe0fdbe9b03eb6ac3a5e4bfe5807`
- `data.json`: `d95f65ea762067b654c325de7739d401f844d37a`

Serve this directory with a local HTTP server to run the game.
