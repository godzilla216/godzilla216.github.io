function s_count_players_by_position(_arg0) {
	var count = 0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (_arg0 == 9 || _arg0 == 8) {
				if (ds_map_find_value(pmap, "position") == 9 || ds_map_find_value(pmap, "position") == 8) {
					count++;
				}
			} else if (ds_map_find_value(pmap, "position") == _arg0) {
				count++;
			}
		}
	}
	return count;
}

