if (!visible) {
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
	if (editing) {
		exit;
	}
}
if (!s_is_touch_allowed()) {
	exit;
}
hover = false;
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
		clicked = false;
		if (global.browser) {
			if (google) {
				url_open_ext(global.url_google, "_blank");
			} else {
				url_open_ext(global.url_apple, "_blank");
			}
		} else if (google) {
			url_open_ext(global.url_discord, "_blank");
		} else {
			url_open_ext(global.url_twitter, "_blank");
		}
	}
} else {
	clicked = false;
}
