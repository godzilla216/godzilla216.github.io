function s_get_num_audibles(_arg0) {
	if (obj_master.year == 1) {
		return 0;
	}
	if (ds_map_find_value(_arg0, "xp_level") > 10) {
		return 5;
	}
	if (ds_map_find_value(_arg0, "xp_level") > 6) {
		return 4;
	}
	if (ds_map_find_value(_arg0, "xp_level") > 3) {
		return 3;
	}
	if (ds_map_find_value(_arg0, "xp_level") > 1) {
		return 2;
	}
	return 1;
}

