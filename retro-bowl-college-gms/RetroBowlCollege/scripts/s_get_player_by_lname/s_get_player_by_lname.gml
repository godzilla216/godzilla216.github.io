function s_get_player_by_lname(_arg0) {
	var lname = _arg0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "lname") == lname) {
				return pmap;
			}
		}
	}
	return -4;
}

