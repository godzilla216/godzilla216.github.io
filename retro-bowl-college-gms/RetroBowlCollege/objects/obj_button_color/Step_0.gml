event_inherited();
exit;
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
image_index = 0;
hover = false;
if (!s_is_touch_allowed()) {
	exit;
}
if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
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
		script_execute(onClickAction);
		clicked = false;
	}
} else {
	clicked = false;
}
