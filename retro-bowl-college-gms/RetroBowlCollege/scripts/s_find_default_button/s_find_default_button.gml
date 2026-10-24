function s_find_default_button(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = global.gp_1;
	}
	if (!global.gamepad) {
		return;
	}
	if (_arg0) {
		_arg1.ui_selected = -4;
	}
	if (room != rm_details && (obj_master.intro || room == rm_master)) {
		with (obj_button) {
			if (!visible) {
				continue;
			}
			if (layer && !layer_get_visible(layer)) {
				continue;
			}
			if (variable_instance_exists(id, "active") && !active) {
				continue;
			}
			if (instance_exists(obj_msgbg) && depth > obj_msgbg.depth) {
				continue;
			}
			if (variable_instance_exists(id, "gp_mapped_button") && gp_mapped_button != -1) {
				continue;
			}
			if (_arg1.id & gp_allowed == 0) {
				continue;
			}
			var sname = script_get_name(onClickAction);
			if (flash) {
				_arg1.ui_selected = id;
				return;
			} else {
				switch (ds_map_find_value(obj_master.map_options, "saveslot")) {
					default:
						if (string_count("_LoadSlot1", sname)) {
							_arg1.ui_selected = id;
							return;
						}
						break;
					case 2:
						if (string_count("_LoadSlot2", sname)) {
							_arg1.ui_selected = id;
							return;
						}
						break;
					case 3:
						if (string_count("_LoadSlot3", sname)) {
							_arg1.ui_selected = id;
							return;
						}
						break;
					case 4:
						if (string_count("_LoadSlot4", sname)) {
							_arg1.ui_selected = id;
							return;
						}
						break;
					case 5:
						if (string_count("_LoadSlot5", sname)) {
							_arg1.ui_selected = id;
							return;
						}
						break;
				}
			}
		}
	}
	switch (room) {
		case rm_halloffame:
		case rm_halloffame_player_records:
		case rm_halloffame_players:
		case rm_halloffame_retrobowls:
			with (obj_button) {
				if (colour == global.c_primary) {
					_arg1.ui_selected = id;
					return;
				}
			}
			break;
	}
	var lsi = s_get_last_selected(room);
	if (lsi != -1) {
		slog("last selected: " + string(lsi));
		with (obj_button) {
			if (!visible) {
				continue;
			}
			if (layer && !layer_get_visible(layer)) {
				continue;
			}
			if (variable_instance_exists(id, "active") && !active) {
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
			if (_arg1.id & gp_allowed == 0) {
				continue;
			}
			if (lsi == id) {
				_arg1.ui_selected = id;
				return;
			}
		}
		with (obj_input_box) {
			if (!visible) {
				continue;
			}
			if (layer && !layer_get_visible(layer)) {
				continue;
			}
			if (_arg1.id & gp_allowed == 0) {
				continue;
			}
			if (lsi == id) {
				_arg1.ui_selected = id;
				return;
			}
		}
		with (obj_button_med) {
			if (!visible) {
				continue;
			}
			if (layer && !layer_get_visible(layer)) {
				continue;
			}
			if (_arg1.id & gp_allowed == 0) {
				continue;
			}
			if (lsi == id) {
				_arg1.ui_selected = id;
				return;
			}
		}
	}
	with (obj_button_9s) {
		if (!visible) {
			continue;
		}
		if (layer && !layer_get_visible(layer)) {
			continue;
		}
		if (variable_instance_exists(id, "active") && !active) {
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
		if (_arg1.id & gp_allowed == 0) {
			continue;
		}
		if (!global.custkb.active) {
			continue;
		}
		if (global.custkb.default_key == id || image == spr_arrowR) {
			_arg1.ui_selected = id;
			return;
		}
	}
	with (obj_button) {
		if (!visible) {
			continue;
		}
		if (layer && !layer_get_visible(layer)) {
			continue;
		}
		if (variable_instance_exists(id, "active") && !active) {
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
		if (_arg1.id & gp_allowed == 0) {
			continue;
		}
		var sname = script_get_name(onClickAction);
		if (string_count("_Continue", sname) || string_count("_Back", sname) || string_count("s_do_postmatch_dilemma", sname) || onClickAction == btn_response_1pt) {
			_arg1.ui_selected = id;
			return;
		}
	}
	with (obj_button) {
		if (!visible) {
			continue;
		}
		if (layer && !layer_get_visible(layer)) {
			continue;
		}
		if (variable_instance_exists(id, "active") && !active) {
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
		if (_arg1.id & gp_allowed == 0) {
			continue;
		}
		var sname = script_get_name(onClickAction);
		if (string_count("Home", sname) || string_count("Back", sname) || string_count("Done", sname) || string_count("btn_click_HallOfFame", sname) || string_count("s_msg_clear", sname) || string_count("_no", sname) || string_count("_ChooseAFC", sname)) {
			_arg1.ui_selected = id;
			return;
		}
	}
	with (obj_button) {
		if (!visible) {
			continue;
		}
		if (layer && !layer_get_visible(layer)) {
			continue;
		}
		if (variable_instance_exists(id, "active") && !active) {
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
		if (_arg1.id & gp_allowed == 0) {
			continue;
		}
		_arg1.ui_selected = id;
		return;
	}
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
		if (instance_exists(obj_msgbg) && depth > obj_msgbg.depth) {
			continue;
		}
		if (variable_instance_exists(id, "gp_mapped_button") && gp_mapped_button != -1) {
			continue;
		}
		if (!variable_instance_exists(id, "onClickAction")) {
			continue;
		}
		if (global.custkb.active && !gp_active_editing) {
			continue;
		}
		if (_arg1.id & gp_allowed == 0) {
			continue;
		}
		_arg1.ui_selected = id;
		return;
	}
}

