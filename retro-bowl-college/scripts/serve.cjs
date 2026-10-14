const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const port = Number(process.env.PORT || 8080);
const types = { '.html': 'text/html', '.js': 'text/javascript', '.txt': 'text/plain', '.json': 'application/json', '.png': 'image/png', '.ogg': 'audio/ogg' };
http.createServer((req, res) => {
    let file;
    try {
        const pathname = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
        file = path.resolve(root, '.' + (pathname === '/' ? '/index.html' : pathname));
    } catch { res.writeHead(400); res.end('Invalid path'); return; }
    if (!file.startsWith(root + path.sep)) { res.writeHead(403); res.end('Forbidden'); return; }
    fs.readFile(file, (error, data) => {
        res.writeHead(error ? 404 : 200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-cache' });
        res.end(error ? 'Not found' : data);
    });
}).listen(port, '127.0.0.1', () => console.log(`Retro Bowl College: http://127.0.0.1:${port}/`));
