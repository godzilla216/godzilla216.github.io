/* Playable punts for the exported runner. No persistent career/save fields. */
(function (root, factory) {
    var api = factory(root);
    if (typeof module === "object" && module.exports) module.exports = api;
    else root.RetroPunt = api;
})(typeof window === "object" ? window : globalThis, function (r) {
    "use strict";
    var clamp = function (n, a, b) { return Math.max(a, Math.min(b, n)); };
    var HAND_HEIGHT = 18;
    // spr_kick2 frame 1: the forward cleat contacts at (12, -12), at scale 2.
    var CONTACT = { x: 12, height: 12, frame: 1 };
    function objects(type) { return r.GetWithArray(type); }
    function match() { return objects(105)[0]; }
    function ball() { return objects(r.global.gmlmaster_ball)[0]; }
    // Career orientation belongs to the human team. Exhibition orientation is
    // already selected per possession by s_force_kick_direction.
    function direction(orientation, possession, human, exhibition) {
        return orientation * (exhibition || Number(possession) === Number(human) ? 1 : -1);
    }
    function formation(scrim, dir) {
        // Backed up inside the five: fit inside the end line instead of putting
        // the punter outside the playable field. Normal depth is 14.5 yards.
        var kicking = [{ role: "punter", x: clamp(scrim - dir * 290, 110, 2490), y: 300 },
            { role: "snapper", x: scrim, y: 300 }];
        [-60, -30, 30, 60, -144, 144].forEach(function (y) { kicking.push({ role: "line", x: scrim, y: 300 + y }); });
        [-88, 88, 0].forEach(function (y) { kicking.push({ role: "protector", x: scrim - dir * 70, y: 300 + y }); });
        var receiving = [];
        for (var i = 0; i < 11; i++) receiving.push({ role: i === 9 ? "returner" : "receiver",
            x: clamp(scrim + dir * (i === 9 ? 900 : i < 5 ? 36 : i < 8 ? 240 : 520), 180, 2420),
            y: i === 9 ? 300 : [156, 228, 276, 348, 444, 190, 320, 410, 200, 300, 400][i] });
        return { kicking: kicking, receiving: receiving };
    }
    function trajectory(x, y, dir, aim, power, kickPower) {
        var radians = aim * Math.PI / 180;
        var distance = (30 + power * 40) * 20;
        // Same normal-kickoff launch speed, including the kicker's attribute.
        var velocity = (50 + clamp(power * 55, 15, 55)) * (kickPower === undefined ? 0.065 : kickPower) * 0.7;
        var drag = 0.9995;
        var frames = Math.ceil(Math.log(Math.max(0.001, 1 - distance * (1 - drag) / (velocity * drag))) / Math.log(drag));
        return { frames: frames, velocity: velocity, dx: dir * Math.cos(radians) * velocity,
            dy: Math.sin(radians) * velocity, zvel: 0.03 * (frames + 1) / 2 + (1 - CONTACT.height) / frames };
    }
    function landing(b) {
        var gravity = 0.03, drag = 0.9995, z = b.gmlzvel - gravity / 2;
        var frames = Math.max(0, Math.ceil((z + Math.sqrt(z * z + 2 * gravity * Math.max(0, b.gmlheight - 1))) / gravity));
        var distance = b.gmlvelocity * drag * (1 - Math.pow(drag, frames)) / (1 - drag);
        var angle = b.gmldirec * Math.PI / 180;
        return { x: b.x + Math.cos(angle) * distance, y: b.y + Math.sin(angle) * distance };
    }
    function eligible(m) {
        var c = objects(98)[0];
        return !!(m && c && !c.gmlsim_action && !c.gmlqb_mode && !c.gmlgamepractice && (m.gmldown === 4 || m.gmlcomm_stage === 5));
    }
    function active(m) { return !!(m && m._punt && m.gmlstate === 2); }
    function reset(m) {
        if (!m || !m._punt) return;
        m.gmldrivedir = m._punt.orientation;
        m.alarm[0] = -1; m._punt = null;
    }
    function offer(m, goAction, fieldGoalAction, puntAction) {
        r.gml_Script_s_create_message3(m, m, "", "Fourth down: choose your play.", "Go for it", "Field Goal", "Punt",
            goAction, fieldGoalAction, puntAction, 16777215, 0.7);
    }
    function start(m) {
        if (m && m._punt) return true; // Rapid UI callbacks cannot rebuild the play.
        if (!eligible(m)) return false;
        if (r.global.gmlexhibition) r.gml_Script_s_force_kick_direction(m, m);
        var orientation = m.gmldrivedir, dir = direction(orientation, m.gmlpossession, m.gmlhuman_team, r.global.gmlexhibition);
        var scrim = 1300 + dir * m.gmlscrimmage * 20, team = Number(m.gmlpossession);
        r.gml_Script_s_msg_clear(m, m);
        r.gml_Script_s_destroy_match_objects(m, m);
        [30, 32].forEach(function (type) { objects(type).forEach(function (button) { r.instance_destroy(button); }); });
        m.gmlstate = 2; m.gmlcomm_proceed = false; m.gmlkicking = 3;
        m.gmldown = 4;
        m.gmldrivedir = -dir; // Native kickoff objects: OF receives, DF covers.
        m.gmlx_scrim = scrim; m.gmly_scrim = 300; m.gmlx_yards = scrim;
        m.gmltap_msg = ""; m.gmlscored_by = -1; m.gmlscorer = "";
        m.gmlkick_dist = 43;
        m.alarm[0] = -1; m.alarm[1] = -1; r.global.gmlreplay_do = false;
        for (var i = 0; i < 11; i++) r.instance_create_layer(0, 0, "Players", 108);
        for (var j = 0; j < 11; j++) r.instance_create_layer(0, 0, "Players", 109);
        objects(107).forEach(function (p) { r.gml_Script_s_set_skills_and_skin(p, m); p.gmlmy_route_alpha = 0; });
        r.global.gmlmaster_ball = r.instance_create_layer(0, 0, "Ball", 111);
        r.instance_create_layer(0, 0, "Ball", 112);
        var slots = formation(scrim, dir), kickers = objects(109), receivers = objects(108);
        [kickers, receivers].forEach(function (players, group) {
            players.forEach(function (p, index) {
                var slot = (group ? slots.receiving : slots.kicking)[index];
                p.x = slot.x; p.y = slot.y; p._puntRole = slot.role;
                p.gmlposition = group ? (slot.role === "returner" ? 14 : 13) : (slot.role === "punter" ? 1 : 12);
                p.hspeed = 0; p.vspeed = 0; p.gmljforce = 0; p.gmlfacing = group ? -dir : dir;
                p.image_xscale = p.gmlfacing * 2;
                p.gmlgoalline_attack = p.gmlfacing === 1 ? 2300 : 300;
                p.gmlgoalline_defend = p.gmlfacing === 1 ? 300 : 2300;
                r.gml_Script_s_set_anim(p, p, 0);
                r.gml_Script_s_update_my_shadow(p, p);
            });
        });
        var b = ball();
        m._punt = { orientation: orientation, dir: dir, team: team, scrim: scrim, ballId: b.id,
            punter: kickers[0].id, punterX: kickers[0].x, snapper: kickers[1].id, returner: receivers[9].id,
            humanKick: team === Number(m.gmlhuman_team), humanReturn: team !== Number(m.gmlhuman_team),
            phase: "aim", frame: 0, elapsed: 0, aim: 0, aimFlip: 1, power: 0.65, meter: 0, launches: 0, resolved: false,
            fair: false, input: { x: 0, y: 0 }, pointer: null, contacts: {} };
        b.gmlholder = -4; b.gmlstate = 0; b.gmlheight = 3; b.gmlhidden = false;
        b.x = scrim; b.y = 300; b.gmlvelocity = 0; b.gmlzvel = 0; b.gmlis_dead = false;
        // Enter with both snapper and punter visible, even when the previous
        // possession/quarter left the camera looking at the opposite end.
        var camera = r.g_pBuiltIn.view_camera[0];
        m.gmlbzoom = 1; r.camera_set_view_size(camera, 960, 540);
        r.camera_set_view_pos(camera, clamp((scrim + kickers[0].x) / 2 - 480, 0, r.g_pBuiltIn.room_width - 960), 30);
        return true;
    }
    function transition(s, phase) { s.phase = phase; s.frame = 0; }
    function confirm(m) {
        if (!active(m)) return;
        var s = m._punt;
        if (s.phase === "aim") transition(s, "power");
        else if (s.phase === "power") {
            s.power = clamp(s.meter, 0.15, 1); transition(s, "bend");
            m.gmlkick_dist = Math.round(30 + s.power * 40 - Math.abs(s.scrim - s.punterX) / 20 + 1.2);
            var b = ball(); b.gmlstate = 18;
            m.gmlgametimer = r.g_pBuiltIn.get_current_time();
            m.gmlplay_start = m.gmlgametimer;
        }
    }
    function fairCatch(m) {
        if (active(m) && m._punt.phase === "flight" && m._punt.humanReturn) m._punt.fair = true;
    }
    function dive(m) {
        var s = m._punt, carrier = objects(s.returner)[0];
        if (s.phase === "return" && s.humanReturn && carrier && !s.dived) {
            s.dived = true; s.diveFrame = s.frame; r.gml_Script_s_set_anim(carrier, carrier, 5);
        }
    }
    function controls(m) {
        var s = m._punt, x = Number(r.keyboard_check(68) || r.keyboard_check(39)) - Number(r.keyboard_check(65) || r.keyboard_check(37));
        var y = Number(r.keyboard_check(83) || r.keyboard_check(40)) - Number(r.keyboard_check(87) || r.keyboard_check(38));
        var phase = s.phase, action = r.keyboard_check_pressed(32) || r.keyboard_check_pressed(13);
        if (s.humanKick && phase === "aim" && !y && !s.pointer) {
            var punter = objects(s.punter)[0];
            // Match the field-goal sweep's skill/difficulty speed, using a
            // local target so native kickoff state and ball ownership stay intact.
            var speed = clamp(9 - punter.gmlmy_kick_skill / 3 - (5 + m.gmldifficulty) / 5, 3, 9);
            var offset = Math.tan(s.aim * Math.PI / 180) * 100 / Math.tan(25 * Math.PI / 180);
            offset += s.aimFlip * speed;
            if (offset > 100) { offset = 200 - offset; s.aimFlip = -1; }
            else if (offset < -100) { offset = -200 - offset; s.aimFlip = 1; }
            s.aim = Math.atan2(offset, 100 / Math.tan(25 * Math.PI / 180)) * 180 / Math.PI;
        }
        if (s.humanKick && phase === "aim") s.aim = clamp(s.aim + y * 0.6, -25, 25);
        if (s.humanKick && action && (phase === "aim" || phase === "power")) confirm(m);
        if (r.keyboard_check_pressed(70)) fairCatch(m);
        var bottom = r.display_get_gui_height() - 30;
        if (!s.pointer) [1, 2, 3, 0].some(function (device) {
            if (!r.device_mouse_check_button(device, 1) && !r.device_mouse_check_button_pressed(device, 1)) return false;
            var mx = r.device_mouse_x_to_gui(device), my = r.device_mouse_y_to_gui(device);
            s.pointer = { device: device, x: mx, y: my, phase: phase, button: my >= bottom };
            if (my >= bottom) {
                if (phase === "flight") fairCatch(m);
                else if (phase === "return") dive(m);
                else if (s.humanKick) confirm(m);
            }
            return true;
        });
        if (s.pointer) {
            var p = s.pointer, held = r.device_mouse_check_button(p.device, 1);
            // Chromium can hand a touch over to its compatibility mouse. Keep
            // the same gesture until every device releases; never count that
            // handover as a second press that could lock power accidentally.
            if (!held) [1, 2, 3, 0].some(function (device) {
                if (!r.device_mouse_check_button(device, 1)) return false;
                p.device = device; held = true; return true;
            });
            var dx = r.device_mouse_x_to_gui(p.device) - p.x, dy = r.device_mouse_y_to_gui(p.device) - p.y;
            if (held && !p.button) {
                if (phase === "aim" && s.humanKick) s.aim = clamp(dy / 3, -25, 25);
                if (phase === "return" && s.humanReturn) { x += clamp(dx / 30, -1, 1); y += clamp(dy / 30, -1, 1); }
            }
            if (!held) {
                if (!p.button && s.humanKick && phase === p.phase && (phase === "aim" || phase === "power")) confirm(m);
                s.pointer = null;
            }
        }
        var length = Math.hypot(x, y); s.input = { x: x / Math.max(1, length), y: y / Math.max(1, length) };
        if (action && phase === "return" && s.humanReturn) dive(m);
    }
    function end(m, reason, x) {
        var s = m && m._punt;
        if (!s || s.phase === "dead" || s.resolved) return false;
        var ownEndzone = s.dir === 1 ? x >= 2300 : x <= 300;
        if (ownEndzone && (reason === "return" || reason === "out of bounds")) {
            reason = s.phase === "flight" || s.phase === "ground" || (s.caughtInEndzone && !s.leftEndzone) ? "touchback" : "safety";
        }
        s.reason = reason; s.spot = clamp(x, 300, 2300); transition(s, "dead");
        var b = ball(); b.gmlis_dead = true; b.gmlstate = 4; b.gmlxdead = s.spot; b.gmlydead = b.y;
        b.gmlvelocity = 0; b.gmlzvel = 0;
        objects(107).forEach(function (p) { p.hspeed = 0; p.vspeed = 0; p.gmljforce = 0; });
        m.alarm[0] = 45;
        return true;
    }
    function resolve(m) {
        if (!m || !m._punt) return false;
        var s = m._punt;
        if (s.phase !== "dead" || s.resolved) return true;
        s.resolved = true;
        m._lastPunt = { reason: s.reason, spot: s.spot, direction: s.dir, launches: s.launches };
        m.gmlscrimmage = s.reason === "touchback" ? 30 : Math.round(s.dir * (s.spot - 1300) / 20);
        m.gmly_down = ball().y;
        r.gml_Script_s_change_possession(m, m);
        m.gmlyards = Math.min(10, 50 - m.gmlscrimmage); m.gmldown = 1;
        // Use a distinct last-play value so commentary cannot add a second,
        // simulated return after the actual return was already played.
        m.gmllast_play = 32; m.gmlkicking = 0;
        m.gmlcomm_txt = s.reason === "touchback" ? "Punt touchback" : s.reason === "fair" ? "Fair catch" : "Punt " + s.reason;
        r.gml_Script_s_destroy_match_objects(m, m);
        m.gmlstate = 1; m.gmlcomm_proceed = false;
        if (s.reason === "touchdown") r.gml_Script_s_action_result(m, m, 1);
        else if (s.reason === "safety") r.gml_Script_s_action_result(m, m, 8);
        else if (m.gmlcollege_overtime) r.gml_Script_s_college_overtime_handle_play_end(m, m);
        r.gml_Script_s_is_quarter_over(m, m);
        return true;
    }
    function step(m) {
        if (!active(m)) return false;
        r.gml_Script_s_pause_step(m, m);
        if (r.gml_Script_s_is_paused_or_just_unpaused(m, m)) return true;
        var s = m._punt;
        if (!ball() || ball().id !== s.ballId) { reset(m); return false; }
        controls(m); s.frame++;
        if (s.phase === "power") s.meter = (1 - Math.cos(s.frame * 0.045)) / 2;
        if (!s.humanKick) {
            if (s.phase === "aim" && s.frame >= 40) confirm(m);
            else if (s.phase === "power" && s.meter >= 0.85) confirm(m);
        }
        if (["aim", "power", "dead"].indexOf(s.phase) < 0) {
            s.elapsed++;
            if (!m.gmlcollege_overtime && r.g_pBuiltIn.get_current_time() - m.gmlgametimer >= 700) {
                m.gmlgametimer = r.g_pBuiltIn.get_current_time(); r.gml_Script_s_subtract_time(m, m, 1, 1, "Punt");
            }
        }
        r.gml_Script_s_update_game_clock(m, m);
        return true;
    }
    function updateBall(b) {
        var m = match(); if (!active(m)) return false;
        if (r.gml_Script_s_is_paused_or_just_unpaused(m, m)) return true;
        var s = m._punt, punter = objects(s.punter)[0], snapper = objects(s.snapper)[0], f = s.frame;
        b.gmlhidden = false; b.depth = -b.y * 10;
        if (s.phase === "bend") {
            b.x = s.scrim + s.dir * (2 - Math.min(f, 18) / 3); b.y = 300; b.gmlheight = 3;
            if (f >= 18) { s.snapX = b.x; transition(s, "snap"); }
        } else if (s.phase === "snap") {
            var t = clamp(f / 16, 0, 1);
            b.x = s.snapX + (punter.x + s.dir * 10 - s.snapX) * t;
            b.y = 300; b.gmlheight = 3 + (HAND_HEIGHT - 3) * t + 8 * Math.sin(Math.PI * t);
            if (t === 1) { b.gmlholder = punter.id; transition(s, "catch"); }
        } else if (s.phase === "catch" || s.phase === "approach") {
            if (s.phase === "approach") punter.x = s.punterX + s.dir * 24 * clamp(f / 20, 0, 1);
            b.x = punter.x + s.dir * 10; b.y = punter.y; b.gmlheight = HAND_HEIGHT;
            if (s.phase === "catch" && f >= 10) transition(s, "approach");
            else if (s.phase === "approach" && f >= 20) { b.gmlholder = -4; s.dropX = b.x; transition(s, "drop"); }
        } else if (s.phase === "drop") {
            b.x = s.dropX + s.dir * (CONTACT.x - 10) * clamp(f / 14, 0, 1);
            b.gmlheight = HAND_HEIGHT - (HAND_HEIGHT - CONTACT.height) * Math.pow(clamp(f / 14, 0, 1), 2);
            if (f >= 14) {
                var flight = trajectory(b.x, b.y, s.dir, s.aim, s.power, punter.gmlmy_kick_power);
                s.flight = flight; s.launchX = b.x; s.launchY = b.y; s.launches++;
                b.gmlxthrow = b.x; b.gmlythrow = b.y; b.gmlholder = -4; b.gmlstate = 3;
                b.gmldirec = Math.atan2(flight.dy, flight.dx) * 180 / Math.PI;
                b.gmlvelocity = flight.velocity; b.gmlzvel = flight.zvel;
                b.gmlbouncecount = 0; b.gmlroll = 12;
                transition(s, "flight"); r.gml_Script_s_sound_kick(b, punter);
                var shadow = objects(112)[0], target = landing(b); shadow.gmlbounce_x = target.x; shadow.gmlbounce_y = target.y;
            }
        } else if (s.phase === "flight" || s.phase === "ground") {
            var settled = s.phase === "ground" && b.gmlheight <= 1 && Math.abs(b.gmlzvel) < 0.12;
            // Reuse kickoff drag, gravity, energy loss, tumble and bounce sounds.
            r.gml_Script_s_update_ball_movement(b, b, settled);
            if (settled) {
                b.gmlheight = 1; b.gmlzvel = 0; b.gmlvelocity *= 0.85;
                if (b.gmlvelocity < 0.1) { b.gmlvelocity = 0; b.gmlroll = 0; }
            }
            if (s.phase === "flight" && b.gmlbouncecount > 0) {
                transition(s, "ground"); s.fair = false; b.gmlstate = 13;
            }
            if (b.y < 132 || b.y > 468) {
                var fraction = ((b.y < 132 ? 132 : 468) - b.gmllast_y) / (b.y - b.gmllast_y);
                end(m, "out of bounds", b.gmllast_x + (b.x - b.gmllast_x) * fraction);
            } else if ((b.x >= 2500 && s.dir === 1) || (b.x <= 100 && s.dir === -1)) end(m, "touchback", b.x);
            else if (s.phase === "ground" && (s.dir === 1 ? b.x >= 2300 : b.x <= 300)) end(m, "touchback", b.x);
            else {
                if (s.phase === "ground") groundContact(m, b);
                else {
                    var receiver = objects(s.returner)[0];
                    if (b.gmlheight <= 24 && b.gmlzvel <= 0 && Math.hypot(receiver.x - b.x, receiver.y - b.y) <= 26) receive(m, b, receiver);
                }
            }
        } else if (s.phase === "return") {
            var carrier = objects(s.returner)[0]; b.x = carrier.x; b.y = carrier.y; b.gmlheight = 20;
            if (s.dir === 1 ? carrier.x < 2300 : carrier.x > 300) s.leftEndzone = true;
            if (carrier.y < 132 || carrier.y > 468) end(m, "out of bounds", carrier.x);
            else if ((carrier.x <= 300 && s.dir === 1) || (carrier.x >= 2300 && s.dir === -1)) end(m, "touchdown", carrier.x);
            else if ((carrier.x >= 2500 && s.dir === 1) || (carrier.x <= 100 && s.dir === -1)) end(m, s.caughtInEndzone && !s.leftEndzone ? "touchback" : "safety", carrier.x);
            else {
                objects(109).some(function (p) {
                    if (Math.hypot(p.x - carrier.x, p.y - carrier.y) > 15 || p.gmldead) { delete s.contacts[p.id]; return false; }
                    s.contacts[p.id] = (s.contacts[p.id] || 0) + 1;
                    if (s.contacts[p.id] >= 6) { r.gml_Script_s_set_anim(carrier, p, 4); return end(m, "return", carrier.x); }
                    return false;
                });
                if (s.dived && f - s.diveFrame > 20) end(m, "return", carrier.x);
            }
        }
        b.image_index = s.phase === "flight" || s.phase === "ground" || s.phase === "snap" ? f % Math.max(1, b.image_number) : 0;
        r.gml_Script_s_update_my_shadow(b, b);
        return true;
    }
    function receive(m, b, p) {
        var s = m._punt;
        s.returner = p.id; // Any receiving player who scoops it becomes the carrier.
        r.gml_Script_s_receive_ball(p, p); b.gmlvelocity = 0; b.gmlzvel = 0; b.gmlroll = 0;
        s.catchX = b.x; s.caughtInEndzone = s.dir === 1 ? b.x >= 2300 : b.x <= 300;
        if (s.fair) end(m, s.caughtInEndzone ? "touchback" : "fair", b.x);
        else transition(s, "return");
    }
    function groundContact(m, b) {
        if (b.gmlheight > 12) return;
        var s = m._punt, touching = objects(107).filter(function (p) {
            return !p.gmldead && p.y >= 132 && p.y <= 468 && Math.hypot(p.x - b.x, p.y - b.y) <= 14;
        });
        touching.sort(function (a, c) { return Math.hypot(a.x - b.x, a.y - b.y) - Math.hypot(c.x - b.x, c.y - b.y) || a.id - c.id; });
        var p = touching[0];
        if (!p) return; // Landing, bouncing or coming to rest never downs it.
        if (p.gmloffense) receive(m, b, p);
        else end(m, "downed", b.x);
    }
    function animatePlayer(p, s) {
        var sprite, frame = 0, anim = 0, f = s.frame;
        if (p.id === s.snapper) {
            if (s.phase === "bend") {
                sprite = f >= 12 ? 0x47 : 0x25;
                frame = f >= 6 && f < 12 ? 1 : 0;
            } else if (s.phase === "snap") { sprite = 0x47; frame = f < 6 ? 0 : 1; }
            else if (s.phase === "catch") { sprite = 0x25; frame = 1; }
            else if (["aim", "power", "approach", "drop"].indexOf(s.phase) >= 0) sprite = 0x25;
        } else if (p.id === s.punter) {
            if (["aim", "power", "bend", "snap"].indexOf(s.phase) >= 0) { sprite = 0x25; frame = 2; }
            else if (s.phase === "catch") sprite = 0x25;
            else if (s.phase === "approach") { sprite = 0x2d; frame = Math.floor(f / 4) % 6; anim = 2; }
            else if (s.phase === "drop") { sprite = 0x46; frame = f < 14 ? 0 : CONTACT.frame; anim = 15; }
            else if (s.phase === "flight" && f < 16) { sprite = 0x46; frame = Math.min(4, CONTACT.frame + Math.floor(f / 5)); anim = 15; }
        }
        if (sprite === undefined) return;
        // Keep the normal player renderer, uniform shader and body variants.
        // No generated artwork, limb overlays, sprite edits or new sprites.
        p.sprite_index = r.gml_Script_s_spr_from_bt(p, p, r.YYASSET_REF(0x01000000 | sprite), p.gmlbody_type);
        p.image_index = Math.min(frame, r.sprite_get_number(p.sprite_index) - 1);
        p.image_speed = 0; p.image_xscale = s.dir * 2; p.gmlanim = anim;
        p.depth = -p.y * 10;
        r.gml_Script_s_update_my_shadow(p, p);
    }
    function playerStep(p) {
        var m = match(); if (!active(m)) return false;
        var s = m._punt;
        animatePlayer(p, s);
        if (p.id === s.punter && s.phase === "flight" && s.frame >= 16 && p.gmlanim === 15) r.gml_Script_s_set_anim(p, p, 0);
        p.gmlmy_route_alpha = 0;
        if (["flight", "ground", "return"].indexOf(s.phase) < 0 || (p.id === s.punter && s.phase === "flight" && s.frame < 16)) {
            p.gmljforce = 0; p.hspeed = 0; p.vspeed = 0; return true;
        }
        var b = ball(), shadow = objects(112)[0];
        p.gmlballdist = Math.hypot(p.x - b.x, p.y - b.y);
        p.gmlbouncedist = Math.hypot(p.x - shadow.gmlbounce_x, p.y - shadow.gmlbounce_y);
        p.gmlnearest_opp = r.gml_Script_s_get_nearest_opponent(p, p, p.id);
        var opponent = objects(p.gmlnearest_opp)[0];
        p.gmlnearest_opp_dist = opponent ? Math.hypot(p.x - opponent.x, p.y - opponent.y) : 1000;
        if (s.phase === "ground") {
            p.gmljdir = r.point_direction(p.x, p.y, b.x, b.y); p.gmljforce = clamp(p.gmlballdist / 24, 0, 1);
        } else if (s.phase === "flight") r.gml_Script_s_aim_AI_kickoff(p, p);
        else if (p.id === s.returner && s.humanReturn) {
            p.gmljdir = Math.atan2(-s.input.y, s.input.x) * 180 / Math.PI;
            p.gmljforce = Math.hypot(s.input.x, s.input.y);
        } else r.gml_Script_s_received_AI_kickoff(p, p);
        // Return blockers engage nearby coverage using the native tackle/block AI.
        if (p.gmloffense && p.id !== s.returner && s.phase === "return") r.gml_Script_s_check_tackling(p, p);
        return true;
    }
    function playerEnd(p) {
        var m = match();
        return active(m) && (["flight", "ground", "return"].indexOf(m._punt.phase) < 0 || (p.id === m._punt.punter && m._punt.phase === "flight" && m._punt.frame < 16));
    }
    function ownsBall() { return active(match()); }
    function shadowStep(shadow) {
        var m = match(); if (!active(m)) return false;
        var s = m._punt;
        shadow.gmldraw_arc = false; shadow.gmldraw_bounce = false;
        shadow.x = ball().x; shadow.y = ball().y;
        var target = s.phase === "flight" ? landing(ball()) : s.phase === "ground" || s.phase === "return" ? ball() : { x: s.scrim, y: 300 };
        shadow.gmlbounce_x = target.x; shadow.gmlbounce_y = target.y;
        return true;
    }
    function drawBall(b) {
        if (!ownsBall()) return false;
        var m = match(), holder = objects(b.gmlholder)[0];
        if (m._punt.phase === "return" && holder && r.gml_Script_s_sprite_holding_ball(holder, holder, holder.sprite_index)) return true;
        r.draw_sprite_ext(b, b.sprite_index, b.image_index, b.x, b.y - b.gmlheight, 2, 2, b.gmlrotation, 16777215, 1);
        return true;
    }
    function draw(m) {
        if (!active(m)) return;
        var s = m._punt, color = r.draw_get_color(), font = r.draw_get_font(), ha = r.draw_get_halign(), va = r.draw_get_valign(), alpha = r.draw_get_alpha();
        r.draw_set_alpha(1); r.draw_set_font(r.global.gmlfnt_small_flex); r.draw_set_halign(1); r.draw_set_valign(1);
        var w = r.display_get_gui_width(), h = r.display_get_gui_height(), text;
        text = s.phase === "aim" ? (s.humanKick ? "PUNT | TIME THE AIMING ARROW" : "OPPONENT PUNT") : s.phase === "power" ? "PUNT POWER" : s.phase === "flight" ? (s.fair ? "FAIR CATCH CALLED" : "PUNT") : s.phase === "ground" ? "LOOSE PUNT | BALL IS LIVE" : s.phase === "return" ? "PUNT RETURN | WASD / ARROWS OR DRAG" : s.phase === "dead" ? s.reason.toUpperCase() : "PUNT | " + s.phase.toUpperCase();
        r.draw_set_color(65535); r.gml_Script_draw_hd_text(m, m, w / 2, 42, text);
        if (s.phase === "aim" || s.phase === "power") {
            if (s.phase === "power") {
                r.draw_set_color(0); r.draw_rectangle(w / 2 - 70, h - 56, w / 2 + 70, h - 42, false);
                r.draw_set_color(65280); r.draw_rectangle(w / 2 - 68, h - 54, w / 2 - 68 + 136 * s.meter, h - 44, false);
            }
            r.draw_set_color(16777215); r.gml_Script_draw_hd_text(m, m, w / 2, h - 66, "AIM " + Math.round(s.aim) + " DEGREES");
        }
        if ((s.humanKick && ["aim", "power"].indexOf(s.phase) >= 0) || (s.humanReturn && ["flight", "return"].indexOf(s.phase) >= 0)) {
            var label = s.phase === "aim" ? "SPACE / TAP: SET AIM" : s.phase === "power" ? "SPACE / TAP: SNAP & PUNT" : s.phase === "flight" ? "F / TAP: FAIR CATCH" : "SPACE / TAP: DIVE";
            r.draw_set_color(0); r.draw_rectangle(w / 2 - 118, h - 30, w / 2 + 118, h - 4, false);
            r.draw_set_color(65535); r.gml_Script_draw_hd_text(m, m, w / 2, h - 17, label);
        }
        r.draw_set_color(color); r.draw_set_font(font); r.draw_set_halign(ha); r.draw_set_valign(va); r.draw_set_alpha(alpha);
    }
    function drawField(m) {
        if (!active(m)) return;
        var s = m._punt, color = r.draw_get_color(), alpha = r.draw_get_alpha();
        r.draw_set_color(16711680); r.draw_line(m.gmlx_scrim, 132, m.gmlx_scrim, 468);
        if (s.phase === "aim" || s.phase === "power") {
            var p = objects(s.punter)[0], a = s.aim * Math.PI / 180;
            var length = 180 + 5 * p.gmlmy_kick_skill;
            var coneLength = Math.max(220, length), halfWidth = Math.tan(25 * Math.PI / 180) * coneLength;
            r.draw_set_color(16777215); r.draw_set_alpha(0.075);
            r.draw_triangle(p.x + s.dir * coneLength, p.y - halfWidth, p.x + s.dir * coneLength, p.y + halfWidth, p.x, p.y, false);
            var tx = p.x + s.dir * Math.cos(a) * length, ty = p.y + Math.sin(a) * length;
            var rotation = -Math.atan2(Math.sin(a), s.dir * Math.cos(a)) * 180 / Math.PI;
            r.draw_set_alpha(0.75); r.draw_line_width(p.x, p.y, tx, ty, 3);
            // Same spr_route_end arrowhead, scale, opacity and rotation as field goals.
            r.draw_sprite_ext(p, r.YYASSET_REF(0x0100004d), 0, tx + (s.dir < 0 ? 1 : 0), ty + (s.dir < 0 ? 1.5 : 0), 0.75, 0.75, rotation, 16777215, 0.75);
        }
        r.draw_set_color(color); r.draw_set_alpha(alpha);
    }
    return { start: start, offer: offer, eligible: eligible, active: active, reset: reset, step: step, confirm: confirm, fairCatch: fairCatch,
        end: end, resolve: resolve, updateBall: updateBall, playerStep: playerStep, playerEnd: playerEnd, ownsBall: ownsBall, shadowStep: shadowStep, drawBall: drawBall, draw: draw, drawField: drawField,
        logic: { direction: direction, formation: formation, trajectory: trajectory, landing: landing, CONTACT: CONTACT } };
});
