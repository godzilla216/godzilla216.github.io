const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const names = require('../html5game/real-names.js');
function read(file) {
    const lines = fs.readFileSync(path.join(__dirname,'../html5game',file),'utf8').trimEnd().split(/\r?\n/);
    const keys = lines.shift().replace(/^\uFEFF/,'').split('\t');
    return lines.filter(x => /^\d+\t/.test(x)).map(line => Object.fromEntries(line.split('\t').map((value,i)=>[keys[i] || 'uid', value])));
}
test('all 261 college identities agree with the uniforms and migration data', () => {
    const teams = read('v2/Teams_CO.txt'), uniforms = read('v2/uniforms_default_CO.txt');
    assert.equal(teams.length, 261); assert.equal(new Set(teams.map(t=>t.uid)).size, 261);
    for (const t of teams) {
        const u = uniforms.find(u=>u.uid===t.uid);
        assert.equal(t.name,u.name); assert.equal(t.tla,u.tla);
        assert.equal(t.name,names.data.teams[t.uid].name[1]);
        assert.equal(t.tla,names.data.teams[t.uid].tla[1]);
    }
});
test('every team retains a valid conference and rival ID', () => {
    const teams=read('v2/Teams_CO.txt'), conferences=read('v2/Conferences_CO.txt');
    for (const t of teams) {
        assert(conferences.some(c=>c.uid===t.conference), t.name);
        assert(t.rival === '-1' || teams.some(r=>r.uid===t.rival), t.name+' rival '+t.rival);
    }
});
test('all conference and competition display fields match the real names', () => {
    for (const [file,kind] of [['v2/Conferences_CO.txt','conferences'],['v2/Competitions_CO.txt','competitions']]) {
        for (const r of read(file)) for (const [field,change] of Object.entries(names.data[kind][r.uid])) assert.equal(r[field],change[1]);
    }
    const comps=read('v2/Competitions_CO.txt');
    for (const r of comps.filter(c=>Number(c.uid)>=1000&&Number(c.uid)<4000)) assert.equal(r.name,comps.find(c=>Number(c.uid)===1000+Number(r.uid)%1000).name);
});
test('all 32 pro draft destinations use the same NFL identities as fallback teams', () => {
    const teams=read('Teams.txt'), pro=read('ProTeams_CO.txt'); assert.equal(pro.length,32);
    pro.forEach(p=>{const t=teams.find(t=>t.uid===p.uid);assert.equal(p.name,t.name);assert.equal(p.tla,t.tla);});
    assert.equal(pro[19].name,'Washington Commanders');
});
test('migration changes matching defaults and leaves custom labels intact', () => {
    assert.equal(names.resolve('teams',34,'name','Durham'),'Duke');
    assert.equal(names.resolve('teams',34,'name','My Blue Devils'),'My Blue Devils');
    assert.equal(names.resolve('teams',999,'name','Custom Team'),'Custom Team');
    assert.equal(names.resolve('conferences',5,'name','Large X'),'Big Ten');
    assert.equal(names.resolve('conferences',5,'name','My Conference'),'My Conference');
    assert.equal(names.resolve('competitions',1001,'name','Lilac Bowl'),'Rose Bowl');
    assert.equal(names.resolve('competitions',1000,'name','FBS Championship'),'CFP National Championship');
    assert.equal(names.resolve('competitions',6001,'name','Atlantic Coast Championship'),'ACC Championship');
    assert.equal(names.resolve('competitions',1000,'name','Custom League Championship'),'Custom League Championship');
});
test('full names shrink to the original column width while generic text keeps its size', () => {
    assert.equal(names.textScale('MISSISSIPPI VALLEY STATE',184),96/184);
    assert.equal(names.textScale('Duke',32),1);
    assert.equal(names.textScale('Continue',200),1);
});
