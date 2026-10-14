// Loads RetroBowl.js game section (JSON_game + compiled GML) and parses it with acorn.
const fs = require('fs');
const acorn = require('acorn');

function load(gameDir) {
  const src = fs.readFileSync(gameDir + '/html5game/RetroBowl.js', 'utf8');
  const lines = src.split('\n');
  let end = lines.findIndex(l => l.startsWith('var g_instance_names'));
  const gameSrc = lines.slice(0, end).join('\n');
  const runnerSrc = lines.slice(end).join('\n');
  const ast = acorn.parse(gameSrc, { ecmaVersion: 2022, sourceType: 'script', locations: false });
  return { src: gameSrc, runnerSrc, ast };
}
module.exports = { load };
