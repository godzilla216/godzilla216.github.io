function s_update_maplist_from_file(_arg0, _arg1) {
	var maplist = _arg0;
	var fname = _arg1;
	slog("s_update_maplist_from_file:" + fname);
	slog("Existing list = " + string(ds_list_size(maplist)));
	var file = file_text_open_read(fname);
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var map = ds_map_create();
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		for (var i = 0; i < array_length_1d(keys); i++) {
			ds_map_add(map, keys[i], values[i]);
		}
		var mapexists = false;
		for (var i = 0; i < ds_list_size(maplist); i++) {
			var oldmap = ds_list_find_value(maplist, i);
			if (ds_map_find_value(oldmap, "tag") == ds_map_find_value(map, "tag")) {
				mapexists = true;
				ds_map_set(oldmap, "description", ds_map_find_value(map, "description"));
				break;
			}
		}
		if (!mapexists) {
			ds_list_add(maplist, map);
		}
	}
	file_text_close(file);
	slog("New list = " + string(ds_list_size(maplist)));
}

