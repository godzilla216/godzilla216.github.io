function s_get_team_offense_with_reputation_boost(_arg0) {
	return s_get_strength_with_reputation_boost(ds_map_find_value(_arg0, "offense"), _arg0);
}

function s_get_team_defense_with_reputation_boost(_arg0) {
	return s_get_strength_with_reputation_boost(ds_map_find_value(_arg0, "defense"), _arg0);
}

function s_get_strength_with_reputation_boost(_arg0, _arg1) {
	if (ds_map_find_value(_arg1, "uid") == obj_master.myteam_id) {
		return real(_arg0);
	}
	return clamp(real(_arg0) + s_get_reputation_points(_arg1), 1, 10);
}

function s_get_reputation_points(_arg0) {
	if (!s_is_co_mode() || _arg0 == -4) {
		return 0;
	}
	return s_get_reputation_string_points(ds_map_find_value(_arg0, "reputation"));
}

function s_update_fixture_teams_reputation(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	if (_arg0 == -4) {
		return;
	}
	var winner_id = s_get_fix_winner_id(_arg0);
	if (winner_id == -1) {
		return;
	}
	var away_team_id = real(ds_map_find_value(_arg0, "away_team"));
	var home_team_id = real(ds_map_find_value(_arg0, "home_team"));
	s_update_team_reputation_flag(ds_map_find_value(_arg0, "reputation"), s_get_team_by_id(away_team_id), away_team_id == winner_id);
	s_update_team_reputation_flag(ds_map_find_value(_arg0, "reputation"), s_get_team_by_id(home_team_id), home_team_id == winner_id);
}

function s_has_reputation_point(_arg0) {
	if (!s_is_co_mode()) {
		return false;
	}
	var rep_data = s_convert_reputation_string_to_data(ds_map_find_value(_arg0, "reputation"));
	if (rep_data == -4) {
		return false;
	}
	return rep_data.hystory[3];
}

function s_update_all_teams_reputation(_arg0) {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(teamlist); i++) {
			s_update_team_reputation(ds_list_find_value(teamlist, i), _arg0, 0);
		}
	}
}

function s_update_team_reputation_flag(_arg0, _arg1, _arg2) {
	var rep_code = _arg2 ? "w" : "l";
	if (string_pos(rep_code, _arg0) != 0) {
		s_update_team_reputation(_arg1, obj_master.year + 1, 1);
	}
}

function s_update_team_reputation(_arg0, _arg1, _arg2) {
	var rep_data = s_get_team_reputation_data(_arg0);
	if (rep_data == -4) {
		slogf("Invalid team %1 reputation, can't update", ds_map_find_value(_arg0, "uid"));
		return;
	}
	if (s_update_reputation_data(rep_data, _arg1, _arg2)) {
		s_set_team_reputation_data(_arg0, rep_data);
		slogf("team %1 reputation updated: %2", ds_map_find_value(_arg0, "uid"), ds_map_find_value(_arg0, "reputation"));
		return;
	}
	slogf("team %1 reputation not updated: %2", ds_map_find_value(_arg0, "uid"), ds_map_find_value(_arg0, "reputation"));
}

function s_get_team_reputation_data(_arg0) {
	var rep_data = s_convert_reputation_string_to_data(ds_map_find_value(_arg0, "reputation"));
	slog(rep_data);
	return rep_data;
}

function s_set_team_reputation_data(_arg0, _arg1) {
	var rep_data_str = s_convert_reputation_data_to_string(_arg1);
	slog(rep_data_str);
	ds_map_set(_arg0, "reputation", rep_data_str);
}

function s_convert_reputation_string_to_data(_arg0) {
	var rep_data = s_create_reputation_data();
	if (is_string(_arg0) && string_length(_arg0) > 0) {
		var rd = string_split(_arg0, ":");
		if (rd[0] == "y") {
			rep_data.year = real(rd[1]);
			for (var i = 0; i < 4; i++) {
				rep_data.history[i] = bool(string_char_at(rd[2], i + 1));
			}
			return rep_data;
		}
	}
	return -4;
}

function s_convert_reputation_data_to_string(_arg0) {
	return s_strfl("y:%1:%2%3%4%5", _arg0.year, _arg0.history[0] ? "1" : "0", _arg0.history[1] ? "1" : "0", _arg0.history[2] ? "1" : "0", _arg0.history[3] ? "1" : "0");
}

function s_create_reputation_data(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.year;
	}
	if (_arg1 == undefined) {
		_arg1 = 0;
	}
	if (_arg2 == undefined) {
		_arg2 = 0;
	}
	if (_arg3 == undefined) {
		_arg3 = 0;
	}
	if (_arg4 == undefined) {
		_arg4 = 0;
	}
	return { year: _arg0, history: [_arg1, _arg2, _arg3, _arg4] };
}

function s_update_reputation_data(_arg0, _arg1, _arg2) {
	if (_arg0.year == _arg1) {
		return false;
	}
	_arg0.year = _arg1;
	array_delete(_arg0.history, 0, 1);
	array_push(_arg0.history, _arg2);
	return true;
}

function s_is_reputation_string_updated(_arg0) {
	var _rep_data = s_convert_reputation_string_to_data(_arg0);
	if (_rep_data != -4) {
		return _rep_data.year > obj_master.year;
	}
	return false;
}

function s_is_reputation_data_updated(_arg0) {
	return _arg0.year > obj_master.year;
}

function s_get_reputation_string_points(_arg0) {
	return s_get_reputation_data_points(s_convert_reputation_string_to_data(_arg0));
}

function s_get_reputation_data_points(_arg0) {
	if (_arg0 == -4) {
		return 0;
	}
	return _arg0.history[0] + _arg0.history[1] + _arg0.history[2] + _arg0.history[3];
}

function s_reputation_data_test() {
	var rs = "y:2:0110";
	var rs2 = "y:4:0111";
	var rd = s_create_reputation_data(3, 0, 1, 0, 1);
	slogf("\n*** reputation data test");
	slogf("\nstring to data '%1'", rs);
	slog(s_convert_reputation_string_to_data(rs));
	slogf("\ndata to string %1", rd);
	slog(s_convert_reputation_data_to_string(rd));
	slogf("\nupdate data %1 to year %2 with %3", rd, 4, 1);
	slogf("reputation data updated: %1", s_update_reputation_data(rd, 4, 1));
	slogf("result: %1", rd);
	slogf("\nis string %1 updated: %2 (current year: %3)", rs, s_is_reputation_string_updated(rs), obj_master.year);
	slogf("is string %1 updated: %2 (current year: %3)", rs2, s_is_reputation_string_updated(rs2), obj_master.year);
	slogf("%1 reputation points: %2 ", rs2, s_get_reputation_string_points(rs2));
	slogf("%1 reputation points: %2 ", rd, s_get_reputation_data_points(rd));
}

