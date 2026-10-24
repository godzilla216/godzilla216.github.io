function s_update_gamepad() {
	if (global.browser) {
		global.gamepad = false;
		return;
	}
	var pad = s_gamepad_activity();
	if (pad >= 0 && (pad != global.gp.slot || !global.gamepad)) {
		if (pad == global.gp_1.slot) {
			global.gp = global.gp_1;
		} else if (pad == global.gp_2.slot) {
			global.gp = global.gp_2;
		} else if (!s_is_multicon()) {
			global.gp = global.gp_1;
			global.gp.slot = pad;
		}
		global.gamepad = true;
		slogf("active gp slot is %1 (1:%2 2:%3) detected: %4 turn: %5", global.gp.slot, global.gp_1.slot, global.gp_2.slot, pad, global.gp_mp.turn);
	}
	if (s_is_multicon()) {
		if (!s_is_turn(global.gp)) {
			switch (global.gp_mp.turn) {
				case 1:
					global.gp = global.gp_1;
					break;
				case 2:
					global.gp = global.gp_2;
					break;
				default:
					break;
			}
		}
	}
	if ((mouse_check_button(1) || mouse_check_button(2)) && s_is_touch_allowed()) {
		global.gamepad = false;
	}
	if (global.gamepad) {
		s_update_gamepad_data(global.gp_1);
		s_update_gamepad_data(global.gp_2);
		s_update_ui_selected(global.gp_1);
		s_update_ui_selected(global.gp_2);
	} else {
		global.gp.ui_selected = -4;
	}
}

function s_gamepad_async() {
	switch (ds_map_find_value(async_load, "event_type")) {
		case "gamepad discovered":
			var pad = ds_map_find_value(async_load, "pad_index");
			s_refresh_gamepads();
			slog(gamepad_get_description(pad) + " connected (" + string(pad) + ")");
			slog(gamepad_get_mapping(pad));
			break;
		case "gamepad lost":
			var pad = ds_map_find_value(async_load, "pad_index");
			var slots = s_refresh_gamepads();
			if (s_is_multicon() && slots < 2) {
				s_multicon_save_turn();
				s_multicon_reset();
				s_exhibition_lost_two_controllers();
			}
			slog("pad " + string(pad) + " disconnected");
			break;
	}
}

function s_gamepad_activity() {
	var _slot;
	for (var i = 0; i < gamepad_get_device_count(); i++) {
		if (gamepad_is_connected(i)) {
			_slot = i;
			if (gamepad_axis_value(_slot, 32785) + gamepad_axis_value(_slot, 32786) > 0.2) {
				return _slot;
			} else if (gamepad_axis_value(_slot, 32787) + gamepad_axis_value(_slot, 32788) > 0.2) {
				return _slot;
			} else if (gamepad_button_check(_slot, global.gp_select) || gamepad_button_check(_slot, global.gp_back) || gamepad_button_check(_slot, 32771) || gamepad_button_check(_slot, 32772)) {
				return _slot;
			} else if (gamepad_button_check(_slot, 32783) || gamepad_button_check(_slot, 32784) || gamepad_button_check(_slot, 32781) || gamepad_button_check(_slot, 32782)) {
				return _slot;
			} else if (gamepad_button_check(_slot, 32773) || gamepad_button_check(_slot, 32775)) {
				return _slot;
			} else if (gamepad_button_check(_slot, 32774) || gamepad_button_check(_slot, 32776)) {
				return _slot;
			} else if (gamepad_button_check(_slot, 32777) || gamepad_button_check(_slot, 32778)) {
				return _slot;
			}
		}
	}
	return -1;
}

function s_clear_last_selected_history() {
}

function s_overwrite_last_selected() {
	s_get_last_selected(room);
	s_save_last_selected();
}

function s_save_last_selected() {
	if (object_index == obj_kb_key) {
		return;
	}
	var ls = { rm: room, ls: id };
	ds_list_add(global.lsh, ls);
}

