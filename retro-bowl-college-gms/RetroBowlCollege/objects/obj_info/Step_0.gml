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
clicked = false;
if (global.gamepad) {
	if (global.gp.ui_selected == id && gamepad_button_check_released(global.gp.slot, global.gp_select)) {
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		s_do_info(info_msg);
	}
} else if (s_is_touch_allowed() && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
	if (mouse_check_button_released(1)) {
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		s_do_info(info_msg);
	}
}
