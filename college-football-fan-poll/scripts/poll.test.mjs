import '../scripts/build.mjs';
import './build-cloudflare.mjs';
import assert from 'node:assert/strict';
import {test} from 'node:test';
import {mkdtemp, readFile, rm, stat} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {pathToFileURL} from 'node:url';
import {createServer} from 'node:http';
import {startServer, readOptions} from './server.mjs';
import {createPollApi} from '../app/api.js';
import {buildPages} from './build-pages.mjs';

const teams = JSON.parse(await readFile(new URL('../app/teams.json', import.meta.url), 'utf8'));
const picks = teams.slice(0, 25).map(team => team.id);
const stop = server => new Promise((resolve, reject) => server.close(error => error ? reject(error) : resolve()));

test('server arguments validate ports and support a bare --host', () => {
  assert.equal(readOptions(['--host', '--port', '8080']).host, '0.0.0.0');
  assert.equal(readOptions(['--host', 'localhost', '--port', '0']).port, 0);
  for (const args of [['--port'], ['--port', '-1'], ['--port', 'abc'], ['--port', '65536'], ['--unknown']]) {
    assert.throws(() => readOptions(args));
  }
});

test('ballots are isolated, scored, updated, validated, and persisted across restarts', async t => {
  const directory = await mkdtemp(join(tmpdir(), 'fan-poll-test-'));
  const databasePath = join(directory, 'ballots.sqlite');
  let server;
  t.after(async () => {
    if (server?.listening) await stop(server);
    await rm(directory, {recursive: true, force: true});
  });
  server = await startServer({port: 0, databasePath});
  let base = 'http://127.0.0.1:' + server.address().port;
  const api = (path, options) => fetch(base + path, options);
  const ballot = cookie => api('/api/ballot', {headers: {Cookie: cookie}});
  const save = (cookie, value, headers = {}) => api('/api/ballot', {
    method: 'PUT', headers: {Cookie: cookie, 'Content-Type': 'application/json', ...headers},
    body: JSON.stringify({teams: value})
  });
  const visitorA = await api('/api/ballot');
  const visitorB = await api('/api/ballot');
  assert.deepEqual(await visitorA.json(), {teams: []});
  const cookieA = visitorA.headers.get('set-cookie').split(';')[0];
  const cookieB = visitorB.headers.get('set-cookie').split(';')[0];
  assert.notEqual(cookieA, cookieB);
  assert.match(cookieA, /^fan-ballot=/);
  assert.doesNotMatch(visitorA.headers.get('set-cookie'), /; Secure/);
  assert.deepEqual(await (await api('/api/rankings')).json(), {count: 0, rankings: []});
  assert.equal((await save(cookieA, picks)).status, 200);
  assert.deepEqual(await (await ballot(cookieA)).json(), {teams: picks});
  assert.deepEqual(await (await ballot(cookieB)).json(), {teams: []});

  const reversed = picks.toReversed();
  assert.equal((await save(cookieB, reversed)).status, 200);
  let results = await (await api('/api/rankings')).json();
  assert.equal(results.count, 2);
  assert.equal(results.rankings.length, 25);
  assert.ok(results.rankings.every(row => row.points === 26));
  assert.equal(results.rankings.filter(row => row.firsts === 1).length, 2);

  assert.equal((await save(cookieA, reversed)).status, 200);
  results = await (await api('/api/rankings')).json();
  assert.equal(results.count, 2, 'editing a ballot must not add another voter');
  assert.deepEqual(results.rankings[0], {id: reversed[0], points: 50, firsts: 2});
  assert.equal(results.rankings.at(-1).points, 2);

  await t.test('invalid submissions do not alter stored votes', async () => {
    for (const invalid of [picks.slice(1), [...picks, '99999'], Array(25).fill(picks[0]), ['99999', ...picks.slice(1)]]) {
      assert.equal((await save(cookieA, invalid)).status, 400);
    }
    assert.equal((await save('', picks)).status, 400);
    assert.equal((await save(cookieA, picks, {Origin: 'https://other.example'})).status, 403);
    assert.equal((await save(cookieA, picks, {'Content-Type': 'text/plain'})).status, 415);
    assert.equal((await api('/api/ballot', {method: 'PUT', headers: {Cookie: cookieA, 'Content-Type': 'application/json'}, body: '{'})).status, 400);
    assert.equal((await api('/api/ballot', {method: 'PUT', body: 'x'.repeat(4097)})).status, 413);
    assert.deepEqual(await (await ballot(cookieA)).json(), {teams: reversed});
  });

  await t.test('local callers cannot impersonate another voter with preview headers', async () => {
    const response = await api('/api/ballot', {headers: {'x-preview-user': 'local-preview', 'oai-authenticated-user-id': 'local-preview'}});
    assert.deepEqual(await response.json(), {teams: []});
    assert.ok(response.headers.get('set-cookie'));
  });

  await t.test('the page, client, directory, and every logo are served', async () => {
    const response = await api('/');
    assert.match(await response.text(), /College Football Fan Poll/);
    assert.equal((await api('/client.js')).headers.get('content-type'), 'text/javascript; charset=utf-8');
    assert.equal((await api('/ratings.js')).headers.get('content-type'), 'text/javascript; charset=utf-8');
    assert.equal((await (await api('/teams.json')).json()).length, 138);
    for (const team of teams) {
      const image = await api('/assets/' + team.id + '.webp');
      assert.equal(image.status, 200);
      assert.equal(image.headers.get('content-type'), 'image/webp');
      assert.ok((await image.arrayBuffer()).byteLength > 0);
    }
    assert.equal((await api('/', {method: 'HEAD'})).status, 200);
    assert.equal((await api('/', {method: 'POST'})).status, 405);
    assert.equal((await api('/missing')).status, 404);
    assert.equal((await api('/api/missing')).status, 404);
    assert.equal((await api('/api/rankings', {method: 'POST'})).status, 405);
  });

  await stop(server);
  server = await startServer({port: 0, databasePath});
  base = 'http://127.0.0.1:' + server.address().port;
  assert.deepEqual(await (await ballot(cookieA)).json(), {teams: reversed});
  assert.deepEqual(await (await api('/api/rankings')).json(), results);
});

