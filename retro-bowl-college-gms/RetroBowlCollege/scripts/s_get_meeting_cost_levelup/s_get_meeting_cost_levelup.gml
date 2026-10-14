function s_get_meeting_cost_levelup(_arg0) {
	return round(real(ds_map_find_value(_arg0, "xp_level")) * 4);
}

