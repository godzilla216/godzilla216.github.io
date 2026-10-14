if (state == 3) {
	global.replay_drag_x = ds_map_find_value(event_data, "guiposX") - ds_map_find_value(event_data, "guistartposX");
}