test('hosted HTTPS visitors retain secure cookies and authenticated identities', async () => {
  const {default: worker} = await import('../dist/server/index.js');
  const response = await worker.fetch(new Request('https://poll.example/api/ballot'), {});
  assert.match(response.headers.get('set-cookie'), /^__Host-fan-ballot=/);
  assert.match(response.headers.get('set-cookie'), /; Secure/);
  let voter;
  const DB = {prepare() { return {bind(id) { voter = id; return this; }, first() { return {teams: JSON.stringify(picks)}; }}; }};
  const saved = await worker.fetch(new Request('https://poll.example/api/ballot', {
    headers: {'oai-authenticated-user-id': 'account-123'}
  }), {DB});
  assert.equal(voter, 'account-123');
  assert.deepEqual(await saved.json(), {teams: picks});
  const cookie = response.headers.get('set-cookie').split(';')[0];
  await worker.fetch(new Request('https://poll.example/api/ballot', {headers: {Cookie: cookie}}), {DB});
  assert.equal(voter, 'guest:' + cookie.split('=')[1]);
});

test('ratings proxy restricts upstream resources, strips visitor credentials, and caches requests', async t => {
  let requests = 0;
  let lastUrl;
  const RATINGS_FETCH = async (url, options) => {
    requests++;
    lastUrl = url;
    assert.deepEqual(options.headers, {Accept: 'application/json'});
    await new Promise(resolve => setTimeout(resolve, 20));
    return Response.json({season: {year: 2026}, events: [], children: []});
  };
  const server = await startServer({port: 0, databasePath: ':memory:', apiEnv: {RATINGS_FETCH}});
  t.after(() => stop(server));
  const base = 'http://localhost:' + server.address().port;
  const path = '/api/ratings-data/standings?group=80';
  const responses = await Promise.all(Array.from({length: 3}, () => fetch(base + path, {
    headers: {Cookie: 'private-cookie', Authorization: 'Bearer private-token'}
  })));
  assert.ok(responses.every(response => response.status === 200));
  assert.equal(requests, 1, 'concurrent upstream requests are shared');
  assert.equal((await fetch(base + path)).status, 200);
  assert.equal(requests, 1, 'successful source data is cached');
  assert.equal((await fetch(base + path + '&refresh=1')).status, 200);
  assert.equal(requests, 2);
  assert.equal((await fetch(base + '/api/ratings-data/schedule?team=' + teams[0].id + '&seasontype=2')).status, 200);
  assert.match(lastUrl, new RegExp('/teams/' + teams[0].id + '/schedule\\?season=2026&seasontype=2$'));
  for (const bad of ['/standings?group=https://evil.example', '/schedule?team=999999&seasontype=2',
    '/schedule?team=' + teams[0].id + '&seasontype=99']) {
    assert.equal((await fetch(base + '/api/ratings-data' + bad)).status, 400);
  }
  assert.equal((await fetch(base + path, {method: 'POST'})).status, 405);
  assert.equal((await fetch(base + '/api/ratings-data/missing')).status, 404);
  assert.equal(requests, 3, 'invalid routes never reach upstream');
});

