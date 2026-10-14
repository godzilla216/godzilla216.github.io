function s_load_retrobowl_history() {
	slog("s_load_retrobowl_history");
	var list = ds_list_create();
	var file = file_text_open_read("RetroBowl_History.txt");
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var map = ds_map_create();
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		for (var i = 0; i < array_length_1d(keys); i++) {
			ds_map_add(map, keys[i], values[i]);
		}
		if (real(ds_map_find_value(map, "year")) <= obj_master.start_year) {
			ds_list_add(list, map);
		} else {
			ds_map_destroy(map);
		}
	}
	file_text_close(file);
	return list;
}

