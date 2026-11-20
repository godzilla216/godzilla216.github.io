import {readFile, mkdir, copyFile, cp, writeFile} from 'node:fs/promises';
import {pathToFileURL} from 'node:url';
import {API_BASE_URL} from '../app/config.js';
import pagesConfig from '../pages.config.json' with {type: 'json'};

export async function buildPages({output = new URL('../github-pages/', import.meta.url),
  apiBaseUrl = process.env.POLL_API_URL || pagesConfig.apiBaseUrl || API_BASE_URL} = {}) {
  if (!apiBaseUrl) throw new Error('Set API_BASE_URL in app/config.js, apiBaseUrl in pages.config.json, or POLL_API_URL to your Cloudflare Worker URL before building Pages.');
  const url = new URL(apiBaseUrl);
  const local = ['localhost', '127.0.0.1', '[::1]'].includes(url.hostname);
  if ((url.protocol !== 'https:' && !(local && url.protocol === 'http:')) ||
      url.username || url.password || url.pathname !== '/' || url.search || url.hash) {
    throw new Error('The voting API URL must be an HTTPS origin, e.g. https://fan-poll-api.example.workers.dev.');
  }
  const dest = name => new URL(name, output);
  await mkdir(output, {recursive: true});
  for (const file of ['index.html', 'favicon.svg', 'style.css', 'client.js', 'api.js', 'teams.json']) {
    await copyFile(new URL('../app/' + file, import.meta.url), dest(file));
  }
  const teams = JSON.parse(await readFile(dest('teams.json'), 'utf8'));
  await cp(new URL('../app/assets/', import.meta.url), dest('assets/'), {recursive: true});
  await writeFile(dest('config.js'), 'export const API_BASE_URL = ' + JSON.stringify(url.origin) + ';\n');
  await writeFile(dest('.nojekyll'), '');
  console.log('Built GitHub Pages frontend with ' + teams.length + ' teams. API: ' + url.origin);
}

if (process.argv[1] && pathToFileURL(process.argv[1]).href === import.meta.url) {
  await buildPages();
}