function s_get_last_selected(_arg0) {
	var ls, lsid;
	for (var i = 0; i < ds_list_size(global.lsh); i++) {
		ls = ds_list_find_value(global.lsh, i);
		if (ls.rm == _arg0) {
			lsid = ls.ls;
			ds_list_delete(global.lsh, i);
			return lsid;
		}
	}
	return -1;
}

function s_reset_gamepad(_arg0) {
	slogf("Resetting gamepad %1 data", _arg0);
	return {
		id: _arg0,
		slot: -1,
		axisr_h: 0,
		axisr_v: 0,
		axisr_force: 0,
		axisr_flick: 0,
		axisl_h: 0,
		axisl_v: 0,
		axisl_force: 0,
		axisl_flick: 0,
		axisl_v_dir: 1,
		trigger: 0,
		triggerl: 0,
		triggerr: 0,
		gamepad_anybutton: 0,
		ui_selected: -4
	};
}

function s_update_gamepad_data(_arg0) {
	with (_arg0) {
		if (slot < 0) {
			return;
		}
		axisr_h = gamepad_axis_value(slot, 32787);
		axisr_v = gamepad_axis_value(slot, 32788);
		axisr_force = max(abs(axisr_h), abs(axisr_v));
		if (axisr_force < 0.2) {
			axisr_flick = false;
		}
		axisl_h = gamepad_axis_value(slot, 32785);
		axisl_v = gamepad_axis_value(slot, 32786) * axisl_v_dir;
		if (gamepad_button_check(slot, 32783)) {
			axisl_h = -1;
		}
		if (gamepad_button_check(slot, 32784)) {
			axisl_h = 1;
		}
		if (gamepad_button_check(slot, 32781)) {
			axisl_v = -1;
		}
		if (gamepad_button_check(slot, 32782)) {
			axisl_v = 1;
		}
		axisl_force = max(abs(axisl_h), abs(axisl_v));
		if (axisl_force < 0.2) {
			axisl_flick = false;
		}
		triggerl = 0;
		triggerr = 0;
		if (gamepad_button_check(slot, 32773) || gamepad_button_check(slot, 32775)) {
			triggerl = 1;
		}
		if (gamepad_button_check(slot, 32774) || gamepad_button_check(slot, 32776)) {
			triggerr = 1;
		}
		trigger = triggerl || triggerr;
		gamepad_anybutton = trigger || gamepad_button_check_released(slot, global.gp_select) || gamepad_button_check_released(slot, global.gp_back) || gamepad_button_check_released(slot, 32771) || gamepad_button_check_released(slot, 32772) || gamepad_button_check_released(slot, 32778);
	}
}

