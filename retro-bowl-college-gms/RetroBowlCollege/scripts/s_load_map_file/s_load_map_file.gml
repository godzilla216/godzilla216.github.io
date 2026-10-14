function s_load_map_file(_arg0) {
	slog("s_load_mapfile:" + _arg0);
	var list = ds_list_create();
	var file = file_text_open_read(_arg0);
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
	slog("Added items: " + string(ds_list_size(list)));
	return list;
}

function s_destroy_map_file(_arg0) {
	if (ds_exists(_arg0, 2) == false) {
		return;
	}
	for (var i = ds_list_size(_arg0) - 1; i >= 0; i--) {
		ds_map_destroy(ds_list_find_value(_arg0, i));
		ds_list_set(_arg0, i, -1);
	}
	ds_list_destroy(_arg0);
}