test('ratings proxy reports failed or wrong-season sources and can retry them', async t => {
  let mode = 'failure';
  const server = await startServer({port: 0, databasePath: ':memory:', apiEnv: {
    RATINGS_FETCH: async () => mode === 'failure' ? new Response('offline', {status: 503})
      : Response.json({season: {year: mode === 'old' ? 2025 : 2026}, children: []})
  }});
  t.after(() => stop(server));
  const url = 'http://localhost:' + server.address().port + '/api/ratings-data/standings?group=81&refresh=1';
  assert.equal((await fetch(url)).status, 503);
  mode = 'old';
  assert.equal((await fetch(url)).status, 503);
  mode = 'current';
  assert.equal((await fetch(url)).status, 200);
});

test('Pages client submits and updates independent ballots through the cross-origin API', async t => {
  const origin = 'https://fans.example.github.io';
  const server = await startServer({port: 0, databasePath: ':memory:',
    apiEnv: {BROWSER_VOTERS_ONLY: true, ALLOWED_ORIGIN: origin}});
  t.after(() => stop(server));
  const apiBaseUrl = 'http://127.0.0.1:' + server.address().port;
  const fetchImpl = (url, options) => fetch(url, {...options,
    headers: new Headers([...options.headers, ['Origin', origin]])});
  const browserStorage = () => {
    const entries = new Map();
    return {getItem: key => entries.get(key) ?? null, setItem: (key, value) => entries.set(key, value)};
  };
  const storageA = browserStorage();
  const reader = storage => createPollApi({apiBaseUrl, fetchImpl, storage});
  const a = reader(storageA);
  const b = reader(browserStorage());

  const preflight = await fetch(apiBaseUrl + '/api/ballot', {method: 'OPTIONS', headers: {
    Origin: origin, 'Access-Control-Request-Method': 'PUT',
    'Access-Control-Request-Headers': 'authorization, content-type'
  }});
  assert.equal(preflight.status, 204);
  assert.equal(preflight.headers.get('access-control-allow-origin'), origin);
  assert.equal(preflight.headers.get('access-control-allow-credentials'), null);

  const first = await a('/api/ballot');
  const second = await b('/api/ballot');
  assert.notEqual(first.token, second.token);
  const save = (read, value) => read('/api/ballot', {method: 'PUT',
    headers: {'Content-Type': 'application/json'}, body: JSON.stringify({teams: value})});
  assert.deepEqual(await save(a, picks), {teams: picks});
  assert.deepEqual(await b('/api/ballot'), {teams: []});
  assert.deepEqual(await reader(storageA)('/api/ballot'), {teams: picks}, 'a fresh page should reuse the browser token');
  const reversed = picks.toReversed();
  await save(b, reversed);
  await save(a, reversed);
  const results = await a('/api/rankings');
  assert.equal(results.count, 2);
  assert.deepEqual(results.rankings[0], {id: reversed[0], points: 50, firsts: 2});
  await assert.rejects(save(a, picks.slice(1)), /Choose 25 different/);

  const denied = await fetch(apiBaseUrl + '/api/ballot', {headers: {Origin: 'https://evil.example'}});
  assert.equal(denied.status, 403);
  assert.equal(denied.headers.get('access-control-allow-origin'), null);
  const invalid = await fetch(apiBaseUrl + '/api/ballot', {method: 'PUT', headers: {
    Origin: origin, Authorization: 'Bearer invalid', 'Content-Type': 'application/json'
  }, body: JSON.stringify({teams: picks})});
  assert.equal(invalid.status, 400);
  assert.equal(invalid.headers.get('access-control-allow-origin'), origin);
  const invalidPreflight = await fetch(apiBaseUrl + '/api/ballot', {method: 'OPTIONS', headers: {
    Origin: origin, 'Access-Control-Request-Method': 'DELETE'
  }});
  assert.equal(invalidPreflight.status, 403);
});