function s_update_ui_selected(_arg0) {
	with (_arg0) {
		if (slot < 0 || s_is_multicon() && !s_is_turn(_arg0)) {
			ui_selected = -4;
			return;
		}
		if (!instance_exists(ui_selected)) {
			ui_selected = -4;
		}
		with (ui_selected) {
			if (!visible) {
				_arg0.ui_selected = -4;
			} else if (layer && !layer_get_visible(layer)) {
				_arg0.ui_selected = -4;
			} else if (variable_instance_exists(id, "active") && !active) {
				_arg0.ui_selected = -4;
			}
		}
		with (ui_selected) {
			with (obj_msgbg) {
				if (depth < other.depth) {
					_arg0.ui_selected = -4;
				}
			}
		}
		if (ui_selected == -4) {
			s_find_default_button(false, _arg0);
		}
		if (axisl_flick == false && axisl_force > 0.9) {
			if (!gamepad_button_check(slot, global.gp_select) && !gamepad_button_check(slot, global.gp_back) && !gamepad_button_check(slot, 32771) && !gamepad_button_check(slot, 32772)) {
				axisl_flick = true;
				var closest_obj = -4;
				var closest_dist = -1;
				var kb_alt_obj = -4;
				var kb_alt_dist = -1;
				with (ui_selected) {
					with (ui_selectable) {
						if (!visible) {
							continue;
						}
						if (layer && !layer_get_visible(layer)) {
							continue;
						}
						if (variable_instance_exists(id, "active") && !active) {
							continue;
						}
						if (id == _arg0.ui_selected) {
							continue;
						}
						if (instance_exists(obj_msgbg) && depth > obj_msgbg.depth) {
							continue;
						}
						if (variable_instance_exists(id, "gp_mapped_button") && gp_mapped_button != -1) {
							continue;
						}
						if (global.custkb.active && !gp_active_editing) {
							continue;
						}
						if (_arg0.id & gp_allowed == 0) {
							continue;
						}
						var sx = 0;
						var sy = 0;
						if (_arg0.axisl_h < -0.5) {
							sx = -1;
						}
						if (_arg0.axisl_h > 0.5) {
							sx = 1;
						}
						if (_arg0.axisl_v < -0.5) {
							sy = -1;
						}
						if (_arg0.axisl_v > 0.5) {
							sy = 1;
						}
						var xdist = abs(x + sprite_width * 0.5 - (other.x + other.sprite_width * 0.5));
						var ydist = abs(y + sprite_height * 0.5 - (other.y + other.sprite_height * 0.5));
						if (sx < 0 && x < other.x || sx > 0 && x > other.x) {
							if (!(global.custkb.active && ydist != 0)) {
								var dist = xdist + ydist * 5;
								if (closest_dist == -1 || dist < closest_dist) {
									closest_dist = dist;
									closest_obj = id;
								}
							}
						} else if (sy < 0 && y < other.y || sy > 0 && y > other.y) {
							xdist /= sprite_width / other.sprite_width;
							var dist = xdist + ydist;
							if (closest_dist == -1 || dist < closest_dist) {
								closest_dist = dist;
								closest_obj = id;
							}
						}
						if (global.custkb.active) {
							if (sx != 0) {
								var dist = abs(x + sprite_width * 0.5 - (other.x + other.sprite_width * 0.5 - sx * global.custkb.base.sprite_width - 16)) + ydist * 5;
								if (kb_alt_dist == -1 || dist < kb_alt_dist) {
									kb_alt_dist = dist;
									kb_alt_obj = id;
								}
							} else if (sy != 0) {
								var dist = abs(y + sprite_height * 0.5 - (other.y + other.sprite_height * 0.5 - sy * global.custkb.base.sprite_height - 16)) + xdist / (sprite_width / other.sprite_width);
								if (kb_alt_dist == -1 || dist < kb_alt_dist) {
									kb_alt_dist = dist;
									kb_alt_obj = id;
								}
							}
						}
					}
				}
				if (closest_obj) {
					_arg0.ui_selected = closest_obj;
				}
				if (closest_obj == -4 && kb_alt_obj != -4) {
					_arg0.ui_selected = kb_alt_obj;
				}
				if (_arg0.ui_selected >= 0) {
					slogf("ui %4 allowed:%1 gpid:%2 : %3", _arg0.ui_selected.gp_allowed, _arg0.id, _arg0.ui_selected.gp_allowed & _arg0.id, id);
				}
			}
		}
	}
}

function s_multiplayer_init() {
	global.gp_1 = s_reset_gamepad(1);
	global.gp_2 = s_reset_gamepad(2);
	global.gp = global.gp_1;
	global.gp_mp = { try_multi: false, single: true, turn: 0, touch: true };
}

function s_is_multicon_wanted() {
	return global.gp_mp.try_multi;
}

function s_toggle_multicon_wanted() {
	with (global.gp_mp) {
		try_multi = !try_multi;
	}
}

function s_multicon_reset() {
	if (!s_is_multicon()) {
		return;
	}
	s_set_multicon_active(false);
	s_set_multicon_turn();
	s_set_multicon_touch(true);
	switch (os_type) {
		case 21:
			switch_controller_support_set_defaults();
			break;
		default:
			break;
	}
}

