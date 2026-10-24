with (obj_msgbg) {
	if (depth < other.depth) {
		exit;
	}
}
if (!pmap) {
	exit;
}
if (old_condition < 0) {
	old_condition = real(ds_map_find_value(pmap, "condition"));
}
old_condition = lerp(old_condition, real(ds_map_find_value(pmap, "condition")), 0.05);
if (!active) {
	exit;
}
hover = false;
if (global.gamepad) {
	if (global.gp.ui_selected == id && gamepad_button_check_released(global.gp.slot, global.gp_select)) {
		s_save_last_selected();
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		script_execute(onClickAction);
	}
	if (os_type != 21) {
		if (global.gp.ui_selected == id && gamepad_button_check_released(global.gp.slot, 32772)) {
			if (onHoldAction && pmap) {
				if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
					audio_play_sound(snd_click, 1, false);
				}
				obj_master.player_profile = pmap;
				script_execute(onHoldAction);
			}
		}
	}
} else {
	if (s_is_touch_allowed() && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
		hover = true;
	}
	if (hover) {
		if (mouse_check_button(1)) {
			if (!clicked) {
				clicked = current_time;
			} else if (onHoldAction && pmap && current_time - clicked > 3000 && os_type != 21) {
				clicked = 0;
				obj_master.player_profile = pmap;
				script_execute(onHoldAction);
			}
		}
		if (clicked && mouse_check_button_released(1)) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
			}
			script_execute(onClickAction);
			clicked = 0;
		}
	} else {
		clicked = 0;
	}
}
