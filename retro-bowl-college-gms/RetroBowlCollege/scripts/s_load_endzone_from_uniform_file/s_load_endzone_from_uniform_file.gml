function s_load_endzone_from_uniform_file(_arg0, _arg1) {
	var uid = _arg0;
	var filename = _arg1;
	slog("s_load_endzone_from_uniform_file:" + filename);
	if (!file_exists(filename)) {
		var tmap = ds_list_find_value(obj_master.teamlist, uid);
		return string(ds_map_find_value(tmap, "colshirt"));
	} else {
		var file = file_text_open_read(filename);
		var keys = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		while (!file_text_eof(file)) {
			var values = s_split_string(file_text_read_string(file));
			file_text_readln(file);
			if (values[0] == uid) {
				file_text_close(file);
				return string(values[38]);
				break;
			}
		}
		file_text_close(file);
	}
}

