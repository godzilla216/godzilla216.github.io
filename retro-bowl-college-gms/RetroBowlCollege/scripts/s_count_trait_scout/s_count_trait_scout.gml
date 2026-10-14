function s_count_trait_scout() {
	var count = 0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(stafflist); i++) {
			var pmap = ds_list_find_value(stafflist, i);
			if (ds_map_find_value(pmap, "trait") == 9) {
				count++;
			}
		}
	}
	return count;
}

