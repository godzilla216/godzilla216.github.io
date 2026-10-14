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
	if (editing && !custom_keyboard) {
		exit;
	}
}
hover = false;
image_index = 0;
if (global.gamepad) {
	clicked = false;
	if (global.gp.ui_selected == id && gamepad_button_check(global.gp.slot, global.gp_select) || gamepad_button_check(global.gp.slot, gp_mapped_button) || gamepad_button_check(global.gp.slot, gp_mapped_hidden)) {
		image_index = 1;
		clicked = true;
		global.gp.ui_selected = id;
	}
	if (global.gp.ui_selected == id && (gamepad_button_check_released(global.gp.slot, global.gp_select) || gamepad_button_check_released(global.gp.slot, gp_mapped_button) || gamepad_button_check_released(global.gp.slot, gp_mapped_hidden))) {
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		s_save_last_selected();
		if (goto_room) {
			room_goto(goto_room);
		} else if (onClickAction) {
			script_execute(self, other, onClickAction);
		}
	}
} else {
	if (!s_is_touch_allowed()) {
		exit;
	}
	if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
		hover = true;
	}
	if (mouse_check_button_pressed(1) && hover) {
		image_index = 1;
		clicked = true;
	}
	if (mouse_check_button(1) && clicked && hover) {
		image_index = 1;
	} else {
		image_index = 0;
	}
	if (mouse_check_button_released(1) && clicked) {
		clicked = false;
		if (hover) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
			}
			if (goto_room) {
				room_goto(goto_room);
			} else if (onClickAction) {
				script_execute(self, other, onClickAction);
			}
		}
	}
}
