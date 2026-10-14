function btn_click_OptionsDriveRight() {
	with (obj_master) {
		ds_map_set(map_options, "op_drivedir", 1);
		s_update_options();
	}
}

