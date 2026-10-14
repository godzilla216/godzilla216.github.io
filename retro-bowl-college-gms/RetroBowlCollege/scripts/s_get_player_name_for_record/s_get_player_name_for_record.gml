function s_get_player_name_for_record(_arg0) {
	var pmap = _arg0;
	return s_get_string_position(ds_map_find_value(pmap, "position")) + " " + string_copy(ds_map_find_value(pmap, "fname"), 1, 1) + "." + ds_map_find_value(pmap, "lname");
}

