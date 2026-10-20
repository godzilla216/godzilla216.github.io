/* Forced jet motion and a short forward touch pass, then native ball carrying. */
(function (r) {
    "use strict";
    function objects(type) { return r.GetWithArray(type); }
    function match() { return objects(105)[0]; }
    function ball() { return objects(r.global.gmlmaster_ball)[0]; }
    function reset(m) { if (m) m._jetSweep = null; }
    function clamp(n, a, b) { return Math.max(a, Math.min(b, n)); }
    function clearRoute(p) {
        if (r.path_exists(p.gmlmy_route)) r.path_delete(p.gmlmy_route);
        p.gmlmy_route = -1; p.gmlmy_route_point = 0;
    }
    function afterSetup(m, forced) {
        reset(m);
        var c = objects(98)[0], b = ball();
        if (!c || !b || m._halfbackPass || c.gmlsim_action || c.gmlqb_mode || c.gmlgamepractice ||
            m.gmlkicking || m.gmldown < 1 || m.gmldown > 4 || b.gmlstate !== 0 ||
            Number(m.gmlpossession) !== Number(m.gmlhuman_team)) return;
        var offense = objects(108), qb = offense.find(function (p) { return p.gmlposition === 1; });
        if (!qb) return;
        var receiver = offense.filter(function (p) { return p.gmlposition === 4; })
            .sort(function (a, b) { return Math.abs(b.y - qb.y) - Math.abs(a.y - qb.y) || a.gmlinum - b.gmlinum; })[0];
        // Halfback pass already takes 1/15 of plays. (14/15)*(15/182)=1/13.
        if (!qb || !receiver || (!forced && r.irandom(181) >= 15)) return;
        var side = receiver.y <= qb.y ? 1 : -1;
        receiver.x = qb.x + m.gmldrivedir * 24;
        receiver.y = clamp(qb.y - side * 120, 150, 450);
        clearRoute(receiver);
        receiver.hspeed = 0; receiver.vspeed = 0;
        var blockers = offense.filter(function (p) { return p.id !== receiver.id && p.gmlposition !== 1; })
            .sort(function (a, b) { return (a.gmlposition === 2 ? -1000 : Math.abs(a.y - (qb.y + side * 80))) -
                (b.gmlposition === 2 ? -1000 : Math.abs(b.y - (qb.y + side * 80))) || a.gmlinum - b.gmlinum; }).slice(0, 4);
        blockers.forEach(clearRoute);
        m._jetSweep = { ballId: b.id, qb: qb.id, receiver: receiver.id, side: side,
            phase: "ready", frame: 0, blockers: blockers.map(function (p) { return p.id; }) };
        m.gmltap_msg = "JET SWEEP - SNAP TO START";
    }
    function state() {
        var m = match(), s = m && m._jetSweep, b = s && ball();
        return s && b && b.id === s.ballId && m.gmlstate === 2 && !b.gmlis_dead ? s : null;
    }
    function locked() { var s = state(); return !!(s && s.phase !== "run"); }
    function ownsTouch() { var s = state(); return !!(s && s.phase === "touch"); }
    function steer(p, x, y) {
        p.gmljdir = r.point_direction(p.x, p.y, x, y);
        p.gmljforce = clamp(Math.hypot(x - p.x, y - p.y) / 16, 0, 1);
    }
    function updateBall(b) {
        var s = state();
        if (!s || s.phase === "run" || b.id !== s.ballId) return false;
        var m = match(), qb = objects(s.qb)[0], receiver = objects(s.receiver)[0];
        if (!qb || !receiver || qb.gmldead || receiver.gmldead) { reset(m); return false; }
        if (s.phase === "ready") {
            if (!r.RetroHalfbackPass.snapInput(b)) return true;
            s.phase = "motion";
            clearRoute(qb);
            qb.hspeed = 0; qb.vspeed = 0;
            b.gmlstate = 18;
            m.gmlrunning_play = false;
            m.gmlplay_start = r.g_pBuiltIn.get_current_time();
            m.gmltap_msg = "";
            [122, 124].forEach(function (type) { objects(type).forEach(function (p) { r.instance_destroy(p); }); });
        }
        if (s.phase === "motion") {
            r.gml_Script_s_update_ball_offset(b, qb);
            if (Math.abs(receiver.y - qb.y) > 28) return true;
            s.phase = "touch"; s.frame = 0;
            // This is a forward pass to the crossing receiver, not a handoff.
            b.gmldirec = r.point_direction(qb.x, qb.y, receiver.x, receiver.y + s.side * 16);
            b.gmlvelocity = 4; b.gmlzvel = 1;
            r.gml_Script_s_throw_ball(b, qb);
            r.gml_Script_s_sound_throw(qb, qb);
            s.start = { x: b.x, y: b.y };
        }
        if (s.phase === "touch") {
            var t = Math.min(1, ++s.frame / 7);
            b.x = s.start.x + (receiver.x - s.start.x) * t;
            b.y = s.start.y + (receiver.y - s.start.y) * t;
            b.gmlheight = 10 + Math.sin(t * Math.PI) * 8;
            b.gmlrotation += 30;
            if (t === 1) {
                r.gml_Script_s_receive_ball(receiver, qb);
                if (qb.gmlpmap >= 0 && r.ds_map_exists(qb.gmlpmap, "stat_complete"))
                    r.ds_map_set(qb.gmlpmap, "stat_complete", r.ds_map_find_value(qb.gmlpmap, "stat_complete") + 1);
                b.gmlvelocity = 0; b.gmlzvel = 0;
                r.gml_Script_s_set_anim(receiver, receiver, 2);
                s.phase = "run";
                r.gml_Script_s_update_ball_offset(b, receiver);
            }
        }
        return true;
    }
    function destination(p) {
        var s = state();
        if (!s || p.gmldead || p.gmltackling >= 0) return false;
        var m = match(), qb = objects(s.qb)[0], receiver = objects(s.receiver)[0], b = ball();
        if (!qb || !receiver) return false;
        if (s.phase === "ready") {
            if (p.id !== s.receiver) return false;
            p.gmljforce = 0; return true;
        }
        if (p.id === s.qb && s.phase !== "run") { p.gmljforce = 0; return true; }
        if (p.id === s.receiver && s.phase !== "run") {
            steer(p, qb.x + m.gmldrivedir * 24, clamp(qb.y + s.side * 100, 150, 450));
            return true;
        }
        // Pull four blockers toward the sweep lane, then lead the ball carrier.
        // Native collision and engagement logic still decides the actual blocks.
        var slot = s.blockers.indexOf(p.id);
        if (slot < 0 || (s.phase === "run" && b.gmlholder !== receiver.id)) return false;
        var target = { x: (s.phase === "run" ? receiver.x : m.gmlx_scrim) + m.gmldrivedir * (40 + slot * 18),
            y: clamp((s.phase === "run" ? receiver.y : qb.y) + s.side * (35 + slot * 14), 145, 455) };
        var opponents = objects(109).filter(function (d) { return !d.gmldead &&
            (d.x - receiver.x) * m.gmldrivedir > -20 && Math.abs(d.y - target.y) < 65 &&
            Math.hypot(d.x - p.x, d.y - p.y) < 90; })
            .sort(function (a, b) { return Math.hypot(a.x - p.x, a.y - p.y) - Math.hypot(b.x - p.x, b.y - p.y); });
        steer(p, opponents.length ? opponents[0].x : target.x, opponents.length ? opponents[0].y : target.y);
        return true;
    }
    r.RetroJetSweep = { afterSetup: afterSetup, reset: reset, updateBall: updateBall,
        destination: destination, locked: locked, ownsTouch: ownsTouch };
})(window);
