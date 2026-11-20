import {readFile, readdir, mkdir} from 'node:fs/promises';
import {createServer} from 'node:http';
import {DatabaseSync} from 'node:sqlite';
import {dirname, resolve} from 'node:path';
import {fileURLToPath} from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));

export function readOptions(args) {
  let host = process.env.HOST || '127.0.0.1';
  let port = Number(process.env.PORT || 4173);
  for (let index = 0; index < args.length; index++) {
    const flag = args[index];
    if (flag === '--port') {
      const value = args[++index];
      if (!value || value.startsWith('--')) throw new Error('--port requires a port number.');
      port = Number(value);
    } else if (flag === '--host') {
      host = args[index + 1] && !args[index + 1].startsWith('--') ? args[++index] : '0.0.0.0';
    } else {
      throw new Error('Unknown option: ' + flag);
    }
  }
  if (!Number.isInteger(port) || port < 0 || port > 65535) throw new Error('Port must be an integer between 0 and 65535.');
  return {host, port, databasePath: process.env.POLL_DB_PATH || resolve(root, '.data/ballots.sqlite')};
}

export async function startServer({host = '127.0.0.1', port = 4173,
  databasePath = resolve(root, '.data/ballots.sqlite'), apiEnv = {}} = {}) {
  const {default: worker} = await import('../dist/server/index.js');
  if (databasePath !== ':memory:') await mkdir(dirname(resolve(databasePath)), {recursive: true});
  const sqlite = new DatabaseSync(databasePath);
  try {
    sqlite.exec('PRAGMA busy_timeout = 5000; PRAGMA journal_mode = WAL;');
    sqlite.exec('CREATE TABLE IF NOT EXISTS _migrations (name TEXT PRIMARY KEY NOT NULL)');
    for (const name of (await readdir(resolve(root, 'drizzle'))).filter(name => name.endsWith('.sql')).sort()) {
      if (sqlite.prepare('SELECT name FROM _migrations WHERE name = ?').get(name)) continue;
      const sql = await readFile(resolve(root, 'drizzle', name), 'utf8');
      sqlite.exec('BEGIN');
      try {
        sqlite.exec(sql);
        sqlite.prepare('INSERT INTO _migrations (name) VALUES (?)').run(name);
        sqlite.exec('COMMIT');
      } catch (error) {
        sqlite.exec('ROLLBACK');
        throw error;
      }
    }
  } catch (error) {
    sqlite.close();
    throw error;
  }
  const DB = {
    prepare(sql) {
      const statement = sqlite.prepare(sql);
      let params = [];
      return {
        bind(...values) { params = values; return this; },
        first() { return statement.get(...params); },
        run() { return statement.run(...params); },
        all() { return {results: statement.all(...params)}; }
      };
    }
  };
  const server = createServer(async (req, res) => {
    try {
      const headers = new Headers();
      for (const [name, value] of Object.entries(req.headers)) {
        if (Array.isArray(value)) value.forEach(item => headers.append(name, item));
        else if (value !== undefined) headers.set(name, value);
      }
      // Local visitors use their own cookie. Only the hosted proxy can assert an account identity.
      headers.delete('oai-authenticated-user-id');
      headers.delete('x-preview-user');
      const chunks = [];
      let size = 0;
      for await (const chunk of req) {
        size += chunk.length;
        if (size > 4096) {
          res.writeHead(413, {'Content-Type': 'application/json'});
          res.end(JSON.stringify({error: 'The ballot is too large.'}));
          return;
        }
        chunks.push(chunk);
      }
      const url = new URL(req.url, 'http://' + req.headers.host);
      const request = new Request(url, {
        method: req.method,
        headers,
        body: chunks.length ? Buffer.concat(chunks) : undefined
      });
      const response = await worker.fetch(request, {...apiEnv, DB});
      res.writeHead(response.status, Object.fromEntries(response.headers));
      res.end(Buffer.from(await response.arrayBuffer()));
    } catch (error) {
      console.error('Poll request failed', error);
      if (!res.headersSent) res.writeHead(500, {'Content-Type': 'application/json'});
      res.end(JSON.stringify({error: 'The request could not be completed. Please try again.'}));
    }
  });
  server.once('close', () => sqlite.close());
  await new Promise((resolve, reject) => {
    const onError = error => { sqlite.close(); reject(error); };
    server.once('error', onError);
    server.listen(port, host, () => { server.off('error', onError); resolve(); });
  });
  return server;
}
