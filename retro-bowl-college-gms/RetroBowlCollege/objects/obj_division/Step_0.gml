if (!active) {
	if (s_is_touch_allowed() && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + sprite_width, y + sprite_height)) {
		if (mouse_check_button_released(1)) {
			btn_click_LeagueMode();
		}
	}
}
event_inherited();
