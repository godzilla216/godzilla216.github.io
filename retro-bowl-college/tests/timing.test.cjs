const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const timing = require('../html5game/timing.js');
const runner = fs.readFileSync(require('node:path').join(__dirname, '../html5game/RetroBowl.js'), 'utf8');

test('fixed steps remain identical across display rates and irregular frames', () => {
    for (const hz of [30, 60, 120, 144, 240, 360]) {
        const clock = timing.createClock();
        let ticks = 0;
        for (let i = 0; i <= hz * 10; i++) {
            const f = clock.advance(i * 1000 / hz, 60);
            ticks += f.steps;
            assert.equal(f.step, 1000 / 60);
            assert(f.alpha >= 0 && f.alpha <= 1);
        }
        assert.equal(ticks, 601, `${hz} Hz`);
    }
    const clock = timing.createClock();
    let ticks = clock.advance(0, 60).steps;
    for (const time of [7, 19, 31, 68, 82, 100]) ticks += clock.advance(time, 60).steps;
    assert.equal(ticks, 7);
});

test('suspension, stalls, reset, and rate changes cannot create a catch-up spiral', () => {
    const clock = timing.createClock();
    clock.advance(0, 60);
    assert.equal(clock.advance(200, 60).steps, 8);
    assert.equal(clock.advance(10000, 60).steps, 0);
    assert.equal(clock.advance(10000 + 1000 / 60, 60).steps, 1);
    clock.reset();
    assert.equal(clock.advance(50000, 60).steps, 1);
    assert.equal(clock.advance(50001, 30).step, 1000 / 30);
});

test('interpolation restores simulation coordinates and ball height, including after a draw error', () => {
    const p = { x: 10, y: 20, gmlheight: 12, sprite_index: 1 };
    const old = timing.capture([p]);
    p.x = 20; p.y = 40; p.gmlheight = 20;
    const actual = { ...p };
    assert.throws(() => timing.render(old, [p], 0.25, () => {
        assert.equal(p.x, 12.5); assert.equal(p.y, 25); assert.equal(p.gmlheight, 14);
        throw Error('draw failed');
    }), /draw failed/);
    assert.deepEqual(p, actual);
});

test('teleports, destroyed instances, new instances, and sprite transitions do not interpolate', () => {
    for (const change of [p => { p.x = 1000; }, p => { p.sprite_index = 2; }, p => { p.marked = true; }]) {
        const p = { x: 10, y: 20, sprite_index: 1 }, old = timing.capture([p]);
        change(p); const actual = { ...p };
        timing.render(old, [p], 0.5, () => assert.deepEqual(p, actual));
    }
    const p = { x: 5, y: 8 };
    timing.render(new Map(), [p], 0, () => assert.equal(p.x, 5));
});

function runLoop(hz, irregular) {
    let now = 0, renders = 0, queued = 0, ticks = 0, pressed = true, actions = 0;
    const p = { x: 0, y: 0, gmlheight: 12, sprite_index: 1 };
    let speed = 6, vertical = 4, alarm = 1000;
    const ctx = {
        RetroTiming: timing, performance: { now: () => now }, Date: { now: () => now }, document: { hidden: false },
        window: { requestAnimFrame() { queued++; } }, _9E3() {},
        _e8: null, _v3: false, _t3: { _u3: () => 60, _19() { renders++; ctx.state[0]++; ctx._MX++; p.x += 0.01; } },
        _ZD3: 0, _WD3: 0, __D3: 0, _XD3: 0, _xz2: 0, g_pBuiltIn: {},
        _Wz2: false, _mM: true, _881: -1, _rE: { Options: {} }, _Hn: { _7c3: { _Vk: [p] } },
        state: [123], _MX: 0, _NX: 1, _PX: 2,
        _2m1: { _WA2(dt) { assert.equal(dt, 1000000 / 60); } }, _2n1: { _WA2() {} },
        _pF3() {}, _5o3() {}, _s63() {}, _u63() {}, _4F3() {},
        _7F3(dt) {
            assert.equal(dt, 1000 / 60); ticks++; alarm--;
            if (pressed) { actions++; pressed = false; }
            speed *= 0.9995; vertical -= 0.03; p.x += speed; p.gmlheight += vertical;
            ctx.state[0]++;
        }
    };
    vm.createContext(ctx);
    vm.runInContext(runner.slice(runner.indexOf('var retroFrameClock = null;')), ctx);
    const frames = irregular || Array.from({ length: hz * 2 + 1 }, (_, i) => i * 1000 / hz);
    for (const time of frames) { now = time; ctx._EE3(); }
    assert.equal(renders, frames.length);
    assert.equal(queued, frames.length, 'only one animation callback per display frame');
    assert.equal(actions, 1, 'pressed input is consumed once by simulation');
    assert.equal(ctx.state[0], 123 + ticks, 'render RNG changes are discarded');
    assert.equal(ctx._MX, 0);
    return { p, speed, vertical, alarm, ticks };
}

test('actual runner loop preserves movement, gravity, drag, alarms, input and RNG at 30–360 Hz', () => {
    const expected = runLoop(60);
    for (const hz of [30, 120, 144, 240, 360]) assert.deepEqual(runLoop(hz), expected, `${hz} Hz`);
    const frames = [0];
    while (frames.at(-1) < 2000) frames.push(Math.min(2000, frames.at(-1) + [7, 23, 39, 11][frames.length % 4]));
    assert.deepEqual(runLoop(0, frames), expected);
});
