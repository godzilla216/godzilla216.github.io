function s_sort_hirelist(_arg0) {
	slog("s_sort_hirelist");
	var plist = _arg0;
	var sortedlist = ds_list_create();
	while (ds_list_size(plist) > 0) {
		var bestplayer = -4;
		for (var i = 0; i < ds_list_size(plist); i++) {
			var pmap = ds_list_find_value(plist, i);
			if (!bestplayer) {
				bestplayer = pmap;
			} else if (ds_map_find_value(pmap, "position") < ds_map_find_value(bestplayer, "position")) {
				bestplayer = pmap;
			} else if (ds_map_find_value(pmap, "position") == ds_map_find_value(bestplayer, "position")) {
				if (ds_map_exists(pmap, "rating")) {
					if (ds_map_find_value(pmap, "rating") < ds_map_find_value(bestplayer, "rating")) {
						bestplayer = pmap;
					}
				} else if (s_get_player_rating(pmap) > s_get_player_rating(bestplayer)) {
					bestplayer = pmap;
				}
			}
		}
		ds_list_add(sortedlist, bestplayer);
		var i = ds_list_find_index(plist, bestplayer);
		ds_list_delete(plist, i);
	}
	ds_list_destroy(plist);
	plist = -1;
	return sortedlist;
}

