if (s_is_touch_allowed() && mouse_y > y && mouse_y < y + sprite_height) {
	if (mouse_x > x && mouse_x < x + sprite_width) {
		flick_lineY = ds_map_find_value(event_data, "diffY");
	}
}
