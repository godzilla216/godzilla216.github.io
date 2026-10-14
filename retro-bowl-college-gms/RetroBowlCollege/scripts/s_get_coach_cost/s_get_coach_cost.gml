function s_get_coach_cost(_arg0) {
	var pmap = _arg0;
	var val = ds_map_find_value(pmap, "rating") * 2.5;
	if (ds_map_find_value(pmap, "trait")) {
		val += 5;
	}
	return round(val);
}

