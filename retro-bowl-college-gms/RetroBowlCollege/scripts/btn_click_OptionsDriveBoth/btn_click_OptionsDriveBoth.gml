function btn_click_OptionsDriveBoth() {
	with (obj_master) {
		ds_map_set(map_options, "op_drivedir", 0);
		s_update_options();
	}
}

