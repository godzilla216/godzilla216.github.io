function s_load_retrobowl_hof() {
	slog("s_load_retrobowl_hof");
	var list = ds_list_create();
	var file = file_text_open_read("RetroBowlHOF.txt");
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var map = ds_map_create();
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		for (var i = 0; i < array_length_1d(keys); i++) {
			ds_map_add(map, keys[i], values[i]);
		}
		ds_list_add(list, map);
	}
	file_text_close(file);
	return list;
}

