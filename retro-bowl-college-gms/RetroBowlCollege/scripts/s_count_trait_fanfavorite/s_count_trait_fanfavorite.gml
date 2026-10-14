function s_count_trait_fanfavorite() {
	var count = 0;
	with (obj_master) {
		if (!qb_mode) {
			return 0;
		}
		for (var i = 0; i < ds_list_size(stafflist); i++) {
			var pmap = ds_list_find_value(stafflist, i);
			if (ds_map_find_value(pmap, "trait") == 5) {
				count++;
			}
		}
	}
	return count;
}

