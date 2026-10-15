/* Live defense for the GameMaker export. Football outcomes remain in RetroBowl.js. */
(function (root, factory) {
    var api = factory(root);
    if (typeof module === "object" && module.exports) module.exports = api;
    else root.RetroDefense = api;
})(typeof window === "object" ? window : globalThis, function (root) {
    "use strict";
    var FORMATIONS = { "4-3": [4, 3, 2, 2], "3-4": [3, 4, 2, 2], Nickel: [4, 2, 3, 2], Dime: [4, 1, 4, 2] };
    var CALLS = ["Balanced", "Run", "Pass", "Blitz"];
    var BOUNDS = { left: 145, right: 2455, top: 134, bottom: 466 };
    var LIVE_BALL = [18, 19, 2, 5, 9, 10];
    function clamp(n, min, max) { return Math.max(min, Math.min(max, n)); }
    function distance(a, b) { return Math.hypot(a.x - b.x, a.y - b.y); }
    function unit(x, y) { var d = Math.hypot(x, y); return d ? { x: x / d, y: y / d } : { x: 0, y: 0 }; }
    function eligible(p) { return p && !p.marked && p.active !== false && !p.gmldead && [4, 5, 8, 10].indexOf(p.gmlanim) < 0; }
    function chooseNext(players, selected) {
        var list = players.filter(eligible).slice().sort(function (a, b) { return a.gmlinum - b.gmlinum || a.id - b.id; });
        if (!list.length) return null;
        var index = list.findIndex(function (p) { return p.id === selected; });
        return list[(index + 1) % list.length].id;
    }
    function formation(name, scrim, direction, center) {
        var counts = FORMATIONS[name] || FORMATIONS["4-3"], slots = [];
        ["DL", "LB", "CB", "S"].forEach(function (role, group) {
            for (var i = 0; i < counts[group]; i++) {
                var y = role === "CB" ? 155 + i * (290 / Math.max(1, counts[group] - 1)) : center + (i - (counts[group] - 1) / 2) * (role === "S" ? 116 : 30);
                var depth = [22, 95, 72, 210][group];
                slots.push({ role: role, x: clamp(scrim + direction * depth, BOUNDS.left, BOUNDS.right), y: clamp(y, 148, 452) });
            }
        });
        return slots;
    }
    function pursuit(p, carrier) {
        var lead = clamp(distance(p, carrier) / 5, 0, 35);
        return { x: clamp(carrier.x + (carrier.hspeed || 0) * lead, BOUNDS.left, BOUNDS.right), y: clamp(carrier.y + (carrier.vspeed || 0) * lead, BOUNDS.top, BOUNDS.bottom) };
    }
    function separate(p, players) {
        var force = { x: 0, y: 0 };
        players.forEach(function (other) {
            if (other.id === p.id || !eligible(other)) return;
            var d = distance(p, other);
            if (d >= 22) return;
            var v = d > 0.001 ? unit(p.x - other.x, p.y - other.y) : { x: p.id < other.id ? -1 : 1, y: 0 };
            force.x += v.x * (22 - d) / 22;
            force.y += v.y * (22 - d) / 22;
        });
        return force;
    }
    function canTackle(p, carrier, ball, snapped, radius) {
        return !!(snapped && eligible(p) && carrier && carrier.id === ball.gmlholder && !carrier.gmldead && !ball.gmlis_dead && LIVE_BALL.indexOf(ball.gmlstate) >= 0 && p.gmloffense !== carrier.gmloffense && distance(p, carrier) <= radius);
    }
    function fumbleOpportunity(snapNumber, defenderNumber, strength, skill) {
        return strength > skill && (snapNumber * 13 + defenderNumber * 7) % 29 === 0;
    }
    function passTrajectory(qb, receiver, frames) {
        var target = { x: clamp(receiver.x + (receiver.hspeed || 0) * frames, 200, 2400), y: clamp(receiver.y + (receiver.vspeed || 0) * frames, 144, 456) };
        // Native movement applies 0.986 drag and 0.08 gravity before each step.
        var travel = 0.986 * (1 - Math.pow(0.986, frames)) / (1 - 0.986);
        // Cross the receiver at catchable height, then land twelve frames later.
        return { x: target.x, y: target.y, direction: Math.atan2(target.y - qb.y, target.x - qb.x) * 180 / Math.PI, velocity: distance(qb, target) / travel, zvel: 0.08 * (frames + 13) / 2 };
    }
    function aiTarget(p, context) {
        if (context.ball.gmlstate === 3 && context.landing) return context.landing;
        var carrier = context.carrier;
        if (carrier && (!carrier.gmloffense || context.running || carrier.gmlposition !== 1)) return pursuit(p, carrier);
        if (p._defRole === "DL" || (context.call === "Blitz" && p._defRole === "LB")) return carrier ? pursuit(p, carrier) : p._defHome;
        var receivers = context.receivers;
        if (p._defRole === "CB" && receivers.length) {
            var receiver = receivers[p._defAssignment % receivers.length];
            return { x: clamp(receiver.x + context.direction * 26, BOUNDS.left, BOUNDS.right), y: clamp(receiver.y, BOUNDS.top, BOUNDS.bottom) };
        }
        var depth = p._defRole === "S" ? (context.call === "Pass" ? 260 : 190) : (context.call === "Run" ? 65 : 115);
        return { x: clamp(context.scrim + context.direction * depth, BOUNDS.left, BOUNDS.right), y: clamp(p._defHome.y + (carrier ? (carrier.y - p._defHome.y) * 0.3 : 0), BOUNDS.top, BOUNDS.bottom) };
    }
    function objects(index) { return root.GetWithArray(index); }
    function master() { return objects(98)[0]; }
    function controller() { return objects(105)[0]; }
    function ballObject() { return objects(root.global.gmlmaster_ball)[0]; }
    function shouldPlay(m) {
        var c = master();
        return !!(m && c && !c.gmlsim_action && !c.gmlqb_mode && !c.gmlgamepractice && c.gmlplayerteamindex >= 0 && Number(m.gmlpossession) !== Number(m.gmlhuman_team) && m.gmlcomm_stage !== 31);
    }
    function active(m) { return !!(m && m._liveDefense && shouldPlay(m) && !m.gmlkicking && m.gmlstate === 2); }
    function prefs(m) { return m._defensePrefs || (m._defensePrefs = { formation: "Auto", call: "Balanced" }); }
    function reset(m) {
        if (!m) return;
        if (m._cpuFieldGoal) {
            m.gmldrivedir = m._cpuFieldGoal.orientation;
            m._cpuFieldGoal = null;
            m.alarm[0] = -1;
        }
        // A reset can destroy a dead ball while its result alarm is still pending.
        // Cancel that alarm so it cannot resolve a stale ball or the next play.
        if (m._liveDefense) m.alarm[0] = -1;
        m._liveDefense = null;
    }
    function cpuFieldGoal(m) {
        return !!(m && m._cpuFieldGoal && m.gmlstate === 2 && m.gmlkicking === 1);
    }
    function startCpuFieldGoal(m) {
        if (!shouldPlay(m) || m.gmlcomm_stage !== 6) return false;
        if (cpuFieldGoal(m)) return true;
        reset(m);
        var orientation = m.gmldrivedir;
        if (root.global.gmlexhibition) root.gml_Script_s_force_kick_direction(m, m);
        else m.gmldrivedir = -orientation;
        m.gmlstate = 2; m.gmlcomm_stage = 3; m.gmlcomm_proceed = false;
        m.gmlcomm_txt = ""; m.gmltap_msg = "";
        root.gml_Script_s_set_up_fieldgoal(m, m, 1);
        m._cpuFieldGoal = { orientation: orientation, ballId: ballObject().id };
        m.alarm[0] = -1; m.alarm[1] = -1;
        // Only the CPU chooses this kick. Hide the offensive change-play button.
        [12, 30, 32].forEach(function (type) { objects(type).forEach(function (button) { root.instance_destroy(button); }); });
        cpuKickCamera(m);
        return true;
    }
    function cpuKickCamera(m) {
        if (!cpuFieldGoal(m)) return false;
        var camera = root.g_pBuiltIn.view_camera[0], goal = m.gmldrivedir === 1 ? 2510 : 90;
        // Frame nearby uprights immediately; follow the ball on longer attempts.
        var b = ballObject(), focus = b.gmlstate === 3 ? b.x : m.gmlx_scrim - m.gmldrivedir * 80;
        var center = Math.abs(m.gmlx_scrim - goal) <= 720 ? (m.gmlx_scrim + goal) / 2 : focus + m.gmldrivedir * 200;
        root.camera_set_view_size(camera, 960, 540);
        root.camera_set_view_pos(camera, clamp(center - 480, 0, root.g_pBuiltIn.room_width - 960), Math.max(0, Math.min(30, root.g_pBuiltIn.room_height - 540)));
        return true;
    }
    function special(m) {
        if (!shouldPlay(m) || (m.gmldown !== 4 && m.gmldown !== 6 && m.gmldown !== 7)) return false;
        // Route fourth down to live special teams; point conversions use commentary.
        reset(m);
        m.gmlstate = 1;
        if (m.gmldown === 4) {
            if (m.gmlscrimmage >= 0) { m.gmlcomm_stage = 6; root.gml_Script_s_update_commentary(m, m); }
            else root.gml_Script_s_action_result(m, m, 5);
        } else if (m.gmldown >= 6 && m.gmldown < 99) {
            m.gmlcomm_stage = 10; root.gml_Script_s_update_commentary(m, m);
        } else return false;
        return true;
    }
    function position(m, state) {
        var settings = prefs(m), defenders = objects(109).slice().sort(function (a, b) { return a.gmlinum - b.gmlinum; });
        var receivers = objects(108).filter(function (p) { return [2, 3, 4].indexOf(p.gmlposition) >= 0; });
        state.formation = settings.formation === "Auto" ? (m.gmlyards <= 3 || m.gmlscrimmage >= 40 ? "4-3" : m.gmlyards >= 12 ? "Dime" : m.gmlyards >= 7 || receivers.length >= 4 ? "Nickel" : "4-3") : settings.formation;
        var slots = formation(state.formation, m.gmlx_scrim, m.gmldrivedir, m.gmly_scrim);
        defenders.forEach(function (p, i) {
            var slot = slots[i];
            if (!slot) return;
            p.x = slot.x; p.y = slot.y;
            p.hspeed = 0; p.vspeed = 0;
            p._defRole = slot.role; p._defHome = { x: p.x, y: p.y }; p._defAssignment = i;
            p.gmlgoalline_attack = m.gmldrivedir === 1 ? 300 : 2300;
            p.gmlgoalline_defend = m.gmldrivedir === 1 ? 2300 : 300;
        });
        var selected = defenders.find(function (p) { return p._defRole === "LB"; }) || defenders[0];
        state.selected = selected ? selected.id : null;
        m.gmldefensive_cover = settings.call === "Blitz" ? 0 : settings.call === "Pass" ? 3 : 2;
    }
    function afterSetup(m) {
        reset(m);
        if (!shouldPlay(m) || m.gmlkicking || m.gmldown > 3) return;
        var ball = ballObject();
        if (!ball || objects(109).length !== 11) return;
        var seed = Number(m.gmlsnaps) + Number(m.gmldown) + Math.round(m.gmlscrimmage);
        var state = m._liveDefense = { ballId: ball.id, selected: null, frame: 0, snapped: false, ended: false, contact: {}, cooldown: {}, tackleEvents: 0, run: ((seed % 3) + 3) % 3 === 0, input: { x: 0, y: 0 }, joystick: null };
        position(m, state);
        // Audibles and field-goal buttons belong to the offense.
        [32, 122, 124].forEach(function (type) { objects(type).forEach(function (b) { root.instance_destroy(b); }); });
        m.gmltap_msg = "";
    }
    function steer(p, x, y, force) {
        p.gmljdir = Math.atan2(-y, x) * 180 / Math.PI;
        p.gmljforce = clamp(force === undefined ? Math.hypot(x, y) : force, 0, 1);
    }
    function snap(m) {
        if (!active(m) || m._liveDefense.snapped) return;
        var ball = ballObject(), state = m._liveDefense;
        if (!ball || ball.id !== state.ballId) return;
        state.snapped = true; state.frame = 0;
        ball.gmlstate = 18;
        ball.gmlxthrow = ball.x; ball.gmlythrow = ball.y;
        m.gmlplay_start = root.g_pBuiltIn.get_current_time();
        m.gmlgametimer = m.gmlplay_start;
        m.gmltap_msg = "";
    }
    function switchPlayer(m) {
        if (active(m)) m._liveDefense.selected = chooseNext(objects(109), m._liveDefense.selected);
    }
    function tackle(m, p, carrier, radius) {
        var state = m._liveDefense, ball = ballObject();
        if (!state || state.ended || !ball || !canTackle(p, carrier, ball, state.snapped, radius)) return false;
        if ((state.cooldown[p.id] || 0) > state.frame) return false;
        if (carrier.gmlstiff_arm > 0 && carrier.gmlposition !== 1) {
            carrier.gmlstiff_arm--; p.gmldead = root.g_pBuiltIn.get_current_time();
            root.gml_Script_s_set_anim(p, p, 4); state.cooldown[p.id] = state.frame + 90;
            return false;
        }
        if (carrier.gmloffense && carrier.gmlposition !== 1 && ball.gmlstate === 5 && fumbleOpportunity(m.gmlsnaps, p.gmlinum, p.gmlstrength, carrier.gmlskill)) {
            root.gml_Script_s_drop_ball(carrier, p, true);
            state.cooldown[p.id] = state.frame + 20;
            state.contact = {};
            return false; // Native loose-ball recovery and turnover rules now own the outcome.
        }
        state.ended = true; state.tackleEvents++;
        p.gmldone_tackle = true;
        carrier.gmllast_tackled = p.id; carrier.hspeed = 0; carrier.vspeed = 0;
        root.gml_Script_s_set_anim(carrier, p, 4);
        root.gml_Script_s_sound_tackle(p, carrier);
        // Spot the actual carrier, then let the native sack/safety/down logic decide.
        ball.x = carrier.x; ball.y = carrier.y;
        root.gml_Script_s_set_ball_down(ball, p);
        root.gml_Script_s_is_ball_dead(ball, p);
        if (!p.gmloffense) {
            addStat(p, "stat_tackles");
            if (ball.gmlstate === 11) addStat(p, "stat_sacks");
        }
        return true;
    }
    function addStat(p, key) {
        if (p.gmlpmap >= 0 && root.ds_map_exists(p.gmlpmap, key)) root.ds_map_set(p.gmlpmap, key, root.ds_map_find_value(p.gmlpmap, key) + 1);
    }
    function recordInterception(p) {
        var m = controller();
        if (!active(m) || p.gmloffense || m._liveDefense.intercepted) return;
        m._liveDefense.intercepted = true;
        addStat(p, "stat_int");
    }
    function dive(m) {
        if (!active(m) || !m._liveDefense.snapped) return;
        var state = m._liveDefense, p = objects(state.selected)[0], ball = ballObject(), carrier = ball && objects(ball.gmlholder)[0];
        if (!eligible(p) || (state.cooldown[p.id] || 0) > state.frame || state.ended) return;
        if (!tackle(m, p, carrier, 24)) {
            state.cooldown[p.id] = state.frame + 35;
            if (carrier && carrier.gmloffense && distance(p, carrier) < 90) {
                var v = unit(carrier.x - p.x, carrier.y - p.y);
                p.hspeed += v.x * 1.5; p.vspeed += v.y * 1.5;
            }
        }
    }
    function guiButtons(m) {
        var state = m._liveDefense, width = root.display_get_gui_width();
        var scale = Math.min(1, (width - 32) / 302);
        if (!state.snapped) return [
            { x: 8, w: 120 * scale, text: state.formation, hint: "FORMATION [F]", action: "formation" },
            { x: 16 + 120 * scale, w: 100 * scale, text: prefs(m).call, hint: "CALL [C]", action: "call" },
            { x: width - 8 - 82 * scale, w: 82 * scale, text: "SNAP", hint: "SPACE / ENTER", action: "snap" }
        ];
        return [{ x: width - 16 - 162 * scale, w: 80 * scale, text: "SWITCH", hint: "[Q]", action: "switch" }, { x: width - 8 - 82 * scale, w: 82 * scale, text: "TACKLE", hint: "SPACE / ENTER", action: "dive" }];
    }
    function changeCall(m, action) {
        var settings = prefs(m);
        if (action === "call") settings.call = CALLS[(CALLS.indexOf(settings.call) + 1) % CALLS.length];
        else { var names = ["Auto"].concat(Object.keys(FORMATIONS)); settings.formation = names[(names.indexOf(settings.formation) + 1) % names.length]; }
        position(m, m._liveDefense);
    }
    function input(m) {
        var s = m._liveDefense, x = 0, y = 0;
        if (root.keyboard_check(65) || root.keyboard_check(37)) x--;
        if (root.keyboard_check(68) || root.keyboard_check(39)) x++;
        if (root.keyboard_check(87) || root.keyboard_check(38)) y--;
        if (root.keyboard_check(83) || root.keyboard_check(40)) y++;
        if (root.keyboard_check_pressed(81) || root.keyboard_check_pressed(9)) switchPlayer(m);
        if (!s.snapped) {
            if (root.keyboard_check_pressed(70)) changeCall(m, "formation");
            if (root.keyboard_check_pressed(67)) changeCall(m, "call");
        }
        if (root.keyboard_check_pressed(32) || root.keyboard_check_pressed(13)) { if (!s.snapped) snap(m); else dive(m); }
        var gp = root.global.gmlgamepad ? objects(root.global.gmlgp)[0] : null, slot = gp ? gp.gmlslot : -1;
        // This export disables its GML gamepad manager in browsers. Read the
        // runner's own pad API during defense without changing offensive input.
        if (!gp) {
            for (var padIndex = 0; padIndex < root.gamepad_get_device_count(); padIndex++) {
                if (root.gamepad_is_connected(padIndex)) { slot = padIndex; break; }
            }
        }
        if (slot >= 0) {
            var ax = gp ? Number(gp.gmlaxisl_h) || 0 : root.gamepad_axis_value(slot, 32785);
            var ay = gp ? Number(gp.gmlaxisl_v) || 0 : root.gamepad_axis_value(slot, 32786);
            x += Math.abs(ax) >= 0.15 ? ax : 0; y += Math.abs(ay) >= 0.15 ? ay : 0;
            if (root.gamepad_button_check_pressed(slot, 32771)) switchPlayer(m);
            if (root.gamepad_button_check_pressed(slot, gp ? root.global.gmlgp_select : 32769)) { if (!s.snapped) snap(m); else dive(m); }
            if (!s.snapped && root.gamepad_button_check_pressed(slot, 32772)) changeCall(m, "call");
            if (!s.snapped && root.gamepad_button_check_pressed(slot, 32773)) changeCall(m, "formation");
        }
        // Poll GameMaker's pointer/touch input, with no browser event subscriptions.
        var bottom = root.display_get_gui_height() - 27, seen = [];
        [1, 2, 3, 0].forEach(function (device) {
            if (!root.device_mouse_check_button_pressed(device, 1)) return;
            var mx = root.device_mouse_x_to_gui(device), my = root.device_mouse_y_to_gui(device);
            // The first touch can also appear as a compatibility mouse event.
            if (seen.some(function (p) { return Math.abs(p.x - mx) < 1 && Math.abs(p.y - my) < 1; })) return;
            seen.push({ x: mx, y: my });
            var hit = guiButtons(m).find(function (b) { return mx >= b.x && mx <= b.x + b.w && my >= bottom && my <= bottom + 23; });
            if (hit) {
                if (hit.action === "snap") snap(m);
                if (hit.action === "switch") switchPlayer(m);
                if (hit.action === "dive") dive(m);
                if (hit.action === "call" || hit.action === "formation") changeCall(m, hit.action);
            } else if (s.snapped && !s.joystick) s.joystick = { x: mx, y: my, device: device };
        });
        // Recover a held drag when a touch-to-mouse transition misses its press
        // edge; movement still starts only on the field, outside the controls.
        if (s.snapped && !s.joystick) {
            [1, 2, 3, 0].some(function (device) {
                if (!root.device_mouse_check_button(device, 1)) return false;
                var mx = root.device_mouse_x_to_gui(device), my = root.device_mouse_y_to_gui(device);
                if (my >= bottom) return false;
                s.joystick = { x: mx, y: my, device: device };
                return true;
            });
        }
        if (s.joystick) {
            if (root.device_mouse_check_button(s.joystick.device, 1)) {
                x += clamp((root.device_mouse_x_to_gui(s.joystick.device) - s.joystick.x) / 30, -1, 1);
                y += clamp((root.device_mouse_y_to_gui(s.joystick.device) - s.joystick.y) / 30, -1, 1);
            } else s.joystick = null;
        }
        var length = Math.hypot(x, y); s.input = length > 1 ? unit(x, y) : { x: x, y: y };
    }
    function step(m) {
        if (!active(m)) { if (m._liveDefense && !shouldPlay(m)) reset(m); return; }
        var state = m._liveDefense, ball = ballObject();
        if (!ball || ball.id !== state.ballId) { reset(m); return; }
        if (ball.gmlis_dead || state.ended) { state.input = { x: 0, y: 0 }; state.joystick = null; return; }
        input(m);
        if (!state.snapped) return;
        state.frame++;
        var defenders = objects(109), selected = objects(state.selected)[0], carrier = objects(ball.gmlholder)[0];
        if (!eligible(selected)) switchPlayer(m);
        if (carrier && !carrier.gmloffense) state.selected = carrier.id;
        defenders.forEach(function (p) {
            if (!canTackle(p, carrier, ball, true, 14)) { delete state.contact[p.id]; return; }
            state.contact[p.id] = (state.contact[p.id] || 0) + 1;
            if (state.contact[p.id] >= 8) tackle(m, p, carrier, 14);
        });
        // The original offense must still be able to tackle an interception returner.
        if (carrier && !carrier.gmloffense) objects(108).forEach(function (p) { tackle(m, p, carrier, 12); });
    }
    function destination(p) {
        var m = controller();
        if (!active(m)) return false;
        var state = m._liveDefense, ball = ballObject();
        if (!ball || ball.id !== state.ballId) return false;
        if (!state.snapped || state.ended || ball.gmlis_dead) { p.gmljforce = 0; return true; }
        if (p.gmldead || p.gmltackling >= 0) return false;
        if (p.id === state.selected) { steer(p, state.input.x, state.input.y); return true; }
        var carrier = objects(ball.gmlholder)[0];
        if (p.gmloffense) {
            if (carrier && !carrier.gmloffense) {
                var chase = pursuit(p, carrier); steer(p, chase.x - p.x, chase.y - p.y, 1); return true;
            }
            if (ball.gmlholder === p.id) {
                if (p.gmlposition === 1 && ball.gmlstate === 18) { steer(p, -m.gmldrivedir, 0, state.frame < 55 ? 0.35 : 0); return true; }
                var opponents = objects(109).filter(eligible).sort(function (a, b) { return distance(p, a) - distance(p, b); });
                var near = opponents[0], avoid = near && distance(p, near) < 80 ? (p.y >= near.y ? 0.6 : -0.6) : (300 - p.y) / 180;
                steer(p, m.gmldrivedir, clamp(avoid, -0.7, 0.7), 1); return true;
            }
            return false; // Native routes and offensive-line blocking.
        }
        if (!eligible(p)) { p.gmljforce = 0; return true; }
        var shadow = objects(112)[0];
        var target = aiTarget(p, { ball: ball, carrier: carrier, landing: shadow && { x: shadow.gmlbounce_x, y: shadow.gmlbounce_y }, receivers: objects(108).filter(function (r) { return [2, 3, 4].indexOf(r.gmlposition) >= 0 && eligible(r); }), running: m.gmlrunning_play, call: prefs(m).call, direction: m.gmldrivedir, scrim: m.gmlx_scrim });
        var v = unit(target.x - p.x, target.y - p.y), spacing = separate(p, objects(109));
        steer(p, v.x + spacing.x * 0.45, v.y + spacing.y * 0.45, clamp(distance(p, target) / 24, 0, 1));
        return true;
    }
    function updateBall(ball) {
        var m = controller();
        if (!active(m)) return false;
        var state = m._liveDefense;
        if (ball.id !== state.ballId) return false;
        if (!state.snapped) { root.gml_Script_s_update_ball_offset(ball, ball); return true; }
        if ([0, 1, 2, 18, 19].indexOf(ball.gmlstate) < 0) return false;
        var qb = objects(ball.gmlholder)[0];
        if (!qb || !qb.gmloffense || qb.gmlposition !== 1 || state.ended) return false;
        root.gml_Script_s_update_ball_offset(ball, qb);
        if (state.run && state.frame >= 22) {
            var rb = objects(108).find(function (p) { return p.gmlposition === 2 && eligible(p); });
            if (rb) { m.gmlrunning_play = true; root.gml_Script_s_receive_ball(rb, qb); return true; }
        }
        if (state.frame >= 100) {
            var defenders = objects(109).filter(eligible), receivers = objects(108).filter(function (p) { return [2, 3, 4].indexOf(p.gmlposition) >= 0 && eligible(p) && (p.x - qb.x) * m.gmldrivedir > 40; });
            receivers.sort(function (a, b) {
                function score(r) { return Math.min.apply(Math, defenders.map(function (d) { return distance(r, d); }).concat([500])) - distance(qb, r) * 0.08; }
                return score(b) - score(a) || a.id - b.id;
            });
            var receiver = receivers[0];
            if (receiver) {
                var flight = passTrajectory(qb, receiver, 40);
                ball.gmldirec = flight.direction; ball.gmlvelocity = flight.velocity; ball.gmlzvel = flight.zvel; ball.gmlheight = 1;
                root.gml_Script_s_throw_ball(ball, qb);
            } else if (state.frame >= 160) { m.gmlrunning_play = true; ball.gmlstate = 5; qb.gmlqb_rushing = true; }
        }
        return true;
    }
    function skipHuman(p) { return active(controller()) && p.gmloffense; }
    function opponentOffense() {
        var m = controller();
        if (cpuFieldGoal(m)) return true;
        if (!active(m)) return false;
        var b = ballObject(), holder = b && objects(b.gmlholder)[0];
        return !holder || holder.gmloffense;
    }
    function skipNativeTackle(p) {
        var m = controller();
        if (!active(m)) return false;
        var b = ballObject(), carrier = b && objects(b.gmlholder)[0];
        if (!m._liveDefense.snapped || !b || b.gmlis_dead || m._liveDefense.ended) return true;
        if (b.gmlholder === p.id) return true;
        // Non-carrier contacts still use native blocking. Carrier tackles are gated above.
        return !!(carrier && p.gmloffense !== carrier.gmloffense && (!p.gmloffense || p.gmlnearest_opp === carrier.id));
    }
    function bounds(p) {
        if (!active(controller()) || p.gmloffense) return;
        var x = clamp(p.x, BOUNDS.left, BOUNDS.right), y = clamp(p.y, BOUNDS.top, BOUNDS.bottom);
        if (p.x !== x) p.hspeed = 0;
        if (p.y !== y) p.vspeed = 0;
        p.x = x; p.y = y;
    }
    function draw(m) {
        if (!active(m)) return false;
        var s = m._liveDefense, b = ballObject();
        if (!b || b.gmlis_dead || s.ended) return false;
        var color = root.draw_get_color(), font = root.draw_get_font(), halign = root.draw_get_halign(), valign = root.draw_get_valign(), alpha = root.draw_get_alpha();
        root.draw_set_alpha(1); root.draw_set_font(root.global.gmlfnt_small_flex); root.draw_set_halign(1); root.draw_set_valign(1);
        var width = root.display_get_gui_width(), y = root.display_get_gui_height() - 27, buttons = guiButtons(m);
        // Hints and actions occupy separate rows outside the playing field.
        // Measure each label so it stays within its own slot on narrow screens.
        function textInSlot(x, ty, text, available) {
            var textWidth = root.gml_Script_string_hd_width(m, m, text);
            var scale = Math.min(1, available / Math.max(1, textWidth));
            root.gml_Script_draw_hd_text_ext_transformed(m, m, x, ty, text, -1, -1, scale, scale, 0);
        }
        root.draw_set_color(0); root.draw_rectangle(0, y - 14, width, root.display_get_gui_height(), false);
        buttons.forEach(function (button) {
            root.draw_set_color(0); root.draw_rectangle(button.x, y, button.x + button.w, y + 23, false);
            root.draw_set_color(65535); root.draw_rectangle(button.x, y, button.x + button.w, y + 23, true);
            textInSlot(button.x + button.w / 2, y + 11, button.text.toUpperCase(), button.w - 12);
            root.draw_set_color(12632256);
            textInSlot(button.x + button.w / 2, y - 7, button.hint, button.w - 4);
        });
        root.draw_set_color(65535);
        if (s.snapped) {
            var available = buttons[0].x - 16, center = 8 + available / 2;
            textInSlot(center, y - 7, "DEFENSE", available);
            textInSlot(center, y + 11, "MOVE: WASD / ARROWS OR DRAG", available);
        }
        root.draw_set_color(color); root.draw_set_font(font); root.draw_set_halign(halign); root.draw_set_valign(valign); root.draw_set_alpha(alpha);
        return true;
    }
    function marker(p) {
        var m = controller();
        if (!active(m) || m._liveDefense.selected !== p.id || !eligible(p)) return;
        var color = root.draw_get_color();
        root.draw_set_color(65535); root.draw_circle(p.x, p.y + 2, 15, true); root.draw_set_color(color);
    }
    return { cpuKickCamera: cpuKickCamera, cpuFieldGoal: cpuFieldGoal, startCpuFieldGoal: startCpuFieldGoal, active: active, shouldPlay: shouldPlay, special: special, afterSetup: afterSetup, reset: reset, step: step, destination: destination, updateBall: updateBall, skipHuman: skipHuman, opponentOffense: opponentOffense, skipNativeTackle: skipNativeTackle, bounds: bounds, draw: draw, marker: marker, snap: snap, switchPlayer: switchPlayer, dive: dive, tackle: tackle, recordInterception: recordInterception,
        logic: { FORMATIONS: FORMATIONS, BOUNDS: BOUNDS, formation: formation, pursuit: pursuit, separate: separate, canTackle: canTackle, fumbleOpportunity: fumbleOpportunity, chooseNext: chooseNext, passTrajectory: passTrajectory, aiTarget: aiTarget, unit: unit, eligible: eligible } };
});
