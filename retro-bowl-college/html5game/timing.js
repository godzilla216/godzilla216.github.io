/* Fixed simulation steps; display refresh rate never changes football physics. */
(function (root, factory) {
    var api = factory();
    if (typeof module === "object" && module.exports) module.exports = api;
    else root.RetroTiming = api;
})(typeof window === "object" ? window : globalThis, function () {
    "use strict";
    function createClock() {
        var last = null, remainder = 0, previousRate = 0;
        return {
            reset: function () { last = null; remainder = 0; },
            advance: function (now, rate) {
                rate = Number.isFinite(rate) && rate > 0 ? rate : 60;
                var step = 1000 / rate;
                if (last === null || rate !== previousRate) {
                    last = now; previousRate = rate; remainder = 0;
                    return { steps: 1, step: step, alpha: 0 };
                }
                var elapsed = Math.max(0, now - last);
                last = now;
                // Do not replay a suspended tab, or spiral after a long stall.
                if (elapsed > 250) { remainder = 0; return { steps: 0, step: step, alpha: 1 }; }
                remainder += elapsed;
                var due = Math.floor((remainder + 1e-7) / step);
                remainder = Math.max(0, remainder - due * step);
                return { steps: Math.min(8, due), step: step, alpha: Math.min(1, remainder / step) };
            }
        };
    }
    var fields = ["x", "y", "gmlheight", "gmlz"];
    function capture(instances) {
        var result = new Map();
        instances.forEach(function (p) {
            if (!p || p.marked || p.active === false) return;
            var pose = { sprite: p.sprite_index };
            fields.forEach(function (key) { if (Number.isFinite(p[key])) pose[key] = p[key]; });
            result.set(p, pose);
        });
        return result;
    }
    function render(previous, instances, alpha, draw) {
        var restore = [];
        try {
            instances.forEach(function (p) {
                var old = previous && previous.get(p);
                if (!old || p.marked || p.active === false || old.sprite !== p.sprite_index) return;
                // A formation reset, room change or teleport must appear instantly.
                if (Math.hypot(p.x - old.x, p.y - old.y) > 128) return;
                fields.forEach(function (key) {
                    if (!Number.isFinite(old[key]) || !Number.isFinite(p[key])) return;
                    restore.push([p, key, p[key]]);
                    p[key] = old[key] + (p[key] - old[key]) * alpha;
                });
            });
            return draw();
        } finally {
            restore.forEach(function (entry) { entry[0][entry[1]] = entry[2]; });
        }
    }
    return { createClock: createClock, capture: capture, render: render };
});
