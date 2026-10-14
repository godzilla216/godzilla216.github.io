function s_get_history_by_year(_arg0) {
	var yr = _arg0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(history); i++) {
			var map = ds_list_find_value(history, i);
			if (ds_map_find_value(map, "year") == yr) {
				return map;
			}
		}
		return -4;
	}
}

function s_create_history_for_current_year() {
	var map = ds_map_create();
	ds_map_set(map, "year", obj_master.year);
	ds_map_set(map, "uid", ds_map_find_value(obj_master.myteam, "uid"));
	ds_map_set(map, "name", ds_map_find_value(obj_master.myteam, "name"));
	ds_map_set(map, "tla", ds_map_find_value(obj_master.myteam, "tla"));
	ds_map_set(map, "wins", 0);
	ds_map_set(map, "losses", 0);
	ds_map_set(map, "ties", 0);
	ds_map_set(map, "finish", "");
	ds_map_set(map, "wins_sim", 0);
	ds_map_set(map, "losses_sim", 0);
	ds_map_set(map, "ties_sim", 0);
	ds_map_set(map, "wins_cnf", 0);
	ds_map_set(map, "losses_cnf", 0);
	ds_map_set(map, "losses_po", 0);
	ds_map_set(map, "wins_po", 0);
	if (s_is_co_mode()) {
		ds_map_set(map, "conference", ds_map_find_value(obj_master.myteam, "conference"));
		ds_map_set(map, "conference_finish_place", -1);
		ds_map_set(map, "division", ds_map_find_value(obj_master.myteam, "division"));
		ds_map_set(map, "subdivision", "");
		ds_map_set(map, "subdivision_rank", -1);
		ds_map_set(map, "conf_champ_win", -1);
		ds_map_set(map, "conf_armynavy_win", -1);
		ds_map_set(map, "playoff_round_reach", -1);
		ds_map_set(map, "won_bowl", -1);
		ds_map_set(map, "subdivision_champ", "");
	}
	ds_list_add(obj_master.history, map);
	return map;
}

function s_log_this_year_history() {
	var map = s_get_history_by_year(obj_master.year);
	if (map != -4) {
		slog_map("HISTORICAL SO FAR, Y[" + string(obj_master.year) + "]", map);
	}
}

function s_log_full_history() {
	slog("s_log_full_history");
	for (var i = ds_list_size(obj_master.history) - 1; i >= 0; i--) {
		var map = ds_list_find_value(obj_master.history, i);
		slog_map(" Y[" + string(i) + "]", map);
	}
}

function s_update_history(_arg0) {
	slog("s_update_history");
	with (obj_master) {
		var map = s_create_history_for_current_year();
		if (year == 1) {
			ds_map_set(map, "wins", 0);
			ds_map_set(map, "losses", 0);
			ds_map_set(map, "ties", 0);
			switch (_arg0) {
				case -1:
					ds_map_set(map, "losses", 1);
					break;
				case 0:
					ds_map_set(map, "ties", 1);
					break;
				case 1:
					ds_map_set(map, "wins", 1);
					break;
			}
		} else {
			ds_map_set(map, "wins", ds_map_find_value(myteam, "wins"));
			ds_map_set(map, "losses", ds_map_find_value(myteam, "losses"));
			ds_map_set(map, "ties", ds_map_find_value(myteam, "ties"));
		}
		var _conf = string_copy(s_get_string_conference(myconference), 1, 3);
		var _div = string_copy(s_get_string_division(myconference, mydivision), 1, 3);
		var _pos = s_get_team_position_by_id(myteam_id);
		ds_map_set(map, "finish", _conf + " " + _div + " " + s_str("pos_" + string(_pos)));
		ds_map_set(map, "wins_sim", s_count_simmed_games(1));
		ds_map_set(map, "losses_sim", s_count_simmed_games(-1));
		ds_map_set(map, "ties_sim", s_count_simmed_games(0));
		if (s_is_co_mode()) {
			if (year == 1) {
				ds_map_set(map, "wins_cnf", 0);
				ds_map_set(map, "losses_cnf", 0);
				switch (_arg0) {
					case -1:
						ds_map_set(map, "losses_cnf", 1);
						break;
					case 1:
						ds_map_set(map, "wins_cnf", 1);
						break;
				}
			} else {
				ds_map_set(map, "wins_cnf", ds_map_find_value(myteam, "wins_cnf"));
				ds_map_set(map, "losses_cnf", ds_map_find_value(myteam, "losses_cnf"));
			}
			var c_finish_place = s_get_my_conference_current_place();
			ds_map_set(map, "conference_finish_place", c_finish_place);
			if (c_finish_place == 0) {
				s_complete_achievement("ACH_WIN_CONF_DIV");
			}
		}
	}
	s_log_this_year_history();
}

