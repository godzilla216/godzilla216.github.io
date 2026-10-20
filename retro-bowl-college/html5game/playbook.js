/* Optional pre-snap play calling; automatic calls retain their original odds. */
(function (r) {
    "use strict";
    var STORAGE_KEY = "retro-bowl-college.auto-playbook", automatic = true;
    var lastChoice = "pass";
    var FORMATION_FIELDS = ["x", "y", "gmlposition", "gmlte_blocking", "gmlmy_route_point",
        "gmlmy_route_startx", "gmlmy_route_starty", "gmlmy_route_end_dir", "gmlanim"];
    var PLAYS = [
        { id: "pass", name: "PASS", hint: "Normal passing routes" },
        { id: "run", name: "HB RUN", hint: "Snap to hand off to the RB" },
        { id: "halfback", name: "HB PASS", hint: "QB pitches; you throw as the RB" },
        { id: "jet", name: "JET SWEEP", hint: "WR motion and a short touch pass" },
        { id: "philly", name: "PHILLY SPECIAL", hint: "RB to TE; choose a pass or scramble" }
    ];
    try { automatic = r.localStorage.getItem(STORAGE_KEY) !== "off"; } catch (_) { /* Session preference still works. */ }
    function objects(type) { return r.GetWithArray(type); }
    function ball() { return objects(r.global.gmlmaster_ball)[0]; }
    function isAutomatic() { return automatic; }
    function setAutomatic(value) {
        automatic = !!value;
        try { r.localStorage.setItem(STORAGE_KEY, automatic ? "on" : "off"); } catch (_) { /* Keep the session preference. */ }
        return automatic;
    }
    function updateOption() {
        // Reuse the browser export's unused Team Editor row in Options.
        var button = objects(100302)[0], label = objects(100311)[0];
        if (!button || !label) return;
        button.visible = label.visible = true;
        button.gmltext = automatic ? "ON" : "OFF";
        button.gmlonClickAction = toggleOption;
        button.gmlimage = -4;
        button.gmlcolour = r.global.gmlc_background;
        label.gmltext = "AUTO PLAYBOOK";
    }
    function toggleOption() { setAutomatic(!automatic); updateOption(); }
    function eligible(m) {
        var c = objects(98)[0], b = ball();
        return !!(m && c && b && !c.gmlsim_action && !c.gmlqb_mode && !c.gmlgamepractice &&
            !m.gmlkicking && m.gmldown >= 1 && m.gmldown <= 4 && b.gmlstate === 0 &&
            Number(m.gmlpossession) === Number(m.gmlhuman_team));
    }
    function reset(m) {
        if (!m) return;
        var s = m._playbook;
        if (s) s.formation.forEach(function (v) { if (r.path_exists(v.route)) r.path_delete(v.route); });
        m._playbook = null;
    }
    function clearSpecials(m) {
        r.RetroHalfbackPass.reset(m); r.RetroJetSweep.reset(m); r.RetroPhillySpecial.reset(m);
    }
    function available() {
        var offense = objects(108), qb = offense.some(function (p) { return p.gmlposition === 1; });
        var rb = offense.some(function (p) { return p.gmlposition === 2; });
        var wr = offense.some(function (p) { return p.gmlposition === 4; });
        var te = offense.some(function (p) { return p.gmlposition === 3 || p.gmlte_blocking; });
        return PLAYS.filter(function (p) {
            return qb && (p.id === "pass" || (p.id === "jet" ? wr : rb && (p.id !== "philly" || te)));
        }).map(function (p) { return p.id; });
    }
    function afterSetup(m) {
        reset(m);
        if (automatic) {
            r.RetroHalfbackPass.afterSetup(m); r.RetroJetSweep.afterSetup(m); r.RetroPhillySpecial.afterSetup(m);
            return;
        }
        clearSpecials(m);
        if (!eligible(m)) return;
        var calls = available();
        var selected = calls.indexOf(lastChoice) >= 0 ? lastChoice : "pass";
        m._playbook = { ballId: ball().id, selecting: true, selected: selected,
            call: null, available: calls, waitRelease: false, stickHeld: false, started: false,
            formation: objects(108).map(function (p) {
                var v = { id: p.id, route: r.path_exists(p.gmlmy_route) ? r.path_duplicate(p.gmlmy_route) : -1 };
                FORMATION_FIELDS.forEach(function (key) { v[key] = p[key]; });
                return v;
            }) };
        m.gmltap_msg = "CHOOSE YOUR PLAY";
    }
    function state(m) {
        var s = m && m._playbook, b = s && ball();
        return !automatic && s && b && s.ballId === b.id && m.gmlstate === 2 && !b.gmlis_dead ? s : null;
    }
    function preSnap(m, s) {
        var b = ball();
        return s && !s.started && b.gmlstate === 0 &&
            (!m._phillySpecial || m._phillySpecial.phase === "ready");
    }
    function choose(m, id) {
        var s = state(m);
        if (!s || !s.selecting || s.available.indexOf(id) < 0) return false;
        // Restore routes and positions without counting another snap or
        // re-rolling the defensive formation.
        clearSpecials(m);
        s.formation.forEach(function (v) {
            var p = objects(v.id)[0];
            if (!p) return;
            if (r.path_exists(p.gmlmy_route)) r.path_delete(p.gmlmy_route);
            FORMATION_FIELDS.forEach(function (key) { p[key] = v[key]; });
            p.gmlmy_route = r.path_exists(v.route) ? r.path_duplicate(v.route) : -1;
            p.hspeed = 0; p.vspeed = 0; p.gmljforce = 0;
            r.gml_Script_s_set_anim(p, p, v.gmlanim);
        });
        var b = ball(), qb = objects(108).find(function (p) { return p.gmlposition === 1; });
        b.x = m.gmlx_scrim; b.y = m.gmly_scrim;
        b.gmlholder = qb.id; b.gmlstate = 0; b.gmllast_touched_by = -4;
        b.gmlheight = 1; b.gmlvelocity = 0; b.gmlzvel = 0;
        b.gmltouch_starty = -1;
        m.gmlrunning_play = false;
        s.call = s.selected = lastChoice = id;
        s.selecting = false; s.waitRelease = true; s.stickHeld = false;
        m.gmltap_msg = id === "run" ? "HB RUN - SNAP TO HAND OFF" : "PASS - AIM AND THROW";
        if (id === "halfback") r.RetroHalfbackPass.afterSetup(m, true);
        if (id === "jet") r.RetroJetSweep.afterSetup(m, true);
        if (id === "philly") r.RetroPhillySpecial.afterSetup(m, true);
        return true;
    }
    function layout() {
        var width = r.display_get_gui_width(), height = r.display_get_gui_height();
        var w = Math.min(380, width - 16), x = (width - w) / 2, y = Math.max(32, (height - 204) / 2);
        var gap = 6, cardW = (w - 30) / 2;
        return { x: x, y: y, w: w, h: 204,
            cards: PLAYS.map(function (p, i) {
                return { id: p.id, x: x + 12 + (i % 2) * (cardW + gap), y: y + 32 + Math.floor(i / 2) * 32, w: cardW, h: 27 };
            }),
            confirm: { x: x + 12, y: y + 152, w: w - 24, h: 25 },
            reopen: { x: width / 2 - 60, y: 48, w: 120, h: 22 } };
    }
    function hit(b, x, y) { return x >= b.x && x <= b.x + b.w && y >= b.y && y <= b.y + b.h; }
    function reopenRequested() {
        if (r.keyboard_check_pressed(80)) return true;
        var box = layout().reopen;
        return [0, 1, 2, 3].some(function (device) {
            return r.device_mouse_check_button_pressed(device, 1) &&
                hit(box, r.device_mouse_x_to_gui(device), r.device_mouse_y_to_gui(device));
        });
    }
    function padInput() {
        var gp = r.global.gmlgamepad && objects(r.global.gmlgp)[0], slot = gp ? gp.gmlslot : -1;
        if (!gp) for (var i = 0; i < r.gamepad_get_device_count(); i++) {
            if (r.gamepad_is_connected(i)) { slot = i; break; }
        }
        return { slot: slot, x: gp ? gp.gmlaxisl_h : slot >= 0 ? r.gamepad_axis_value(slot, 32785) : 0,
            y: gp ? gp.gmlaxisl_v : slot >= 0 ? r.gamepad_axis_value(slot, 32786) : 0 };
    }
    function step(m) {
        var s = state(m);
        if (!s || r.instance_exists(79) || r.gml_Script_s_is_paused_or_just_unpaused(m, m)) return false;
        if (!s.selecting && !preSnap(m, s)) return false;
        var ui = layout(), gp = padInput();
        if (!s.selecting && reopenRequested()) s.selecting = true;
        var devices = [0, 1, 2, 3];
        for (var i = 0; i < devices.length; i++) {
            var device = devices[i];
            if (!r.device_mouse_check_button_pressed(device, 1)) continue;
            var x = r.device_mouse_x_to_gui(device), y = r.device_mouse_y_to_gui(device);
            if (!s.selecting) {
                if (hit(ui.reopen, x, y)) s.selecting = true;
            } else {
                var card = ui.cards.find(function (b) { return hit(b, x, y); });
                if (card && s.available.indexOf(card.id) >= 0) s.selected = card.id;
                if (hit(ui.confirm, x, y)) { choose(m, s.selected); return true; }
            }
        }
        if (!s.selecting) return false;
        for (var key = 0; key < PLAYS.length; key++) {
            if (r.keyboard_check_pressed(49 + key) && s.available.indexOf(PLAYS[key].id) >= 0) s.selected = PLAYS[key].id;
        }
        var delta = 0;
        if (r.keyboard_check_pressed(37) || r.keyboard_check_pressed(38)) delta = -1;
        if (r.keyboard_check_pressed(39) || r.keyboard_check_pressed(40)) delta = 1;
        var axis = Math.abs(gp.x) > 0.5 ? gp.x : Math.abs(gp.y) > 0.5 ? gp.y : 0;
        if (axis && !s.stickHeld) delta = axis > 0 ? 1 : -1;
        s.stickHeld = !!axis;
        if (delta) s.selected = s.available[(s.available.indexOf(s.selected) + delta + s.available.length) % s.available.length];
        if (r.keyboard_check_pressed(13) || (gp.slot >= 0 && r.gamepad_button_check_pressed(gp.slot, r.global.gmlgp_select))) choose(m, s.selected);
        return true;
    }
    function updateBall(b) {
        var m = objects(105)[0], s = state(m);
        if (!s || b.id !== s.ballId) return false;
        // Ball and controller events can run in either order. Consume the
        // playbook button before the ball can treat that press as a snap.
        if (!s.selecting && preSnap(m, s) && reopenRequested()) s.selecting = true;
        if (s.selecting) return true;
        if (s.waitRelease) {
            var gp = padInput();
            s.waitRelease = r.mouse_check_button(1) || (gp.slot >= 0 &&
                (Math.abs(gp.x) > 0.2 || Math.abs(gp.y) > 0.2 || r.gamepad_button_check(gp.slot, r.global.gmlgp_select)));
            return true;
        }
        if (s.call === "run" && b.gmlstate === 0 && r.RetroHalfbackPass.snapInput(b)) {
            s.started = true;
            b.gmlstate = 19;
            m.gmlrunning_play = true;
            m.gmlplay_start = r.g_pBuiltIn.get_current_time();
            m.gmltap_msg = "";
            r.gml_Script_s_sound_throw(b, b);
            [122, 124].forEach(function (type) { objects(type).forEach(function (p) { r.instance_destroy(p); }); });
            return true;
        }
        if (b.gmlstate !== 0) s.started = true;
        return false;
    }
    function draw(m) {
        var s = state(m);
        if (!s || r.instance_exists(79) || (!s.selecting && !preSnap(m, s))) return;
        var ui = layout(), color = r.draw_get_color(), font = r.draw_get_font();
        var ha = r.draw_get_halign(), va = r.draw_get_valign(), alpha = r.draw_get_alpha();
        r.draw_set_font(r.global.gmlfnt_small_flex); r.draw_set_halign(1); r.draw_set_valign(1); r.draw_set_alpha(1);
        function text(x, y, value, width) {
            var scale = Math.min(1, width / Math.max(1, r.gml_Script_string_hd_width(m, m, value)));
            r.gml_Script_draw_hd_text_ext_transformed(m, m, x, y, value, -1, -1, scale, scale, 0);
        }
        function button(box, label, selected, enabled) {
            r.draw_set_color(selected ? 2631720 : 0); r.draw_rectangle(box.x, box.y, box.x + box.w, box.y + box.h, false);
            r.draw_set_color(!enabled ? 8421504 : selected ? 65535 : 16777215);
            r.draw_rectangle(box.x, box.y, box.x + box.w, box.y + box.h, true);
            text(box.x + box.w / 2, box.y + box.h / 2, label, box.w - 10);
        }
        if (s.selecting) {
            r.draw_set_alpha(0.65); r.draw_set_color(0);
            r.draw_rectangle(0, 30, r.display_get_gui_width(), r.display_get_gui_height(), false);
            r.draw_set_alpha(1); r.draw_rectangle(ui.x, ui.y, ui.x + ui.w, ui.y + ui.h, false);
            r.draw_set_color(65535); r.draw_rectangle(ui.x, ui.y, ui.x + ui.w, ui.y + ui.h, true);
            text(ui.x + ui.w / 2, ui.y + 15, "CHOOSE YOUR PLAY", ui.w - 24);
            ui.cards.forEach(function (box, i) { button(box, (i + 1) + ". " + PLAYS[i].name, s.selected === box.id, s.available.indexOf(box.id) >= 0); });
            var play = PLAYS.find(function (p) { return p.id === s.selected; });
            r.draw_set_color(16777215); text(ui.x + ui.w / 2, ui.y + 138, play.hint, ui.w - 24);
            button(ui.confirm, "CALL " + play.name, true, true);
            r.draw_set_color(12632256); text(ui.x + ui.w / 2, ui.y + 189, "1-5 / ARROWS / STICK TO CHOOSE - ENTER / A TO CALL", ui.w - 24);
        } else button(ui.reopen, "PLAYBOOK [P]", false, true);
        r.draw_set_color(color); r.draw_set_font(font); r.draw_set_halign(ha); r.draw_set_valign(va); r.draw_set_alpha(alpha);
    }
    r.RetroPlaybook = { isAutomatic: isAutomatic, setAutomatic: setAutomatic, updateOption: updateOption,
        toggleOption: toggleOption, afterSetup: afterSetup, reset: reset, choose: choose, step: step,
        updateBall: updateBall, draw: draw, layout: layout, plays: PLAYS };
})(window);
