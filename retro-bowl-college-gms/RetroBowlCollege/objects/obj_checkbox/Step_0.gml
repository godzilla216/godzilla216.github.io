if (!visible) {
	exit;
}
if (layer && !layer_get_visible(layer)) {
	exit;
}
if (!active) {
	exit;
}
with (obj_msgbg) {
	if (depth < other.depth) {
		exit;
	}
}
with (obj_input_box) {
	if (editing) {
		exit;
	}
}
clicked = false;
if (global.gamepad) {
	if (global.gp.ui_selected == id && gamepad_button_check_released(global.gp.slot, global.gp_select)) {
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		state = !state;
		if (onClickAction) {
			script_execute(onClickAction);
		}
		if (state && click_info != "") {
			s_create_message("", s_str(click_info), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		}
	}
} else {
	if (!s_is_touch_allowed()) {
		exit;
	}
	if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
		if (mouse_check_button_released(1)) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
			}
			state = !state;
			if (onClickAction) {
				script_execute(onClickAction);
			}
			if (state && click_info != "") {
				s_create_message("", s_str(click_info), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			}
		}
	}
}
