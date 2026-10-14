function s_has_xp_gain(_arg0) {
	if (round(ds_map_find_value(_arg0, "xp") + ds_map_find_value(_arg0, "xp_gain")) < ds_map_find_value(_arg0, "xp_level") * 100) {
		return false;
	}
	return true;
}

