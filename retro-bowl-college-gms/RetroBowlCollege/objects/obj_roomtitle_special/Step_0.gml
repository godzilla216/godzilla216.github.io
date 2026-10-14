draw_set_font(global.fnt_flex);
var tx = display_get_gui_width() * 0.5;
var tw = string_hd_width(text) * 0.5;
var th = string_hd_height(text) * 0.5;
if (s_is_touch_allowed() && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), tx - tw, ty - th, tx + tw, ty + th)) {
	if (mouse_check_button_released(1)) {
		tap_count++;
	}
	if (tap_count > 4) {
		script_execute(self, other, onClickAction);
		tap_count = 0;
	}
}
if (global.gamepad && gamepad_button_check(global.gp.slot, 32781) && (gamepad_button_check_released(global.gp.slot, 32776) || gamepad_button_check_released(global.gp.slot, 32774))) {
	tap_count++;
	if (tap_count > 4) {
		script_execute(self, other, onClickAction);
		tap_count = 0;
	}
}
