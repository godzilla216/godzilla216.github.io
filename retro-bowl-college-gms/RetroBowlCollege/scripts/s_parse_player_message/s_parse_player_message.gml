function s_parse_player_message(_arg0, _arg1) {
	var tid = ds_map_find_value(_arg1, "teamid");
	if (tid < 0) {
		tid = obj_master.myteam_id;
	}
	slog("Parse player. Team id = " + string(tid));
	_arg0 = string_replace_all(_arg0, "$teamname", s_get_team_name_by_id(tid));
	_arg0 = string_replace_all(_arg0, "$position", s_get_string_position_full(ds_map_find_value(_arg1, "position")));
	_arg0 = string_replace_all(_arg0, "$pos", s_get_string_position(ds_map_find_value(_arg1, "position")));
	_arg0 = string_replace_all(_arg0, "$playername", ds_map_find_value(_arg1, "fname") + " " + ds_map_find_value(_arg1, "lname"));
	_arg0 = string_replace_all(_arg0, "$playerlastname", ds_map_find_value(_arg1, "lname"));
	_arg0 = string_replace_all(_arg0, "$hirename", ds_map_find_value(_arg1, "fname") + " " + ds_map_find_value(_arg1, "lname"));
	_arg0 = string_replace_all(_arg0, "$age", ds_map_find_value(_arg1, "age"));
	_arg0 = string_replace_all(_arg0, "$contract", ds_map_find_value(_arg1, "contract"));
	_arg0 = string_replace_all(_arg0, "$salary", "$" + string(ds_map_find_value(_arg1, "salary")) + s_str("sla_Million"));
	_arg0 = string_replace_all(_arg0, "$uniform", string_lower(s_str("uniformviolation_" + string(irandom(9)))));
	if (ds_map_find_value(_arg1, "position") == 10) {
		_arg0 = string_replace_all(_arg0, "$injurytype", string_lower(s_str("injurytype_" + string(irandom_range(6, 11)))));
	} else {
		_arg0 = string_replace_all(_arg0, "$injurytype", string_lower(s_str("injurytype_" + string(irandom(11)))));
	}
	_arg0 = string_replace_all(_arg0, "$randomfname_female", s_get_random_first_name(false));
	_arg0 = string_replace_all(_arg0, "$randomcharity", s_get_random_charity());
	_arg0 = string_replace_all(_arg0, "$randomteamname", s_get_random_teamname(false));
	var smap = s_get_staff(101);
	if (s_is_offensive_player(_arg1)) {
		smap = s_get_staff(102);
	}
	if (smap) {
		_arg0 = string_replace(_arg0, "$coachposition", s_get_string_position_full(ds_map_find_value(smap, "position")));
	}
	_arg0 = string_replace_all(_arg0, "$myteamname", s_get_team_name_by_id(obj_master.myteam_id));
	if (obj_master.qb_mode) {
		var qb_map = s_get_qb_pmap();
		if (qb_map) {
			_arg0 = string_replace_all(_arg0, "$mylastname", ds_map_find_value(qb_map, "lname"));
			_arg0 = string_replace_all(_arg0, "$myname", ds_map_find_value(qb_map, "fname") + " " + ds_map_find_value(qb_map, "lname"));
		}
	}
	var hc_map = s_get_staff(100);
	if (hc_map) {
		_arg0 = string_replace_all(_arg0, "$headcoachlastname", ds_map_find_value(hc_map, "lname"));
		_arg0 = string_replace_all(_arg0, "$headcoachname", ds_map_find_value(hc_map, "fname") + " " + ds_map_find_value(hc_map, "lname"));
	}
	var fix = s_get_human_fixture_next();
	if (fix) {
		if (ds_map_find_value(fix, "home_team") == obj_master.myteam_id && ds_map_find_value(fix, "away_team") > -1) {
			_arg0 = string_replace_all(_arg0, "$nextoppname", s_get_team_name_by_id(ds_map_find_value(fix, "away_team")));
		} else if (ds_map_find_value(fix, "home_team") > -1) {
			_arg0 = string_replace_all(_arg0, "$nextoppname", s_get_team_name_by_id(ds_map_find_value(fix, "home_team")));
		}
	}
	fix = s_get_human_fixture_previous();
	if (fix) {
		if (ds_map_find_value(fix, "home_team") == obj_master.myteam_id && ds_map_find_value(fix, "away_team") > -1) {
			_arg0 = string_replace_all(_arg0, "$lastoppname", s_get_team_name_by_id(ds_map_find_value(fix, "away_team")));
		} else if (ds_map_find_value(fix, "home_team") > -1) {
			_arg0 = string_replace_all(_arg0, "$lastoppname", s_get_team_name_by_id(ds_map_find_value(fix, "home_team")));
		}
	}
	if (s_is_co_mode() && s_is_staff(ds_map_find_value(_arg1, "position")) == false) {
		_arg0 = string_replace_all(_arg0, "$HOBBY", s_get_hobby_name(_arg1, false));
		_arg0 = string_replace_all(_arg0, "$MAJOR", s_get_major_name(_arg1, false));
		_arg0 = string_replace_all(_arg0, "$MINOR", s_get_minor_name(_arg1, false));
		_arg0 = string_replace_all(_arg0, "$HOMETOWN", s_get_hometown_name(_arg1));
		_arg0 = string_replace_all(_arg0, "$ONLYHOMETOWN", s_get_only_hometown_name(_arg1));
		_arg0 = string_replace_all(_arg0, "$ONLYSTATE", s_get_only_state_name(_arg1));
		_arg0 = string_replace_all(_arg0, "$leaveyear", string(ds_map_find_value(_arg1, "class_of")));
		if (ds_map_find_value(_arg1, "drafted_pro_team") != "" && string_pos("$draftedteamname", _arg0)) {
			var proTeams = s_load_pro_teams();
			for (var i = 0; i < ds_list_size(proTeams); i++) {
				var proTeam = ds_list_find_value(proTeams, i);
				if (ds_map_find_value(proTeam, "uid") == ds_map_find_value(_arg1, "drafted_pro_team")) {
					_arg0 = string_replace_all(_arg0, "$draftedteamname", ds_map_find_value(proTeam, "name"));
					break;
				}
			}
			ds_list_destroy(proTeams);
		}
		_arg0 = string_replace_all(_arg0, "$academicyear", s_college_age_simple(_arg1));
		_arg0 = string_replace_all(_arg0, "$academicotheryear", s_college_age_simple_other(_arg1));
		_arg0 = string_replace_all(_arg0, "$gpa", s_gpa_string(_arg1));
		_arg0 = string_replace_all(_arg0, "$draftroundpick", string(ds_map_find_value(_arg1, "draft_round_pick")));
	}
	return string_hash_to_newline(_arg0);
}

