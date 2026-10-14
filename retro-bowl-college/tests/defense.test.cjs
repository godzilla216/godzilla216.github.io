const test = require('node:test');
const assert = require('node:assert/strict');
const logic = require('../html5game/defense.js').logic;
const player = (id, x = 1000, y = 300) => ({ id, x, y, gmlinum: id, gmloffense: false, gmldead: false, gmlanim: 0, active: true });

for (const name of Object.keys(logic.FORMATIONS)) {
    test(`${name} has eleven distinct, bounded assignments in both directions`, () => {
        for (const dir of [-1, 1]) for (const scrim of [300, 1000, 2300]) {
            const slots = logic.formation(name, scrim, dir, 300);
            assert.equal(slots.length, 11);
            assert.equal(new Set(slots.map(s => `${s.x},${s.y}`)).size, 11);
            assert.deepEqual(['DL', 'LB', 'CB', 'S'].map(role => slots.filter(s => s.role === role).length), logic.FORMATIONS[name]);
            assert(slots.every(s => s.x >= 145 && s.x <= 2455 && s.y >= 134 && s.y <= 466));
        }
    });
}
test('switching cycles eligible defenders and ignores stale, fallen and inactive players', () => {
    const list = [player(1), player(2), player(3), player(4)];
    list[1].gmldead = true; list[2].marked = true; list[3].active = false;
    assert.equal(logic.chooseNext(list, 99), 1);
    assert.equal(logic.chooseNext(list, 1), 1);
    assert.equal(logic.chooseNext(list.slice(1), 99), null);
    assert.equal(logic.chooseNext([player(2), player(1)], 1), 2);
});
test('pursuit leads a moving carrier and clamps to the field', () => {
    const target = logic.pursuit(player(1, 800), { x: 1000, y: 300, hspeed: 2, vspeed: 1 });
    assert(target.x > 1000 && target.y > 300);
    assert.equal(logic.pursuit(player(1), { x: 2450, y: 465, hspeed: 5, vspeed: 5 }).x, 2455);
});
test('separation resolves exact overlaps deterministically without self repulsion', () => {
    const a = player(1), b = player(2);
    assert.equal(logic.separate(a, [a]).x, 0);
    assert(logic.separate(a, [a, b]).x < 0);
    assert(logic.separate(b, [a, b]).x > 0);
    assert.deepEqual(logic.separate(a, [player(2, 1100)]), { x: 0, y: 0 });
});
test('only a live opposing carrier inside tackle range can be tackled', () => {
    const p = player(1), carrier = { ...player(2, 1010), gmloffense: true }, ball = { gmlholder: 2, gmlstate: 5, gmlis_dead: false };
    assert(logic.canTackle(p, carrier, ball, true, 14));
    assert(!logic.canTackle(p, carrier, ball, false, 14));
    assert(!logic.canTackle(p, { ...carrier, id: 3 }, ball, true, 14));
    assert(!logic.canTackle(p, { ...carrier, x: 1040 }, ball, true, 14));
    assert(!logic.canTackle(p, { ...carrier, gmloffense: false }, ball, true, 14));
    assert(!logic.canTackle(p, carrier, { ...ball, gmlis_dead: true }, true, 14));
    for (const state of [0, 3, 4, 6, 7, 8, 11, 12, 15, 21]) assert(!logic.canTackle(p, carrier, { ...ball, gmlstate: state }, true, 14));
    assert(!logic.canTackle(p, null, ball, true, 14));
});
test('quarterback can be tackled before throwing; returned interceptions can be tackled by offense', () => {
    const qb = { ...player(2, 1010), gmloffense: true, gmlposition: 1 };
    assert(logic.canTackle(player(1), qb, { gmlholder: 2, gmlstate: 18 }, true, 14));
    const returner = player(1);
    assert(logic.canTackle(qb, returner, { gmlholder: 1, gmlstate: 9 }, true, 14));
});
test('ballistic pass prediction matches the native gravity and drag in both directions', () => {
    for (const dx of [-400, 400]) {
        const qb = { x: 1300, y: 300 }, receiver = { x: 1300 + dx, y: 350, hspeed: dx / 400, vspeed: -0.25 };
        const flight = logic.passTrajectory(qb, receiver, 40);
        let x = qb.x, y = qb.y, z = 1, v = flight.velocity, vz = flight.zvel;
        for (let i = 0; i < 40; i++) { v *= .986; vz -= .08; x += Math.cos(flight.direction * Math.PI / 180) * v; y += Math.sin(flight.direction * Math.PI / 180) * v; z += vz; }
        assert(Math.abs(x - flight.x) < 1e-8 && Math.abs(y - flight.y) < 1e-8 && z > 15 && z < 30);
        for (let i = 0; i < 12; i++) { vz -= .08; z += vz; }
        assert(Math.abs(z - 1) < 1e-8);
    }
});
test('AI distinguishes pressure, receiver coverage, deep safety and run pursuit', () => {
    const qb = { ...player(9, 950), gmloffense: true, gmlposition: 1 }, receiver = player(8, 1200, 160);
    const ctx = { ball: { gmlstate: 18 }, carrier: qb, running: false, receivers: [receiver], direction: 1, scrim: 1000, call: 'Pass' };
    const p = { ...player(1), _defHome: { x: 1100, y: 300 }, _defAssignment: 0, _defRole: 'DL' };
    assert.equal(logic.aiTarget(p, ctx).x, 950);
    assert.equal(logic.aiTarget({ ...p, _defRole: 'CB' }, ctx).x, 1226);
    assert.equal(logic.aiTarget({ ...p, _defRole: 'S' }, ctx).x, 1260);
    assert.equal(logic.aiTarget({ ...p, _defRole: 'LB' }, { ...ctx, call: 'Blitz' }).x, 950);
    assert.equal(logic.aiTarget({ ...p, _defRole: 'S' }, { ...ctx, running: true }).x, 950);
    assert.deepEqual(logic.aiTarget(p, { ...ctx, ball: { gmlstate: 3 }, landing: { x: 1500, y: 240 } }), { x: 1500, y: 240 });
});
test('input vectors have no diagonal speed bonus and tolerate zero input', () => {
    assert.deepEqual(logic.unit(0, 0), { x: 0, y: 0 });
    assert(Math.abs(Math.hypot(...Object.values(logic.unit(1, 1))) - 1) < 1e-12);
});
test('fumble opportunities are reproducible, infrequent, and depend on player ratings', () => {
    assert(logic.fumbleOpportunity(24, 1, 8, 3));
    assert(!logic.fumbleOpportunity(24, 1, 3, 8));
    assert(!logic.fumbleOpportunity(25, 1, 8, 3));
    assert.equal(Array.from({ length: 29 }, (_, n) => logic.fumbleOpportunity(n, 1, 8, 3)).filter(Boolean).length, 1);
});
