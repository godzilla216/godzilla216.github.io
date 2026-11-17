# Iron Snout

A self-contained copy of the **Iron Snout** HTML5 game — a fast-paced fighting game where you play as a pig battling waves of wolves using punches, kicks, and mid-air combos.

## How to Play

### With Docker

```bash
docker build -t ironsnout .
docker run -p 8080:80 ironsnout
```

Then open `http://localhost:8080` in your browser.

### Without Docker

Serve this folder with any static file server:

```bash
cd IRONSNOUT
python3 -m http.server 8000
```

Then open `http://localhost:8000` in your browser.

## Controls

- **Arrow keys** or **WASD** — move and attack
- **Up** — jump
- **Left/Right** — punch and kick in that direction

Combine directions mid-air for aerial combos.

## File Structure

```
IRONSNOUT/
├── index.html                  # Game launcher (HTML5 canvas)
├── html5game/                  # Core game assets
│   ├── IronSnout.js            # GameMaker HTML5 engine + game logic
│   ├── IronSnout_texture_*.png # Sprite sheets (5 texture files)
│   ├── snd_*.ogg               # Sound effects (punches, jumps, etc.)
│   ├── sound_*.ogg             # Additional hit/strike sounds
│   └── *.js                    # Local support scripts (callbacks, loading bar)
├── logo.png                    # Game logo
├── Dockerfile                  # Container build (nginx:alpine)
└── .dockerignore               # Files excluded from Docker build
```

## Technical Details

- Built with **GameMaker Studio** and exported to HTML5
- Renders on an HTML5 `<canvas>` element
- Runs without advertising SDKs, analytics scripts, browser fingerprinting, or promotional banners
- Uses local compatibility callbacks to complete legacy ad breaks and rewards immediately
- Restricts scripts, network connections, and game resources to the local origin with a Content Security Policy (embedded image/audio data and blobs are allowed)
- Audio in OGG format
- No build step or dependencies required — purely static files
- Containerized with **nginx:alpine** for lightweight deployment

The compiled export loads `html5game/offline-hooks.js` for legacy callback names only. Ad and analytics SDK files are removed; local scores, statistics, and saved progress still work. The compiled game's advertising loader, fingerprinting library, sponsor video, and promotional object handlers have also been removed. Preserve these changes if re-exporting the game.

## Credits

Iron Snout was created by **SnoutUp**.
