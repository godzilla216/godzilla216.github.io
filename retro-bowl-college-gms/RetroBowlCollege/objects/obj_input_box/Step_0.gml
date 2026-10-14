if (!active) {
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
hover = false;
custom_keyboard = s_keyboard_custom_enabled();
if (editing) {
	if (string_length(g_pBuiltIn.keyboard_string) > max_length) {
		g_pBuiltIn.keyboard_string = string_copy(g_pBuiltIn.keyboard_string, 1, max_length);
	}
	if (!custom_keyboard) {
		if (s_is_touch_allowed() && mouse_check_button_released(1)) {
			editing = false;
		}
	} else if (s_is_touch_allowed() && mouse_check_button_released(1) && !point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 10, 120, 470, 260)) {
		editing = false;
	}
	switch (os_type) {
		case 0:
		case 1:
			if (keyboard_check_released(13)) {
				editing = false;
			}
			break;
		case 21:
			break;
		case 3:
		case 4:
			if (g_pBuiltIn.keyboard_string != "" || os_is_paused()) {
				slog("keyboard_virtual_status=" + string(keyboard_virtual_status()));
				slog("keyboard_lastkey=" + string(g_pBuiltIn.keyboard_lastkey));
				slog("keyboard_lastchar=" + string(g_pBuiltIn.keyboard_lastchar));
				if (g_pBuiltIn.keyboard_lastchar == "\n" || g_pBuiltIn.keyboard_lastchar == "\n" || g_pBuiltIn.keyboard_lastchar == "\r" || g_pBuiltIn.keyboard_lastkey == 10 || keyboard_virtual_status() == false) {
					editing = false;
				}
			}
			break;
	}
	if (!editing) {
		keyboard_clear(13);
		if (global.mobile_device) {
			keyboard_virtual_hide();
		}
		if (custom_keyboard) {
			s_keyboard_custom_hide();
		}
		if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
			audio_play_sound(snd_click, 1, false);
		}
		text = g_pBuiltIn.keyboard_string;
		text = string_replace_all(text, " ", "1X1");
		text = string_replace_all(text, ".", "2X2");
		text = string_replace_all(text, "'", "3X3");
		text = string_lettersdigits(text);
		text = string_replace_all(text, "1X1", " ");
		text = string_replace_all(text, "2X2", ".");
		text = string_replace_all(text, "3X3", "'");
		g_pBuiltIn.keyboard_string = "";
		g_pBuiltIn.keyboard_lastkey = -1;
		if (script_exists(validate_script)) {
			script_execute(self, other, validate_script);
		}
	}
} else {
	with (obj_input_box) {
		if (editing) {
			exit;
		}
	}
	if (global.gamepad) {
		if (global.gp.ui_selected == id && gamepad_button_check_released(global.gp.slot, global.gp_select)) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
			}
			editing = true;
			slog("Input box editing (Pad)");
			if (global.mobile_device) {
				keyboard_virtual_show(0, 4, 1, false);
			}
			if (custom_keyboard) {
				s_keyboard_custom_show(id);
			}
			g_pBuiltIn.keyboard_string = "";
			g_pBuiltIn.keyboard_lastkey = -1;
		}
	} else {
		if (s_is_touch_allowed() && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
			hover = true;
		}
		if (hover) {
			if (mouse_check_button(1)) {
				image_index = 1;
				clicked = true;
			}
			if (clicked && mouse_check_button_released(1)) {
				if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
					audio_play_sound(snd_click, 1, false);
				}
				clicked = false;
				editing = true;
				slog("Input box editing (Touch)");
				if (global.mobile_device) {
					keyboard_virtual_show(0, 4, 1, false);
				}
				if (custom_keyboard) {
					s_keyboard_custom_show(id);
				}
				g_pBuiltIn.keyboard_string = "";
				g_pBuiltIn.keyboard_lastkey = -1;
			}
		} else {
			clicked = false;
		}
	}
}