function s_update_history_playoffs(_arg0) {
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			if (!ds_map_exists(map, "wins_po")) {
				ds_map_set(map, "wins_po", 0);
			}
			if (!ds_map_exists(map, "losses_po")) {
				ds_map_set(map, "losses_po", 0);
			}
			switch (_arg0) {
				case 0:
					ds_map_set(map, "losses_po", real(ds_map_find_value(map, "losses_po")) + 1);
					break;
				case 1:
					ds_map_set(map, "wins_po", real(ds_map_find_value(map, "wins_po")) + 1);
					break;
			}
		}
	}
	s_log_this_year_history();
}

function s_update_history_finish(_arg0) {
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			switch (_arg0) {
				case 1:
					ds_map_set(map, "finish", s_str("finish_WildCard"));
					break;
				case 2:
					ds_map_set(map, "finish", s_str("finish_Divisional"));
					break;
				case 3:
					ds_map_set(map, "finish", s_str("finish_Championship"));
					break;
				case 4:
					ds_map_set(map, "finish", s_str("finish_Champ_AFC"));
					if (myconference == 1) {
						ds_map_set(map, "finish", s_str("finish_Champ_NFC"));
					}
					break;
				case 5:
					ds_map_set(map, "finish", s_str("finish_SuperBowl"));
					break;
			}
		}
		ds_map_set(map, "wins_sim", s_count_simmed_games(1));
		ds_map_set(map, "losses_sim", s_count_simmed_games(-1));
		ds_map_set(map, "ties_sim", s_count_simmed_games(0));
	}
	s_log_this_year_history();
}

function s_update_history_season_end() {
	var FBSrank = s_subdivision_get_player_ranking(1);
	var FCSrank = s_subdivision_get_player_ranking(2);
	slog("FBSrank[" + string(FBSrank) + "] FCSrank[" + string(FCSrank) + "]");
	if (FBSrank != -1 && FBSrank < obj_master.rec_highest_rank_major) {
		obj_master.rec_highest_rank_major = FBSrank;
	}
	if (FCSrank != -1 && FCSrank < obj_master.rec_highest_rank_minor) {
		obj_master.rec_highest_rank_minor = FCSrank;
	}
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			ds_map_set(map, "subdivision", FBSrank == -1 ? "FCS" : "FBS");
			ds_map_set(map, "subdivision_rank", FBSrank == -1 ? FCSrank : FBSrank);
		}
	}
}

function s_update_history_won_championship(_arg0) {
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			if (real(_arg0) != 8000) {
				ds_map_set(map, "conf_champ_win", _arg0);
			} else {
				ds_map_set(map, "conf_armynavy_win", _arg0);
			}
		}
	}
}

function s_update_history_reached_playoffs_round(_arg0) {
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			ds_map_set(map, "playoff_round_reach", _arg0);
		}
	}
}

function s_update_history_won_bowl(_arg0) {
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			ds_map_set(map, "won_bowl", _arg0);
		}
	}
}

function s_update_history_subdivisional_champ_finals(_arg0) {
	with (obj_master) {
		var map = s_get_history_by_year(year);
		if (ds_exists(map, 1)) {
			ds_map_set(map, "subdivision_champ", _arg0);
		}
	}
}

function s_history_display_lines_count() {
	var _size = ds_list_size(obj_master.history);
	if (!s_is_co_mode()) {
		return _size;
	}
	var c = 0;
	for (var i = _size - 1; i >= 0; i--) {
		c += s_history_display_lines_count_yearindex(i);
	}
	return c + 1;
}

function s_history_display_lines_count_yearindex(_arg0) {
	if (!s_is_co_mode()) {
		return 1;
	}
	var c = 0;
	var map = ds_list_find_value(obj_master.history, _arg0);
	var recYear = real(ds_map_find_value(map, "year"));
	if (recYear == obj_master.year) {
		return 0;
	}
	var playoff_round = s_get_map_real(map, "playoff_round_reach", -1);
	c += 1;
	if (ds_map_find_value(map, "subdivision") != "") {
		c += 1;
	}
	if (s_get_map_real(map, "conf_champ_win", -1) != -1) {
		c += 1;
	}
	if (s_get_map_real(map, "conf_armynavy_win", -1) != -1) {
		c += 1;
	}
	if (playoff_round != -1) {
		c += 1;
	}
	if (s_get_map_real(map, "won_bowl", -1) != -1) {
		c += 1;
	}
	if (ds_map_find_value(map, "subdivision_champ") == "loss") {
		c += 1;
	}
	if (ds_map_find_value(map, "subdivision_champ") == "win") {
		c += 1;
	}
	return c;
}

