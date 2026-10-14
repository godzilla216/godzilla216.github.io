with (obj_msgbg) {
	exit;
}
mx = device_mouse_x_to_gui(0);
my = device_mouse_y_to_gui(0);
hover = false;
if (global.gamepad) {
	if (gamepad_button_check_released(global.gp.slot, gp_mapped_button)) {
		btn_kick_off();
	}
} else {
	if (!s_is_touch_allowed()) {
		exit;
	}
	if (point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height)) {
		hover = true;
	}
	if (mouse_check_button_released(1)) {
		btn_kick_off();
	}
}
