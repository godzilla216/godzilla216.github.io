function s_sort_retrobowl_history_list(_arg0) {
	slog("s_sort_retrobowl_winners_list");
	var sortedlist = ds_list_create();
	while (ds_list_size(_arg0) > 0) {
		var best = -4;
		var bestcount = 0;
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var pmap = ds_list_find_value(_arg0, i);
			if (!ds_map_exists(pmap, "year")) {
				ds_map_set(pmap, "year", 0);
			}
			var year = real(ds_map_find_value(pmap, "year"));
			if (!best || year < bestcount) {
				best = pmap;
				bestcount = year;
			}
		}
		ds_list_add(sortedlist, best);
		var i = ds_list_find_index(_arg0, best);
		ds_list_delete(_arg0, i);
	}
	ds_list_destroy(_arg0);
	_arg0 = -1;
	return sortedlist;
}

