num_tos = s_count_timeouts();
if (obj_controller.minutes == 0 && obj_controller.seconds == 0) {
	instance_destroy();
}
with (obj_msgbg) {
	exit;
}
mx = device_mouse_x_to_gui(0);
my = device_mouse_y_to_gui(0);
hover = false;
if (global.gamepad) {
	if (gamepad_button_check_pressed(global.gp.slot, gp_mapped_button) || gamepad_button_check_pressed(global.gp.slot, gp_mapped_hidden)) {
		s_do_timeout();
	}
} else {
	if (!s_is_touch_allowed()) {
		exit;
	}
	if (point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height)) {
		hover = true;
	}
	if (hover && mouse_check_button_pressed(1)) {
		s_do_timeout();
	}
}
