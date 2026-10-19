/* A rare, forced backward pitch followed by the native passing controls. */
(function (root) {
    "use strict";
    function objects(type) { return root.GetWithArray(type); }
    function match() { return objects(105)[0]; }
    function ball() { return objects(root.global.gmlmaster_ball)[0]; }
    function reset(m) { if (m) m._halfbackPass = null; }
    function clearRoute(p) {
        if (root.path_exists(p.gmlmy_route)) root.path_delete(p.gmlmy_route);
        p.gmlmy_route = -1;
        p.gmlmy_route_point = 0;
    }
    function afterSetup(m) {
        reset(m);
        var c = objects(98)[0], b = ball();
        if (!c || !b || c.gmlsim_action || c.gmlqb_mode || c.gmlgamepractice ||
            m.gmlkicking || m.gmldown < 1 || m.gmldown > 4 ||
            Number(m.gmlpossession) !== Number(m.gmlhuman_team) || b.gmlstate !== 0) return;
        var offense = objects(108), qb = offense.find(function (p) { return p.gmlposition === 1; });
        var rb = offense.find(function (p) { return p.gmlposition === 2; });
        if (!qb || !rb || root.irandom(14) !== 0) return;
        m._halfbackPass = { ballId: b.id, qb: qb.id, rb: rb.id, phase: "ready", frame: 0 };
        // Keep the pitch backward and give the back room to receive it.
        rb.x = Math.max(145, Math.min(2455, qb.x - m.gmldrivedir * 65));
        rb.y = qb.y <= 300 ? Math.min(430, qb.y + 65) : Math.max(170, qb.y - 65);
        clearRoute(rb);
        m.gmltap_msg = "HALFBACK PASS - SNAP TO PITCH";
    }
    function state() {
        var m = match(), s = m && m._halfbackPass, b = s && ball();
        return s && b && b.id === s.ballId && m.gmlstate === 2 && !b.gmlis_dead ? s : null;
    }
    function ownsPitch() { var s = state(); return !!(s && s.phase === "pitch"); }
    function snapInput(b) {
        if (root.mouse_check_button(1) && root.gml_Script_s_is_touch_allowed(b, b)) return true;
        if (!root.global.gmlgamepad) return false;
        var pad = objects(root.global.gmlgp)[0];
        return !!(pad && (pad.gmlaxisl_force > 0.2 || pad.gmlaxisr_force > 0.2 ||
            root.gamepad_button_check_released(pad.gmlslot, root.global.gmlgp_handoff)));
    }
    function receive(m, s, b, qb, rb) {
        root.gml_Script_s_receive_ball(rb, qb);
        // Field roles change for this play only. Roster identity, ratings and
        // stat maps stay attached to the actual QB and RB.
        clearRoute(qb);
        qb.gmlposition = 3;
        qb.gmlmy_route = root.path_add();
        qb.gmlmy_route_startx = qb.x;
        qb.gmlmy_route_starty = qb.y;
        var side = rb.y > qb.y ? -1 : 1;
        var routeY = side * (qb.y > 300 ? -1 : 1) * 80;
        root.path_add_point(qb.gmlmy_route, m.gmldrivedir * 100, routeY, 100);
        root.path_add_point(qb.gmlmy_route, m.gmldrivedir * 500, routeY, 100);
        qb.gmlmy_route_end_dir = m.gmldrivedir === 1 ? 0 : 180;
        root.gml_Script_s_set_anim(qb, qb, 2);
        rb.gmlposition = 1;
        rb.hspeed = 0; rb.vspeed = 0; rb.gmljforce = 0;
        root.gml_Script_s_set_anim(rb, rb, 0);
        b.gmlstate = 18;
        b.gmlvelocity = 0; b.gmlzvel = 0;
        m.gmlrunning_play = false;
        s.phase = "pass";
        s.waitRelease = true;
        m.gmltap_msg = "RB PASS - AIM AND THROW";
        root.gml_Script_s_update_ball_offset(b, rb);
    }
    function updateBall(b) {
        var s = state();
        if (!s || b.id !== s.ballId) return false;
        var m = match(), qb = objects(s.qb)[0], rb = objects(s.rb)[0];
        if (!qb || !rb || qb.gmldead || rb.gmldead) return false;
        if (s.phase === "ready") {
            if (b.gmlstate === 0 && !snapInput(b)) return false;
            if ([0, 1, 2, 19].indexOf(b.gmlstate) < 0) return false;
            s.phase = "pitch";
            s.start = { x: qb.x, y: qb.y };
            clearRoute(qb);
            qb.hspeed = 0; qb.vspeed = 0;
            rb.hspeed = 0; rb.vspeed = 0;
            b.gmlstate = 19;
            b.gmlholder = -4;
            b.gmlvelocity = 0;
            b.gmlzvel = 0;
            m.gmlrunning_play = false;
            m.gmlplay_start = root.g_pBuiltIn.get_current_time();
            m.gmltap_msg = "";
            root.gml_Script_s_set_anim(qb, qb, 12);
            root.gml_Script_s_sound_throw(qb, qb);
            [122, 124].forEach(function (type) { objects(type).forEach(function (p) { root.instance_destroy(p); }); });
        }
        if (s.phase === "pitch") {
            var t = Math.min(1, ++s.frame / 16);
            b.x = s.start.x + (rb.x - s.start.x) * t;
            b.y = s.start.y + (rb.y - s.start.y) * t;
            b.gmlheight = 8 + Math.sin(t * Math.PI) * 14;
            b.gmlrotation += 30;
            if (t === 1) receive(m, s, b, qb, rb);
            return true;
        }
        // A held snap gesture must not also throw the RB's pass.
        if (s.phase === "pass" && s.waitRelease) {
            s.waitRelease = snapInput(b);
            root.gml_Script_s_update_ball_offset(b, rb);
            return true;
        }
        return false;
    }
    function destination(p) {
        var s = state();
        if (!s || (p.id !== s.qb && p.id !== s.rb)) return false;
        if (s.phase === "pitch" || (s.phase === "ready" && p.id === s.rb)) {
            p.gmljforce = 0;
            return true;
        }
        if (s.phase === "pass" && p.id === s.rb && ball().gmlholder === p.id && [18, 1, 2].indexOf(ball().gmlstate) >= 0) {
            p.gmljforce = 0;
            return true;
        }
        return false;
    }
    root.RetroHalfbackPass = { afterSetup: afterSetup, reset: reset, updateBall: updateBall, destination: destination, ownsPitch: ownsPitch, snapInput: snapInput };
})(window);
