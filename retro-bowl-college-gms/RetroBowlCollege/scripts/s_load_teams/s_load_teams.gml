function s_load_teams() {
	slog("s_load_teams co_mode:" + string(obj_master.co_mode) + " ");
	var list = ds_list_create();
	if (s_is_co_mode()) {
		s_load_teams_data(list, "Teams.txt");
		s_load_teams_data(list, s_get_versioned_path("Teams_CO.txt"));
	} else {
		s_load_teams_data(list, "Teams.txt");
	}
	return list;
}

function s_load_teams_data(_arg0, _arg1) {
	var file = file_text_open_read(_arg1);
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	var map, values, i;
	while (!file_text_eof(file)) {
		map = ds_map_create();
		values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		for (i = 0; i < array_length(keys); i++) {
			ds_map_add(map, keys[i], values[i]);
		}
		s_reset_co_team_data(map);
		ds_list_add(_arg0, map);
	}
	file_text_close(file);
}

function s_reset_co_team_data(_arg0) {
	ds_map_set(_arg0, "wins_cnf", 0);
	ds_map_set(_arg0, "losses_cnf", 0);
	ds_map_set(_arg0, "wins_div", 0);
	ds_map_set(_arg0, "losses_div", 0);
	ds_map_set(_arg0, "ranking_points", 0);
	ds_map_set(_arg0, "ranking_points_prev", 0);
	ds_map_set(_arg0, "ranking_points_season", 0);
}

function s_set_teams_min_max_ids() {
	with (obj_master) {
		min_team_id = 0;
		max_team_id = 31;
		if (s_is_co_mode() && variable_instance_exists(id, "teamlist")) {
			min_team_id = 32;
			max_team_id = ds_list_size(teamlist) - 1;
		}
	}
}

function s_get_struct_in_array_by_uid(_arg0, _arg1) {
	for (var i = 0; i < array_length(_arg0); i++) {
		if (_arg0[i].uid == _arg1) {
			return _arg0[i];
		}
	}
	return -4;
}

function load_data_to_struct_array(_arg0) {
	var file = file_text_open_read(_arg0);
	var array = [];
	var line = 0;
	var str = file_text_read_string(file);
	slog(str);
	var keys = s_split_string(str);
	file_text_readln(file);
	var values, values_count;
	while (!file_text_eof(file)) {
		values = s_split_string(file_text_read_string(file));
		values_count = array_length(values);
		file_text_readln(file);
		if (string_pos("//", values[0]) != 1 && values[0] != "" && !is_undefined(values[0])) {
			array[line] = {};
			for (var i = 0; i < array_length(keys); i++) {
				variable_struct_set(array[line], keys[i], i < values_count ? values[i] : "");
			}
			line++;
		}
	}
	file_text_close(file);
	return array;
}

function s_load_json(_arg0) {
	var file_handle;
	var json_string = "";
	var data = {};
	slogf("Opening json file %1", _arg0);
	file_handle = file_text_open_read(_arg0);
	if (file_handle == -1) {
		slogf("File %1 cannnot be opened", _arg0);
		return -4;
	}
	while (!file_text_eof(file_handle)) {
		json_string += file_text_readln(file_handle);
	}
	file_text_close(file_handle);
	data = json_parse(json_string);
	return data;
}

function s_save_json(_arg0, _arg1) {
	var file_handle;
	var json_string = "";
	slogf("Opening json file %1 for writing", _arg0);
	file_handle = file_text_open_write(_arg0);
	if (file_handle == -1) {
		slogf("File %1 cannnot be opened for writing", _arg0);
		return false;
	}
	json_string = json_stringify(_arg1);
	file_text_write_string(file_handle, json_string);
	file_text_close(file_handle);
}

