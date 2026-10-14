function s_count_hires_by_position(_arg0) {
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(hirelist); i++) {
			var pmap = ds_list_find_value(hirelist, i);
			if (ds_map_find_value(pmap, "position") == _arg0) {
				count++;
			}
		}
		return count;
	}
}

