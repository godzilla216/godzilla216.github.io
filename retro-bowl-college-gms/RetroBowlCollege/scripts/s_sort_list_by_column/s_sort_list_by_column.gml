function s_sort_maplist_by_numeric_field(_arg0, _arg1, _arg2) {
	slog("s_sort_list_by_column");
	var sortedlist = ds_list_create();
	while (ds_list_size(_arg0) > 0) {
		var bestmap = -1;
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var map = ds_list_find_value(_arg0, i);
			if (!bestmap) {
				bestmap = map;
			} else if (_arg2) {
				if (real(ds_map_find_value(map, _arg1)) < real(ds_map_find_value(bestmap, _arg1))) {
					bestmap = map;
				}
			} else if (real(ds_map_find_value(map, _arg1)) > real(ds_map_find_value(bestmap, _arg1))) {
				bestmap = map;
			}
		}
		ds_list_add(sortedlist, bestmap);
		var i = ds_list_find_index(_arg0, bestmap);
		ds_list_delete(_arg0, i);
	}
	ds_list_destroy(_arg0);
	_arg0 = -1;
	return sortedlist;
}

