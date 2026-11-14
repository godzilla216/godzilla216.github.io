// No dependencies: run `node server.cjs` and open http://localhost:8080.
const http = require("node:http");
const fs = require("node:fs");
const path = require("node:path");

const root = __dirname;
const types = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".json": "application/json", ".png": "image/png", ".jpg": "image/jpeg", ".ico": "image/x-icon" };
const server = http.createServer((request, response) => {
  let file;
  try {
    const pathname = decodeURIComponent(new URL(request.url, "http://localhost").pathname);
    file = path.resolve(root, "." + (pathname === "/" ? "/index.html" : pathname));
  } catch {
    response.writeHead(400).end("Invalid URL");
    return;
  }
  if (!file.startsWith(root + path.sep)) {
    response.writeHead(403).end("Forbidden");
    return;
  }
  if (request.method !== "GET" && request.method !== "HEAD") {
    response.writeHead(405, { Allow: "GET, HEAD" }).end();
    return;
  }
  fs.stat(file, (error, stat) => {
    if (error || !stat.isFile()) {
      response.writeHead(404).end("Not found");
      return;
    }
    response.writeHead(200, {
      "Content-Type": types[path.extname(file)] || "application/octet-stream",
      "Content-Length": stat.size,
      // UnityLoader decompresses .unityweb files itself. Do not set Content-Encoding.
      "Cache-Control": "no-cache"
    });
    if (request.method === "HEAD") response.end();
    else fs.createReadStream(file).on("error", () => response.destroy()).pipe(response);
  });
});
server.on("error", (error) => {
  console.error("Could not start game server: " + error.message);
  process.exitCode = 1;
});
server.listen(Number(process.env.PORT || 8080), "127.0.0.1", () => {
  console.log("Drift Hunters: http://localhost:" + server.address().port);
});