function s_multicon_init() {
	switch (os_type) {
		case 21:
			switch_controller_joycon_set_holdtype(1);
			switch_controller_set_supported_styles(30);
			switch_controller_support_set_singleplayer_only(false);
			switch_controller_support_set_player_min(2);
			switch_controller_support_set_player_max(2);
			var result = switch_controller_support_show();
			slogf("NX: Controller support result %1", result);
			var players = switch_controller_support_get_player_count();
			slogf("NX: Player count %1", players);
			if (players < 2) {
				s_multicon_reset();
			} else {
				s_set_multicon_active(true);
				s_set_multicon_turn();
				s_refresh_gamepads();
			}
			break;
		case 1:
			if (!s_is_debug_desktop()) {
				break;
			}
			s_set_multicon_active(true);
			s_set_multicon_turn();
			var slots = s_refresh_gamepads();
			if (slots >= 2) {
				s_set_multicon_turn();
			} else {
				s_multicon_reset();
			}
			break;
		default:
			slogf("DBG: Testing multi controller support");
			break;
	}
}

function s_refresh_gamepads() {
	if (global.browser) {
		return;
	}
	var slot = 0;
	global.gp_1.slot = -1;
	global.gp_2.slot = -1;
	for (var i = 0; i < gamepad_get_device_count(); i++) {
		if (s_gamepad_is_fingerprint_sensor(i)) {
			continue;
		}
		if (gamepad_is_connected(i)) {
			slogf("gp slot %1 is %2", slot + 1, i);
			switch (slot) {
				case 0:
					global.gp_1.slot = i;
					global.gp_1.axisl_v_dir = s_gamepad_lv_dir(i);
					break;
				case 1:
					global.gp_2.slot = i;
					global.gp_2.axisl_v_dir = s_gamepad_lv_dir(i);
					break;
			}
			slot++;
		}
	}
	if (slot > 0) {
		global.gamepad = true;
		global.gp = global.gp_1;
	}
	slogf("gp_1:%1 gp_2:%2 gp:%3", global.gp_1.slot, global.gp_2.slot, global.gp.slot);
	return slot;
}

function s_gamepad_lv_dir(_arg0) {
	if (!s_is_debug_desktop()) {
		return 1;
	}
	if (gamepad_get_description(_arg0) == "SteelSeries Nimbus") {
		return -1;
	}
	return 1;
}

function s_set_multicon_active(_arg0) {
	global.gp_mp.single = !_arg0;
}

function s_set_multicon_turn(_arg0) {
	if (!s_is_multicon()) {
		return;
	}
	if (is_undefined(_arg0)) {
		_arg0 = 0;
	}
	global.gp_mp.turn = _arg0;
	slogf("Setting turn: %1", _arg0);
}

function s_multicon_save_turn() {
	global.gp_mp.turn_save = global.gp_mp.turn;
}

function s_multicon_restore_turn() {
	global.gp_mp.turn = global.gp_mp.turn_save;
}

function s_is_turn(_arg0) {
	with (global.gp_mp) {
		if (turn == 0 || _arg0.id == turn || s_is_paused_or_just_unpaused()) {
			return true;
		}
		return false;
	}
}

function s_is_multicon() {
	return global.gamepad && !global.gp_mp.single;
}

function s_get_multicon_current_pad() {
	switch (global.gp_mp.turn) {
		case 1:
			return global.gp_2;
		default:
			return global.gp_1;
	}
}

function s_set_multicon_touch(_arg0) {
	with (global.gp_mp) {
		touch = _arg0;
	}
}

function s_is_touch_allowed() {
	if (!global.gamepad) {
		return true;
	}
	with (global.gp_mp) {
		return touch && single;
	}
}

function s_is_ui_selected() {
	if (global.gamepad) {
		if (s_is_multicon()) {
			if (global.gp_1.ui_selected == id) {
				return true;
			}
			if (global.gp_2.ui_selected == id) {
				return true;
			}
		} else if (global.gp.ui_selected == id) {
			return true;
		}
	}
	return false;
}

function s_ui_selected_color() {
	if (global.gamepad) {
		if (s_is_multicon()) {
			if (global.gp_1.ui_selected == id && global.gp_2.ui_selected == id) {
				return 65535;
			}
			if (global.gp_1.ui_selected == id) {
				return 255;
			}
			if (global.gp_2.ui_selected == id) {
				return 65280;
			}
		} else if (global.gp.ui_selected == id) {
			return 255;
		}
	}
	return 16777215;
}

