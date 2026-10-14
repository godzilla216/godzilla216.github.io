function s_refresh_strings() {
	return s_co_refresh_strings();
	if (ds_exists(obj_master.stringmap, 1)) {
		ds_map_destroy(obj_master.stringmap);
	}
	obj_master.stringmap = s_load_strings();
	s_update_game_title();
}

function s_load_strings() {
	return s_co_load_strings();
	slog("RELOADING LOCALE FILES");
	var map = ds_map_create();
	s_add_file_to_lang_strings(map, s_select_lang_file());
	s_add_file_to_lang_strings(map, s_select_override_lang_file());
	s_add_file_to_lang_strings(map, s_select_institution_lang_file());
	return map;
}

function s_select_lang() {
	if (os_get_config() == "Japan") {
		return "JP";
	}
	return "US";
}

function s_select_lang_file() {
	return "Language" + s_select_lang() + ".txt";
}

function s_select_override_lang_file() {
	var mode = "FR";
	if (s_is_co_mode()) {
		mode = "CO";
	}
	if (obj_master.qb_mode) {
		mode = "QB";
	}
	if (0 && mode == "CO") {
		mode = "CO_dbg";
	}
	return "Language" + s_select_lang() + "_" + mode + ".txt";
}

function s_select_institution_lang_file() {
	if (s_is_co_mode() == false) {
		return "";
	}
	if (s_college_academics_type("Military")) {
		return "Language" + s_select_lang() + "_MILCO.txt";
	}
	return "";
}

function s_add_file_to_lang_strings(_arg0, _arg1) {
	slog("s_add_file_to_lang_strings [" + string(_arg1) + "]");
	var map = _arg0;
	var fstr = _arg1;
	if (fstr == "") {
		return;
	}
	if (!file_exists(fstr)) {
		slog("s_add_file_to_lang_strings [" + string(_arg1) + "].. skipped. File invalid.");
		return;
	}
	var file = file_text_open_read(fstr);
	if (file == -1) {
		return;
	}
	var c = 0;
	while (!file_text_eof(file)) {
		var txt = file_text_read_string(file);
		file_text_readln(file);
		var pos = string_pos("\t", txt);
		if (pos == 0) {
			continue;
		}
		var len = string_length(txt);
		c++;
		ds_map_replace(map, string_copy(txt, 1, pos - 1), string_copy(txt, pos + 1, len - 1));
	}
	file_text_close(file);
}

function s_co_refresh_strings() {
	global.g_m.langdata = {};
	s_co_load_strings(global.g_m.langdata);
	s_update_game_title();
}

function s_co_load_strings(_arg0) {
	slog("RELOADING LOCALE FILES");
	s_load_language_file(_arg0, s_select_lang_file());
	s_load_language_file(_arg0, s_select_override_lang_file());
	s_load_language_file(_arg0, s_select_institution_lang_file());
}

function s_load_language_file(_arg0, _arg1) {
	if (_arg1 == -4 || _arg1 == "") {
		return;
	}
	var file = file_text_open_read(_arg1);
	var values, values_count;
	while (!file_text_eof(file)) {
		values = s_split_string(file_text_read_string(file));
		values_count = array_length(values);
		file_text_readln(file);
		if (string_pos("//", values[0]) != 1 && values[0] != "" && !is_undefined(values[0]) && values_count > 1) {
			struct_set_from_hash(_arg0, variable_get_hash(values[0]), values[1]);
		}
	}
	file_text_close(file);
}

