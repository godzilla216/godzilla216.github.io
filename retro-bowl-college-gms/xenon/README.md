# Retro Bowl College — experimental Xbox 360/libxenon port

This is a hardware-test build, not a verified complete port. It embeds the supplied HTML5 game's JavaScript in QuickJS and supplies native software rendering, PNG loading, Ogg audio, USB saves, and controller-to-pointer input. The recovered GameMaker project is retained as supplied; this does not compile its GML with GameMaker.

## Install and launch

Requires an Xbox 360 already able to launch libxenon ELF applications through XeLL Reloaded (for example an appropriately configured RGH/JTAG console). It is not a retail dashboard XEX.

Extract the USB package to the root of a FAT32 USB drive, keeping this layout:

```
xenon.elf
Apps/RetroBowlCollege/data/bootstrap.js
Apps/RetroBowlCollege/data/port.js
Apps/RetroBowlCollege/data/html5game/...
```

Launch XeLL and let it load xenon.elf. Preserve an existing xenon.elf elsewhere before copying this one. No NAND flashing is needed for this application. The program scans mounted devices for Apps/RetroBowlCollege/data. Saves are written under that directory's saves/localstorage.json. Keep that file when updating; the package excludes development saves.

## Controls

- Left stick or D-pad: move the on-screen pointer.
- A or right trigger: hold/release the primary pointer button. Hold while moving to perform the game's drag-to-throw gesture.
- Back + Start + LB + RB: stop the game and display the console. Power-cycle to leave this diagnostic stop.

This export disables native gamepad UI and omits some of its initialization. The port uses the complete browser mouse path. Native console button prompts and multiplayer controllers are not implemented. Prefer a wired USB controller for the first test; wireless operation is unverified.

## Build from source (Linux / WSL)

Run inside retro-bowl-college-gms/xenon:

```
export DEVKITXENON=/usr/local/xenon
node tools/prepare.cjs ../..//retro-bowl-college
make xenon
make host
./build/retro-host data 600 ../tests/pointer.js
python3 tools/frame_png.py
node tools/package.cjs /absolute/path/to/new/package-folder
```

The HTML5 export argument is optional when data/html5game already exists. The installed toolchain was built from Free60Project/libxenon revision 7d75a30f81381f48fcaaa758290a2b9d144a8fd1. The Makefile rebuilds FAT support from vendored sources; it does not rely on preexisting .o or .a files. QuickJS is the supplied 2024-01-13 version, with Xenon threading/allocator adaptations, UTC timezone handling, PowerPC floating-point rounding support, and corrected big-endian detection.

## Validation and limitations

Validated on the development machine:

- Cross-build and link with xenon-gcc; ELF32 PowerPC big-endian header inspection.
- A 600-frame desktop runtime test: welcome screen, simulated controller pointer click to career setup, button release, and localStorage roundtrip.
- Visual inspection of the rendered welcome and career setup screens.
- AddressSanitizer/UndefinedBehaviorSanitizer checks of native raster fill/blit, invalid resize, and silent audio mixing.

Not validated: actual Xbox boot, display modes, controller hardware, sound output, USB save persistence on console, a complete match/season, sustained frame rate, and long-session memory usage. Rendering uses the CPU rather than Xenos GPU acceleration. The browser shim implements a subset of Canvas and WebAudio: text fallback, gradients, filters/panning, full input dialogs, and some drawing effects are incomplete. Career setup shows imperfect background/text contrast. The two music tracks are absent from the supplied export. Native surfaces have a fixed allocation limit, so long sessions remain experimental.

## Research sources

- Free60 libxenon build instructions: https://github.com/Free60Project/libxenon
- XeLL ELF loading and USB boot filenames: https://github.com/Free60Project/xell-reloaded
- libxenon console framebuffer tiling/cache behavior: https://github.com/Free60Project/libxenon/blob/master/libxenon/drivers/console/console.c
- libxenon audio format (48 kHz, stereo signed 16-bit little-endian): https://github.com/Free60Project/libxenon/blob/master/libxenon/drivers/xenon_sound/sound.h
- QuickJS embedding: https://bellard.org/quickjs/

Game content retains its existing ownership. Third-party sources and notices remain under vendor/ in the source tree; no game redistribution rights are granted by this port.

## Diagnostic build 2 — startup stall investigation

Startup now prints BOOT checkpoints, then READ/PARSE/EXECUTE/DONE for each script. A PARSE message on the 9 MB game script can take time on the console. The original startup made synchronous SMC clock requests while creating the FAT save folder and seeding QuickJS. This build substitutes CPU timebase time for the libc clock callback, avoiding that unbounded hardware wait. Calendar timestamps use build time plus uptime and are not the actual console clock. The USB saves directory is also created during installation.

Additional corrections: QuickJS uses newlib's actual allocation sizes so its memory limit works; timebase reads handle low-word rollover; audio refill is bounded per frame; errors no longer clear the console; short script reads fail explicitly. These changes have not yet been verified on the affected console.
