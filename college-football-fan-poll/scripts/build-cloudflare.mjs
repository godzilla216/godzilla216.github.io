import {readFile, mkdir, writeFile} from 'node:fs/promises';
import {RATING_SEASON} from '../app/ratings.js';

const root = new URL('../', import.meta.url);
const teams = await readFile(new URL('app/teams.json', root), 'utf8');
const assets = {'/teams.json': {type: 'application/json; charset=utf-8', body: teams}};
await mkdir(new URL('dist/cloudflare/', root), {recursive: true});
await writeFile(new URL('dist/cloudflare/poll.js', root),
  'const RATING_SEASON = ' + RATING_SEASON + ';\nconst ASSETS = ' + JSON.stringify(assets) + ';\n' + await readFile(new URL('app/worker.js', root), 'utf8'));
console.log('Built Cloudflare voting API for ' + JSON.parse(teams).length + ' teams.');
