const player = document.getElementById('game');

window.EJS_player = '#game';
window.EJS_core = 'gba';
window.EJS_gameUrl = new URL(player.dataset.rom, document.baseURI).href;
window.EJS_gameName = player.dataset.rom.replace(/\.gba$/i, '');
window.EJS_biosUrl = new URL('gba_bios.bin', document.baseURI).href;
window.EJS_pathtodata = 'https://cdn.emulatorjs.org/stable/data/';
window.EJS_startOnLoaded = true;
window.EJS_backgroundColor = '#000';
window.EJS_Buttons = {
    playPause: false,
    restart: false,
    mute: false,
    settings: false,
    fullscreen: false,
    saveState: false,
    loadState: false,
    screenRecord: false,
    gamepad: false,
    cheat: false,
    volume: false,
    saveSavFiles: false,
    loadSavFiles: false,
    quickSave: false,
    quickLoad: false,
    screenshot: false,
    cacheManager: false,
    exitEmulation: false
};

const loader = document.createElement('script');
loader.src = window.EJS_pathtodata + 'loader.js';
document.body.appendChild(loader);
