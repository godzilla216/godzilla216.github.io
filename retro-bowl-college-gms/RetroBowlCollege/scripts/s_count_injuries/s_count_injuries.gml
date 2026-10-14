function s_count_injuries() {
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "condition") <= -1) {
				count++;
			}
		}
		return count;
	}
}

