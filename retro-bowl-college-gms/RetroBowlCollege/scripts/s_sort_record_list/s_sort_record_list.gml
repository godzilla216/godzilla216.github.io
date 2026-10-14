function s_sort_record_list(_arg0) {
	slog("s_sort_record_list");
	var sortedlist = ds_list_create();
	while (ds_list_size(_arg0) > 0) {
		var lowest = -4;
		var lowestorder = 0;
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var pmap = ds_list_find_value(_arg0, i);
			var order = 0;
			if (ds_exists(pmap, 1) && ds_map_exists(pmap, "order")) {
				order = real(ds_map_find_value(pmap, "order"));
			}
			if (!lowest || order < lowestorder) {
				lowest = pmap;
				lowestorder = order;
			}
		}
		ds_list_add(sortedlist, lowest);
		var i = ds_list_find_index(_arg0, lowest);
		ds_list_delete(_arg0, i);
	}
	ds_list_destroy(_arg0);
	_arg0 = -1;
	return sortedlist;
}

