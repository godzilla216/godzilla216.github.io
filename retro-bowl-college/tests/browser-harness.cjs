const fs = require('node:fs');
const path = require('node:path');
const http = require('node:http');
const { spawn } = require('node:child_process');
const sleep = ms => new Promise(r => setTimeout(r, ms));
async function openGame() {
    const root = path.resolve(__dirname, '..'), errors = [], external = [];
    const types = { '.html': 'text/html', '.js': 'text/javascript', '.txt': 'text/plain', '.json': 'application/json', '.png': 'image/png', '.ogg': 'audio/ogg' };
    const server = http.createServer((req, res) => {
        const pathname = new URL(req.url, 'http://127.0.0.1').pathname;
        if (pathname === '/favicon.ico') { res.writeHead(204); res.end(); return; }
        const file = path.resolve(root, '.' + (pathname === '/' ? '/index.html' : decodeURIComponent(pathname)));
        if (!file.startsWith(root + path.sep)) { res.writeHead(403); res.end(); return; }
        fs.readFile(file, (error, data) => { res.writeHead(error ? 404 : 200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream' }); res.end(error ? 'Not found' : data); });
    });
    await new Promise(r => server.listen(0, '127.0.0.1', r));
    const origin = `http://127.0.0.1:${server.address().port}/`;
    const profile = fs.mkdtempSync(path.join(require('node:os').tmpdir(), 'retro-bowl-defense-tests-'));
    const candidates = [process.env.CHROME_PATH, 'C:/Program Files/Google/Chrome/Application/chrome.exe', 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe', '/usr/bin/chromium', '/usr/bin/google-chrome'].filter(Boolean);
    const executable = candidates.find(p => fs.existsSync(p));
    if (!executable) { server.close(); throw new Error('Chrome/Chromium unavailable; set CHROME_PATH'); }
    const child = spawn(executable, ['--headless=new', '--no-first-run', '--no-default-browser-check', '--disable-background-networking', '--disable-background-timer-throttling', '--autoplay-policy=no-user-gesture-required', '--window-size=1280,720', `--user-data-dir=${profile}`, '--remote-debugging-port=0', 'about:blank'], { windowsHide: true, stdio: 'ignore' });
    let debugPort;
    for (let i = 0; i < 100; i++) { try { debugPort = fs.readFileSync(path.join(profile, 'DevToolsActivePort'), 'utf8').split('\n')[0]; break; } catch { await sleep(100); } }
    if (!debugPort) { child.kill(); server.close(); throw new Error('Browser startup timed out'); }
    const pages = await (await fetch(`http://127.0.0.1:${debugPort}/json`)).json();
    const ws = new WebSocket(pages.find(p => p.type === 'page').webSocketDebuggerUrl);
    await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = reject; });
    let id = 0;
    const pending = new Map();
    ws.onmessage = event => {
        const msg = JSON.parse(event.data);
        if (msg.method === 'Runtime.exceptionThrown') errors.push(msg.params.exceptionDetails);
        if (msg.method === 'Network.requestWillBeSent' && /^https?:/.test(msg.params.request.url) && !msg.params.request.url.startsWith(origin)) external.push(msg.params.request.url);
        if (pending.has(msg.id)) { pending.get(msg.id)(msg); pending.delete(msg.id); }
    };
    function send(method, params = {}) {
        return new Promise((resolve, reject) => {
            const next = ++id;
            const timer = setTimeout(() => { pending.delete(next); reject(new Error(`CDP timeout: ${method}`)); }, 15000);
            pending.set(next, msg => { clearTimeout(timer); resolve(msg); });
            ws.send(JSON.stringify({ id: next, method, params }));
        });
    }
    async function evaluate(expression) {
        const msg = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
        if (msg.error || msg.result.exceptionDetails) throw new Error(JSON.stringify(msg));
        return msg.result.result.value;
    }
    async function until(expression, timeout = 20000) {
        const started = Date.now();
        while (Date.now() - started < timeout) { if (await evaluate(expression)) return; await sleep(100); }
        throw new Error('Timed out waiting for: ' + expression + '\nState: ' + JSON.stringify(await evaluate('(function(){var m=GetWithArray(105)[0],c=GetWithArray(98)[0];return {room:room_get_name(g_pBuiltIn.room),careerStage:c&&c.gmlstage,match:m&&{state:m.gmlstate,stage:m.gmlcomm_stage,down:m.gmldown,possession:m.gmlpossession,ball:GetWithArray(global.gmlmaster_ball).map(function(b){return {state:b.gmlstate,dead:b.gmlis_dead}})}};})()')) + '\nErrors: ' + JSON.stringify(errors));
    }
    async function close() { try { await send('Browser.close'); } finally { ws.close(); child.kill(); server.close(); } }
    await send('Runtime.enable'); await send('Network.enable');
    await send('Emulation.setTouchEmulationEnabled', { enabled: true, maxTouchPoints: 2 });
    await send('Page.navigate', { url: origin });
    await until('typeof RetroDefense !== "undefined" && typeof GetWithArray === "function" && GetWithArray(98).length === 1 && g_pBuiltIn.room === 2');
    return { send, evaluate, until, close, sleep, errors, external, origin,
        async screenshot(file) { const result = await send('Page.captureScreenshot', { format: 'png' }); fs.writeFileSync(file, Buffer.from(result.result.data, 'base64')); }
    };
}
module.exports = { openGame };
