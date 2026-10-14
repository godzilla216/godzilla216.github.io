function btn_click_OptionsZoom() {
	with (obj_master) {
		ds_map_set(map_options, "op_zoom", !ds_map_find_value(map_options, "op_zoom"));
		s_update_options();
	}
}

