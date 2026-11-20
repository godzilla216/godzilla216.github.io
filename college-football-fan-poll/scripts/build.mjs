import {readFile, readdir, mkdir, writeFile, copyFile} from 'node:fs/promises';

const assets = {};
for (const [route, filename, type] of [
  ['/', 'index.html', 'text/html; charset=utf-8'],
  ['/favicon.svg', 'favicon.svg', 'image/svg+xml'],
  ['/style.css', 'style.css', 'text/css; charset=utf-8'],
  ['/client.js', 'client.js', 'text/javascript; charset=utf-8'],
  ['/api.js', 'api.js', 'text/javascript; charset=utf-8'],
  ['/config.js', 'config.js', 'text/javascript; charset=utf-8'],
  ['/teams.json', 'teams.json', 'application/json; charset=utf-8']
]) {
  assets[route] = {type, body: await readFile('app/' + filename, 'utf8')};
}
for (const file of (await readdir('app/assets')).sort()) {
  assets['/assets/' + file] = {
    type: 'image/webp',
    binary: true,
    body: await readFile('app/assets/' + file, 'base64')
  };
}
const teams = JSON.parse(assets['/teams.json'].body);
if (teams.some(team => !assets['/assets/' + team.id + '.webp'])) {
  throw new Error('Every team must have its logo.');
}
await mkdir('dist/server', {recursive:true});
await mkdir('dist/.openai', {recursive:true});
await mkdir('dist/drizzle', {recursive:true});
await copyFile('.openai/hosting.json', 'dist/.openai/hosting.json');
for (const file of (await readdir('drizzle')).sort()) {
  if (file.endsWith('.sql')) await copyFile('drizzle/' + file, 'dist/drizzle/' + file);
}
await writeFile('dist/server/index.js', 'const ASSETS = ' + JSON.stringify(assets) + ';\n' +
  await readFile('app/worker.js', 'utf8'));
console.log('Built poll with ' + teams.length + ' FBS teams and logos.');
