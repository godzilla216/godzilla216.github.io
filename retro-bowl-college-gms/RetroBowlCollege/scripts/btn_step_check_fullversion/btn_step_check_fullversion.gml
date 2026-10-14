function btn_step_check_fullversion() {
	if (ds_map_find_value(obj_master.map_options, "fullversion")) {
		active = false;
		text = s_str("ui_Purchased");
	}
}

