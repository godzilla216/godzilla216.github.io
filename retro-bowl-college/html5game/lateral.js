/* User-controlled backward/lateral pitches. Misses use the native loose ball. */
(function (root, factory) {
    var api = factory(root);
    if (typeof module === "object" && module.exports) module.exports = api;
    else root.RetroLateral = api;
})(typeof window === "object" ? window : globalThis, function (r) {
    "use strict";
    var MAX_RANGE = 140; // Seven yards at the native twenty pixels per yard.
    function clamp(n, lo, hi) { return Math.max(lo, Math.min(hi, n)); }
    function distance(a, b) { return Math.hypot(a.x - b.x, a.y - b.y); }
    function available(p) {
        return !!(p && !p.marked && p.active !== false && !p.gmldead && !(p.gmltackling >= 0) &&
            [4, 5, 6, 8, 10].indexOf(p.gmlanim) < 0 && p.x >= 100 && p.x <= 2500 && p.y >= 132 && p.y <= 468);
    }
    function nearest(carrier, players, dir) {
        return players.filter(function (p) {
            return p.id !== carrier.id && p.gmloffense === carrier.gmloffense && available(p) &&
                (p.x - carrier.x) * dir <= 0 && distance(carrier, p) <= MAX_RANGE;
        }).sort(function (a, b) { return distance(carrier, a) - distance(carrier, b) || a.id - b.id; })[0] || null;
    }
    function trajectory(from, target, dir, errorX, errorY) {
        var frames = clamp(Math.round(distance(from, target) / 7), 8, 22);
        var x = target.x + (Number(target.hspeed) || 0) * frames * 0.6 + errorX;
        var y = clamp(target.y + (Number(target.vspeed) || 0) * frames * 0.6 + errorY, 133, 467);
        x = clamp(x, 101, 2499);
        x = dir === 1 ? Math.min(from.x, x) : Math.max(from.x, x);
        var dx = x - from.x, dy = y - from.y, length = Math.hypot(dx, dy);
        var scale = Math.min(1, MAX_RANGE / Math.max(1, length)); dx *= scale; dy *= scale;
        var travel = 0.986 * (1 - Math.pow(0.986, frames)) / (1 - 0.986);
        return { x: from.x + dx, y: from.y + dy, frames: frames,
            direction: Math.atan2(dy, dx) * 180 / Math.PI, velocity: Math.hypot(dx, dy) / travel,
            height: 8, zvel: (1 - 8) / frames + 0.08 * (frames + 1) / 2 };
    }
    function catchChance(skill, length, pressure) {
        return clamp(0.96 - length / MAX_RANGE * 0.18 + (clamp(Number(skill) || 5, 1, 10) - 5) * 0.014 - pressure * 0.03, 0.5, 0.97);
    }
    function objects(type) { return r.GetWithArray(type); }
    function match() { return objects(105)[0]; }
    function ball() { return objects(r.global.gmlmaster_ball)[0]; }
    function reset(m) { if (m) { m._lateralPitch = null; m._lastLateral = null; } }
    function state() {
        var m = match(), s = m && m._lateralPitch, b = s && ball();
        return s && b && b.id === s.ballId && m.gmlstate === 2 && !b.gmlis_dead ? s : null;
    }
    function canPitch(m, b) {
        var c = objects(98)[0], p = b && objects(b.gmlholder)[0], book = m && m._playbook;
        return !!(m && c && b && b === ball() && m.gmlstate === 2 && !m.gmlkicking && !c.gmlsim_action && !c.gmlqb_mode &&
            Number(m.gmlpossession) === Number(m.gmlhuman_team) && !b.gmlis_dead &&
            [2, 5, 18].indexOf(b.gmlstate) >= 0 && available(p) && p.gmloffense &&
            !(book && (book.selecting || book.waitRelease)) && !r.RetroPunt.active(m) &&
            !r.RetroJetSweep.locked() && !r.RetroHalfbackPass.ownsPitch() &&
            (!r.RetroPhillySpecial.locked() || r.RetroPhillySpecial.canAim()) &&
            !r.instance_exists(79) && !r.gml_Script_s_is_paused_or_just_unpaused(b, b));
    }
    function pitch(m, b) {
        if (!canPitch(m, b)) return false;
        var from = objects(b.gmlholder)[0], target = nearest(from, objects(108), m.gmldrivedir);
        if (!target) { r.gml_Script_s_fieldtxt(from, from, "NO PITCH TARGET WITHIN 7 YARDS"); return false; }
        var flight = trajectory(from, target, m.gmldrivedir, r.random_range(-6, 6), r.random_range(-6, 6));
        var pressure = Math.min(3, objects(109).filter(function (p) { return available(p) && distance(p, target) < 45; }).length);
        m._lateralPitch = { ballId: b.id, from: from.id, target: target.id, phase: "flight", frame: 0,
            flight: flight, length: distance(from, target), pressure: pressure, fumbled: false, looseFrames: 0 };
        // These are running decisions after the scripted trick-play exchanges.
        if (m._phillySpecial) m._phillySpecial.phase = "run";
        if (b.gmlstate !== 5) { m.gmlrunning_play = true; m.gmlplay_start = r.g_pBuiltIn.get_current_time(); }
        b.x = from.x; b.y = from.y; b.gmlxthrow = b.x; b.gmlythrow = b.y;
        b.gmlholder = -4; b.gmllast_touched_by = from.id; b.gmlstate = 3;
        b.gmldirec = flight.direction; b.gmlvelocity = flight.velocity; b.gmlzvel = flight.zvel;
        b.gmlheight = flight.height; b.gmlbouncecount = 0; b.gmlroll = 20; b.gmldropped_time = 0;
        m.gmltap_msg = "";
        r.gml_Script_s_set_anim(from, from, 12); r.gml_Script_s_sound_throw(from, from);
        [122, 124].forEach(function (type) { objects(type).forEach(function (p) { r.instance_destroy(p); }); });
        return true;
    }
    function fumble(m, s, b) {
        if (!s.fumbled) {
            s.fumbled = true;
            var from = objects(s.from)[0];
            if (from && from.gmlpmap >= 0 && r.ds_map_exists(from.gmlpmap, "stat_fumbles"))
                r.ds_map_set(from.gmlpmap, "stat_fumbles", r.ds_map_find_value(from.gmlpmap, "stat_fumbles") + 1);
            r.gml_Script_s_fieldtxt(b, b, "FUMBLE!");
        }
        s.phase = "loose"; s.looseFrames = 0;
        b.gmlstate = 13; b.gmlholder = -4; b.gmllast_touched_by = s.from;
        b.gmlfumble_time = Math.max(1, r.g_pBuiltIn.get_current_time()); b.gmldropped_time = 0;
        m.gmldrop_happened = true;
        m._lastLateral = { from: s.from, target: s.target, result: "fumble" };
    }
    function receive(m, s, b, p) {
        if (!p.gmloffense) fumble(m, s, b);
        r.gml_Script_s_receive_ball(p, p);
        if (r.path_exists(p.gmlmy_route)) r.path_delete(p.gmlmy_route);
        p.gmlmy_route = -1; p.gmlmy_route_point = 0;
        if (p.gmlposition === 1) { p.gmlposition = 2; p.gmlqb_rushing = true; }
        b.gmlvelocity = 0; b.gmlzvel = 0;
        r.gml_Script_s_set_anim(p, p, 2); r.gml_Script_s_sound_bounce(p, p);
        s.phase = "caught";
        m._lastLateral = { from: s.from, target: s.target, holder: p.id, result: s.fumbled ? "recovered" : "caught" };
        if (!p.gmloffense) { b.gmlstate = 10; r.gml_Script_s_create_match_message(p, p, 10); }
    }
    function updateBall(b) {
        var m = match();
        if (r.keyboard_check_pressed(81) && pitch(m, b)) return true;
        var s = state();
        if (!s || b.id !== s.ballId) return false;
        if (s.phase === "loose") { s.looseFrames++; return false; }
        if (s.phase !== "flight") return false;
        r.gml_Script_s_update_ball_movement(b, b, true); s.frame++;
        if (b.gmlheight <= 1 || s.frame >= s.flight.frames) {
            fumble(m, s, b);
            b.gmlheight = 1; b.gmlzvel = Math.max(0.2, Math.abs(b.gmlzvel) * 0.4); b.gmlvelocity *= 0.4;
            r.gml_Script_s_sound_bounce(b, b);
        }
        return true;
    }
    function collision(p) {
        var s = state();
        if (!s || (s.phase !== "flight" && s.phase !== "loose")) return false;
        var b = ball(), m = match();
        if (b.gmlholder !== -4 || !available(p) || distance(p, b) > 18 || b.gmlheight > 20) return true;
        if (s.phase === "loose") {
            if (s.looseFrames >= 6) receive(m, s, b, p);
            return true;
        }
        if (s.frame < 3 || p.id === s.from || (p.gmloffense && p.id !== s.target)) return true;
        var chance = catchChance(p.gmlskill, s.length, s.pressure);
        if (r.random(1) < chance) receive(m, s, b, p);
        else { fumble(m, s, b); b.gmlvelocity *= 0.35; b.gmlzvel = 0.6; }
        return true;
    }
    function beforePosition(b) {
        var s = state();
        if (!s || b.id !== s.ballId || (s.phase !== "flight" && s.phase !== "loose")) return;
        if (b.x >= 100 && b.x <= 2500 && b.y >= 132 && b.y <= 468) return;
        if (s.phase === "flight") fumble(match(), s, b);
        // Sideline fumbles use native spotting. End-line misses must also stay
        // fumbles rather than entering the native forward-pass incompletion.
        if (b.x < 100 || b.x > 2500) {
            b.gmlstate = (b.x < 100 ? 1 : -1) === match().gmldrivedir ? 12 : 20;
            r.gml_Script_s_update_xdead(b, b); r.gml_Script_s_is_ball_dead(b, b);
        }
    }
    function destination(p) {
        var s = state();
        if (!s || s.phase !== "flight" || p.id !== s.target || !available(p)) return false;
        p.gmljdir = r.point_direction(p.x, p.y, s.flight.x, s.flight.y);
        p.gmljforce = clamp(distance(p, s.flight) / 16, 0, 1);
        return true;
    }
    function draw(m) {
        var b = ball();
        if (!canPitch(m, b)) return;
        var color = r.draw_get_color(), font = r.draw_get_font(), ha = r.draw_get_halign(), va = r.draw_get_valign();
        r.draw_set_font(r.global.gmlfnt_small_flex); r.draw_set_halign(0); r.draw_set_valign(1);
        r.draw_set_color(nearest(objects(b.gmlholder)[0], objects(108), m.gmldrivedir) ? 65535 : 8421504);
        r.gml_Script_draw_hd_text(m, m, 8, r.display_get_gui_height() - 10, "Q: PITCH");
        r.draw_set_color(color); r.draw_set_font(font); r.draw_set_halign(ha); r.draw_set_valign(va);
    }
    return { pitch: pitch, updateBall: updateBall, collision: collision, beforePosition: beforePosition,
        destination: destination, draw: draw, reset: reset,
        logic: { MAX_RANGE: MAX_RANGE, nearest: nearest, trajectory: trajectory, catchChance: catchChance } };
});
