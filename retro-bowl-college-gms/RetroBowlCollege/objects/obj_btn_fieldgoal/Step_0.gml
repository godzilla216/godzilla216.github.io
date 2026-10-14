with (obj_msgbg) {
	exit;
}
mx = device_mouse_x_to_gui(0);
my = device_mouse_y_to_gui(0);
hover = false;
if (obj_controller.state == 10) {
	exit;
}
if (global.gamepad) {
	if (gamepad_button_check_pressed(global.gp.slot, gp_mapped_button) || gamepad_button_check_pressed(global.gp.slot, gp_mapped_hidden)) {
		onClickAction();
	}
} else {
	if (!s_is_touch_allowed()) {
		exit;
	}
	if (point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height)) {
		hover = true;
	}
	if (hover && mouse_check_button_released(1)) {
		onClickAction();
	}
}
