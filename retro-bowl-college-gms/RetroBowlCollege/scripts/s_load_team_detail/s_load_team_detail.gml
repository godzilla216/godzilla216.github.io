function s_load_team_detail(_arg0, _arg1) {
	var tid = _arg0;
	var findkey = _arg1;
	slog("s_load_team:" + string(tid));
	var file = file_text_open_read(s_teams_file());
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		if (values[0] == tid) {
			for (var i = 0; i < array_length_1d(keys); i++) {
				if (keys[i] == findkey) {
					file_text_close(file);
					return values[i];
				}
			}
		}
	}
	file_text_close(file);
	return "";
}

