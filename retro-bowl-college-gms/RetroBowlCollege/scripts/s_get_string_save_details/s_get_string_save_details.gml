function s_get_string_save_details(_arg0, _arg1) {
	var filename = global.g_savename1;
	if (_arg0 == 2) {
		filename = global.g_savename2;
	}
	if (_arg0 == 3) {
		filename = global.g_savename3;
	}
	if (_arg0 == 4) {
		filename = global.g_savename4;
	}
	if (_arg0 == 5) {
		filename = global.g_savename5;
	}
	if (_arg1) {
		filename = "backup_" + filename;
	}
	slog("Getting save details: " + filename);
	if (file_exists(filename)) {
		slog("Opening file: " + filename);
		ini_open(filename);
		var year = ini_read_real("savegame", "year", 1);
		var week = ini_read_real("savegame", "week", 1);
		var wk = "W" + string(week);
		if (week > 18) {
			wk = "PS";
		}
		var ES_LEN = 2;
		if (week <= 14) {
			wk = "W" + string(week);
		} else if (week > 14 && week <= 14 + ES_LEN) {
			wk = "ES" + string(week - 14);
		} else {
			wk = "PS" + string(week - 14 - ES_LEN);
		}
		var my_tid = ini_read_real("savegame", "myteam_id", 0);
		ini_close();
		var team_name = s_load_teamname_from_uniform_file(my_tid, "uniforms_custom_" + string(_arg0) + ".txt");
		var txt = string_hash_to_newline(team_name + "  Y" + string(year) + " " + wk);
		return txt;
	}
	return "";
}

