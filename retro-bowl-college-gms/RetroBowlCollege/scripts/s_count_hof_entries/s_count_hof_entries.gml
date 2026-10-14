function s_count_hof_entries() {
	with (obj_master) {
		var count = 0;
		for (var r = 0; r < ds_list_size(roster); r++) {
			var pmap = ds_list_find_value(roster, r);
			if (pmap && ds_map_exists(pmap, "hof") && ds_map_find_value(pmap, "hof") == true) {
				count++;
			}
		}
		count += ds_list_size(hoflist);
		return count;
	}
}

