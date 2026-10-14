function btn_click_OptionsScanlines() {
	with (obj_master) {
		ds_map_set(map_options, "op_scanlines", !ds_map_find_value(map_options, "op_scanlines"));
		obj_scanlines.on = ds_map_find_value(map_options, "op_scanlines");
		s_update_options();
	}
}

