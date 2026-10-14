function s_get_player_name(_arg0, _arg1) {
	var pmap = _arg0;
	var short = _arg1;
	switch (short) {
		case false:
			return ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
			break;
		case true:
			return string_copy(ds_map_find_value(pmap, "fname"), 1, 1) + "." + ds_map_find_value(pmap, "lname");
			break;
	}
}

