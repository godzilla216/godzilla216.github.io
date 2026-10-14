// Updates display fields only. IDs, memberships, colors and scheduling stay intact.
const fs = require('node:fs');
const path = require('node:path');
const names = require('../html5game/real-names.js');
const root = path.resolve(__dirname, '../html5game');
const files = [
    ['v2/Teams_CO.txt', 'teams'], ['v2/uniforms_default_CO.txt', 'teams'],
    ['Teams.txt', 'teams'], ['ProTeams_CO.txt', 'teams'],
    ['v2/Conferences_CO.txt', 'conferences'], ['v2/Competitions_CO.txt', 'competitions']
];
for (const [file, kind] of files) {
    const target = path.join(root, file);
    const source = fs.readFileSync(target, 'utf8');
    const rows = source.split(/\r?\n/), keys = rows[0].split('\t');
    rows.forEach((row, i) => {
        if (!i || !/^(?:\/\/ )?\d+\t/.test(row)) return;
        const comment = row.startsWith('// ') ? '// ' : '';
        const cells = row.slice(comment.length).split('\t'), entry = names.data[kind][cells[0]];
        if (comment && !entry) {
            // Retired Pac-12 divisional row; cancelled games retain their marker.
            if (cells[0] === '114') cells[1] = 'Pac-12 South';
            rows[i] = comment + cells.join('\t');
            return;
        }
        if (!entry) throw new Error(`Missing ${kind} mapping for ${cells[0]}`);
        for (const [field, change] of Object.entries(entry)) {
            const column = keys.indexOf(field);
            if (column >= 0) cells[column] = change[1];
        }
        rows[i] = comment + cells.join('\t');
    });
    fs.writeFileSync(target, rows.join(source.includes('\r\n') ? '\r\n' : '\n'));
    console.log('Updated ' + file);
}
