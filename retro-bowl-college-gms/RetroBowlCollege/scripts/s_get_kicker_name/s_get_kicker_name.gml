function s_get_kicker_name() {
	var kk = s_get_kicker();
	if (kk && kk.pmap) {
		return s_get_string_position(ds_map_find_value(kk.pmap, "position")) + " " + string_copy(ds_map_find_value(kk.pmap, "fname"), 1, 1) + "." + ds_map_find_value(kk.pmap, "lname");
	}
	return "0";
}

