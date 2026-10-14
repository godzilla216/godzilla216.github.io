function s_copy_teamnames_from_uniform_file(_arg0) {
	slog("s_copy_teamnames_from_uniform_file:" + _arg0);
	var file = file_text_open_read(_arg0);
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		var uid = values[0];
		var tmap = s_get_team_by_id(uid);
		ds_map_set(tmap, "name", values[1]);
		ds_map_set(tmap, "tla", values[2]);
	}
	file_text_close(file);
}

