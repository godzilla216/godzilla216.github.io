function s_sort_retrobowl_list(_arg0) {
	slog("s_sort_retrobowl_list");
	var plist = _arg0;
	var sortedlist = ds_list_create();
	while (ds_list_size(plist) > 0) {
		var best = -4;
		var bestcount = 0;
		for (var i = 0; i < ds_list_size(plist); i++) {
			var pmap = ds_list_find_value(plist, i);
			var count = real(ds_map_find_value(pmap, "count"));
			if (!best || count > bestcount) {
				best = pmap;
				bestcount = count;
			}
		}
		ds_list_add(sortedlist, best);
		var i = ds_list_find_index(plist, best);
		ds_list_delete(plist, i);
	}
	ds_list_destroy(plist);
	plist = -1;
	return sortedlist;
}

