function s_get_qb_name() {
	var qb = s_get_quarterback();
	if (qb && qb.pmap) {
		return s_get_string_position(ds_map_find_value(qb.pmap, "position")) + " " + string_copy(ds_map_find_value(qb.pmap, "fname"), 1, 1) + "." + ds_map_find_value(qb.pmap, "lname");
	}
	return "0";
}

