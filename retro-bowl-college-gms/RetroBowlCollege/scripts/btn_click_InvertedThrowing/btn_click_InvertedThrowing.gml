function btn_click_InvertedThrowing() {
	with (obj_master) {
		ds_map_set(map_options, "op_invert_throw", ds_map_find_value(map_options, "op_invert_throw") + 1);
		if (ds_map_find_value(map_options, "op_invert_throw") > 1) {
			ds_map_set(map_options, "op_invert_throw", 0);
		}
		s_update_options();
	}
}

