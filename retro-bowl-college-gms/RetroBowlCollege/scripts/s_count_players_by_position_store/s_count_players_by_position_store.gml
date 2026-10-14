function s_count_players_by_position_store(_arg0) {
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(storelist); i++) {
			var pmap = ds_list_find_value(storelist, i);
			if (ds_map_find_value(pmap, "position") == _arg0) {
				count++;
			}
		}
		return count;
	}
}

