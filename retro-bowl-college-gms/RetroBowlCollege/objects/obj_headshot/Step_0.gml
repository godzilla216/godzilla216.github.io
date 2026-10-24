if (!active || !visible) {
	exit;
}
if (layer && !layer_get_visible(layer)) {
	exit;
}
with (obj_msgbg) {
	if (depth < other.depth) {
		exit;
	}
}
with (obj_input_box) {
	if (editing && !custom_keyboard) {
		exit;
	}
}
hover = false;
if (global.gamepad) {
	clicked = false;
	if (global.gp.ui_selected == id && gamepad_button_check(global.gp.slot, global.gp_select) || gamepad_button_check(global.gp.slot, gp_mapped_button) || gamepad_button_check(global.gp.slot, gp_mapped_hidden)) {
		clicked = true;
		global.gp.ui_selected = id;
	}
	if (global.gp.ui_selected == id && (gamepad_button_check_released(global.gp.slot, global.gp_select) || gamepad_button_check_released(global.gp.slot, gp_mapped_button) || gamepad_button_check_released(global.gp.slot, gp_mapped_hidden))) {
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		s_save_last_selected();
		script_execute(onClickAction);
	}
} else if (s_is_touch_allowed()) {
	if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
		hover = true;
	}
	if (hover) {
		if (mouse_check_button(1)) {
			clicked = true;
		}
		if (clicked && mouse_check_button_released(1)) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
			}
			script_execute(onClickAction);
			clicked = false;
		}
	} else {
		clicked = false;
	}
}
