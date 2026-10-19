/* Forced QB shift, direct RB snap and TE pitch; the user aims the TE's pass.
 * Reference: Philadelphia Eagles, "Nick Foles, Trey Burton relive the Philly
 * Special ahead of ESPN documentary" (February 2026). */
(function (r) {
    "use strict";
    function objects(type) { return r.GetWithArray(type); }
    function match() { return objects(105)[0]; }
    function ball() { return objects(r.global.gmlmaster_ball)[0]; }
    function clamp(n, lo, hi) { return Math.max(lo, Math.min(hi, n)); }
    function reset(m) { if (m) m._phillySpecial = null; }
    function clearRoute(p) {
        if (r.path_exists(p.gmlmy_route)) r.path_delete(p.gmlmy_route);
        p.gmlmy_route = -1; p.gmlmy_route_point = 0;
        p.hspeed = 0; p.vspeed = 0;
    }
    function afterSetup(m) {
        reset(m);
        var c = objects(98)[0], b = ball();
        if (!c || !b || m._halfbackPass || m._jetSweep || c.gmlsim_action || c.gmlqb_mode || c.gmlgamepractice ||
            m.gmlkicking || m.gmldown < 1 || m.gmldown > 4 || b.gmlstate !== 0 ||
            Number(m.gmlpossession) !== Number(m.gmlhuman_team)) return;
        var offense = objects(108), qb = offense.find(function (p) { return p.gmlposition === 1; });
        var rb = offense.find(function (p) { return p.gmlposition === 2; });
        var te = offense.find(function (p) { return p.gmlposition === 3; }) ||
            offense.find(function (p) { return p.gmlte_blocking; });
        // Previous calls occupy 28/195 of plays: (167/195)*(13/167)=1/15.
        if (!qb || !rb || !te || r.irandom(166) >= 13) return;
        var dir = m.gmldrivedir, side = dir, center = clamp(m.gmly_scrim, 255, 345);
        [qb, rb, te].forEach(clearRoute);
        rb.x = m.gmlx_scrim - dir * 100; rb.y = center;
        te.x = m.gmlx_scrim - dir * 135; te.y = center - side * 90;
        te.gmlte_blocking = false;
        te.gmlposition = 3;
        // Native field roles only: the QB becomes eligible, the direct-snap RB
        // draws the initial pressure, and roster names/ratings/maps stay intact.
        qb.gmlposition = 4;
        rb.gmlposition = 1;
        // The ball stays at the center while the QB shifts; he never takes it.
        b.gmlholder = -4; b.x = m.gmlx_scrim; b.y = center; b.gmlheight = 1;
        offense.filter(function (p) { return p.gmlposition === 4 && p.id !== qb.id; }).forEach(function (p, i) {
            clearRoute(p); p.x = m.gmlx_scrim; p.y = clamp(center - side * (105 + i * 30), 145, 455);
        });
        m._phillySpecial = { ballId: b.id, qb: qb.id, rb: rb.id, te: te.id, phase: "ready", frame: 0,
            dir: dir, side: side, center: center,
            shift: { x: m.gmlx_scrim - dir * 20, y: center + side * 95 },
            route: { x: clamp(m.gmlx_scrim + dir * 145, 160, 2440), y: center + side * 110 } };
        m.gmltap_msg = "PHILLY SPECIAL - TAP TO START";
        [122, 124].forEach(function (type) { objects(type).forEach(function (p) { r.instance_destroy(p); }); });
    }
    function state() {
        var m = match(), s = m && m._phillySpecial, b = s && ball();
        return s && b && b.id === s.ballId && m.gmlstate === 2 && !b.gmlis_dead ? s : null;
    }
    function locked() { var s = state(); return !!(s && s.phase !== "run"); }
    function canAim() {
        var s = state();
        return !!(s && s.phase === "pass" && !s.waitRelease && ball().gmlholder === s.te);
    }
    function allowThrow(b) {
        return !locked() || canAim();
    }
    function ownsExchange() { var s = state(); return !!(s && (s.phase === "snap" || s.phase === "pitch")); }
    function steer(p, point) {
        var distance = Math.hypot(p.x - point.x, p.y - point.y);
        p.gmljdir = r.point_direction(p.x, p.y, point.x, point.y);
        p.gmljforce = clamp(distance / 12, 0, 1);
        if (distance < 5) { p.hspeed = 0; p.vspeed = 0; p.gmljforce = 0; }
    }
    function receive(p, b) {
        r.gml_Script_s_receive_ball(p, p);
        b.gmlstate = 18; b.gmlvelocity = 0; b.gmlzvel = 0;
        r.gml_Script_s_update_ball_offset(b, p);
    }
    function startExchange(s, b, phase, start) {
        s.phase = phase; s.frame = 0; s.start = { x: start.x, y: start.y };
        b.gmlstate = 19; b.gmlholder = -4; b.gmlvelocity = 0; b.gmlzvel = 0;
    }
    function exchange(s, b, target, duration) {
        var t = Math.min(1, ++s.frame / duration);
        b.x = s.start.x + (target.x - s.start.x) * t;
        b.y = s.start.y + (target.y - s.start.y) * t;
        b.gmlheight = 7 + Math.sin(t * Math.PI) * 13;
        b.gmlrotation += 30;
        return t === 1;
    }
    function updateBall(b) {
        var s = state();
        if (!s || b.id !== s.ballId || s.phase === "run") return false;
        var m = match(), qb = objects(s.qb)[0], rb = objects(s.rb)[0], te = objects(s.te)[0];
        if (!qb || !rb || !te) return false;
        if (s.phase === "flight") {
            var holder = objects(b.gmlholder)[0];
            if (holder && holder.gmloffense && b.gmlstate === 5) s.phase = "run";
            return false; // Native flight, defense, catches and incompletions.
        }
        if (s.phase === "pass") {
            if (b.gmlstate === 3) { s.phase = "flight"; return false; }
            if (s.waitRelease) {
                s.waitRelease = r.RetroHalfbackPass.snapInput(b);
                r.gml_Script_s_update_ball_offset(b, te);
                return true;
            }
            // Short/backward gestures cancel aiming rather than becoming a run.
            if (b.gmlstate === 0 || (!r.global.gmlgamepad && b.gmlstate === 2 && !r.mouse_check_button(1) &&
                (b.gmldragdist < 20 || r.gml_Script_s_opposite_aim(b, b, b.gmldirec)))) {
                b.gmlstate = 18;
                r.gml_Script_s_update_ball_offset(b, te);
                return true;
            }
            return false;
        }
        // Never unlock an alternative play if an exchange participant is down.
        if (qb.gmldead || rb.gmldead || te.gmldead) {
            r.gml_Script_s_set_ball_down(b, b);
            r.gml_Script_s_is_ball_dead(b, b);
            return true;
        }
        if (s.phase === "ready") {
            if (!r.RetroHalfbackPass.snapInput(b)) return true;
            s.phase = "shift";
            [122, 124].forEach(function (type) { objects(type).forEach(function (p) { r.instance_destroy(p); }); });
            m.gmltap_msg = "";
        }
        if (s.phase === "shift") {
            if (Math.hypot(qb.x - s.shift.x, qb.y - s.shift.y) > 8) return true;
            m.gmlplay_start = r.g_pBuiltIn.get_current_time();
            m.gmlrunning_play = false;
            startExchange(s, b, "snap", { x: m.gmlx_scrim, y: s.center });
        }
        if (s.phase === "snap") {
            if (!exchange(s, b, rb, 10)) return true;
            receive(rb, b);
            s.phase = "reverse";
            s.frame = 0;
        }
        if (s.phase === "reverse") {
            r.gml_Script_s_update_ball_offset(b, rb);
            if (Math.abs(rb.y - (s.center - s.side * 35)) > 10 || Math.abs(te.y - (s.center + s.side * 5)) > 20) return true;
            startExchange(s, b, "pitch", rb);
            r.gml_Script_s_set_anim(rb, rb, 12);
            r.gml_Script_s_sound_throw(rb, rb);
        }
        if (s.phase === "pitch") {
            if (!exchange(s, b, te, 12)) return true;
            receive(te, b);
            rb.gmlposition = 2;
            te.gmlposition = 1;
            s.phase = "rollout"; s.frame = 0;
        }
        if (s.phase === "rollout") {
            r.gml_Script_s_update_ball_offset(b, te);
            s.frame++;
            if (s.frame < 18 || (Math.hypot(qb.x - s.route.x, qb.y - s.route.y) > 15 && s.frame < 100)) return true;
            te.hspeed = 0; te.vspeed = 0; te.gmljforce = 0;
            r.gml_Script_s_set_anim(te, te, 0);
            b.gmlstate = 18;
            s.phase = "pass"; s.waitRelease = true;
            m.gmltap_msg = "TE PASS - AIM AND THROW";
            return true;
        }
        return true;
    }
    function destination(p) {
        var s = state();
        if (!s || s.phase === "run" || p.gmldead || p.gmltackling >= 0) return false;
        var m = match();
        if (p.id !== s.qb && p.id !== s.rb && p.id !== s.te) return false;
        if (s.phase === "ready") { p.gmljforce = 0; return true; }
        if (p.id === s.qb) {
            if (s.phase === "shift") steer(p, s.shift);
            else if (s.phase === "snap") { p.gmljforce = 0; p.hspeed = 0; p.vspeed = 0; }
            else if (s.phase === "flight") return false;
            else steer(p, s.route);
            return true;
        }
        if (p.id === s.rb) {
            if (s.phase === "reverse") steer(p, { x: m.gmlx_scrim - s.dir * 100, y: s.center - s.side * 35 });
            else if (s.phase === "rollout" || s.phase === "pass" || s.phase === "flight") return false;
            else p.gmljforce = 0;
            return true;
        }
        if (s.phase === "reverse" || s.phase === "pitch") steer(p, { x: m.gmlx_scrim - s.dir * 135, y: s.center + s.side * 5 });
        else if (s.phase === "rollout") steer(p, { x: m.gmlx_scrim - s.dir * 115, y: s.center + s.side * 65 });
        else if (s.phase === "flight") return false;
        else p.gmljforce = 0;
        return true;
    }
    r.RetroPhillySpecial = { afterSetup: afterSetup, reset: reset, updateBall: updateBall,
        destination: destination, locked: locked, canAim: canAim, allowThrow: allowThrow, ownsExchange: ownsExchange };
})(window);