test('public Cloudflare Worker ignores account headers and refuses an unconfigured origin', async () => {
  const {default: publicWorker} = await import('../cloudflare/worker.js');
  const request = new Request('https://api.example/api/ballot', {
    headers: {Origin: 'https://fans.example', 'oai-authenticated-user-id': 'spoofed-account'}
  });
  assert.equal((await publicWorker.fetch(request, {})).status, 503);
  const response = await publicWorker.fetch(request, {ALLOWED_ORIGIN: 'https://fans.example'});
  const data = await response.json();
  assert.equal(response.status, 200);
  assert.deepEqual(data.teams, []);
  assert.ok(data.token);
  assert.equal(response.headers.get('set-cookie'), null);
  assert.equal(response.headers.get('access-control-allow-origin'), 'https://fans.example');
});

test('client reports blocked storage and unavailable APIs without claiming a saved ballot', async () => {
  const read = createPollApi({apiBaseUrl: 'https://api.example', storage: {
    getItem() { throw new Error('blocked'); }
  }, fetchImpl() { assert.fail('blocked storage must be reported before sending a request'); }});
  await assert.rejects(read('/api/ballot'), /Allow site storage/);
  const unavailable = createPollApi({fetchImpl: async () => new Response('<html>404</html>', {status: 404})});
  await assert.rejects(unavailable('/api/ballot'), /voting service is unavailable/);
  let url;
  const assets = createPollApi({apiBaseUrl: 'https://api.example', fetchImpl: async value => {
    url = value; return Response.json(teams);
  }});
  assert.equal((await assets('./teams.json')).length, 138);
  assert.equal(url, './teams.json', 'team data must load from Pages, without a voter token');
});

test('Pages build serves every asset from a repository subpath and rejects missing API setup', async t => {
  const directory = await mkdtemp(join(tmpdir(), 'fan-poll-pages-'));
  const output = pathToFileURL(directory + '/');
  t.after(() => rm(directory, {recursive: true, force: true}));
  await assert.rejects(buildPages({output, apiBaseUrl: ''}), /Set API_BASE_URL/);
  for (const url of ['http://api.example', 'https://api.example/path', 'https://user:secret@api.example', 'https://api.example?secret=value']) {
    await assert.rejects(buildPages({output, apiBaseUrl: url}), /HTTPS origin/);
  }
  await buildPages({output, apiBaseUrl: 'https://api.example/'});
  assert.match(await readFile(join(directory, 'config.js'), 'utf8'), /https:\/\/api.example/);
  assert.ok(await stat(join(directory, '.nojekyll')));
  await assert.rejects(stat(join(directory, 'worker.js')), {code: 'ENOENT'});

  const server = createServer(async (req, res) => {
    try {
      const path = new URL(req.url, 'http://localhost').pathname;
      if (!path.startsWith('/fan-poll/')) { res.writeHead(404); res.end(); return; }
      const file = path.slice('/fan-poll/'.length) || 'index.html';
      res.end(await readFile(join(directory, file)));
    } catch { res.writeHead(404); res.end(); }
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  t.after(() => stop(server));
  const base = 'http://127.0.0.1:' + server.address().port + '/fan-poll/';
  const html = await (await fetch(base)).text();
  for (const path of ['./style.css', './client.js']) {
    assert.ok(html.includes('"' + path + '"'));
    assert.equal((await fetch(new URL(path, base))).status, 200);
  }
  const css = await (await fetch(new URL('./style.css', base))).text();
  assert.ok(css.includes("url('./assets/game-day.webp')"));
  const client = await (await fetch(new URL('./client.js', base))).text();
  assert.ok(client.includes("logo.src = './assets/'"));
  assert.ok(client.includes("read('./teams.json')"));
  for (const file of ['api.js', 'ratings.js', 'config.js', 'teams.json', 'assets/game-day.webp', ...teams.map(team => 'assets/' + team.id + '.webp')]) {
    const response = await fetch(new URL(file, base));
    assert.equal(response.status, 200, file);
    assert.ok((await response.arrayBuffer()).byteLength > 0);
  }
});
