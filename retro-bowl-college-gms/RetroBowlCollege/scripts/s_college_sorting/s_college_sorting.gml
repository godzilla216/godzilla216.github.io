function s_co_teams_data_sort_rank(_arg0, _arg1) {
	var d = real(_arg1.rank_pts) * 1000 - real(_arg0.rank_pts) * 1000;
	if (d != 0) {
		return d;
	} else {
		return s_co_teams_tiebreak(_arg0, _arg1, false);
	}
}

function s_co_teams_data_sort_rank_season(_arg0, _arg1) {
	var d = real(_arg1.rank_season) * 1000 - real(_arg0.rank_season) * 1000;
	if (d != 0) {
		return d;
	} else {
		return s_co_teams_tiebreak(_arg0, _arg1, false);
	}
}

function s_co_teams_data_sort_rank_quick(_arg0, _arg1) {
	return real(_arg1.rank_pts) * 1000 - real(_arg0.rank_pts) * 1000;
}

function s_co_teams_data_sort_rank_pos(_arg0, _arg1) {
	return s_get_ranking_pos_data(_arg0.team).pos - s_get_ranking_pos_data(_arg1.team).pos;
}

function s_co_teams_data_sort_pct(_arg0, _arg1) {
	var d = real(_arg1.pct_cnf) * 1000 - real(_arg0.pct_cnf) * 1000;
	if (d != 0) {
		return d;
	} else {
		d = s_co_teams_tiebreak(_arg0, _arg1);
		return d;
	}
}

function s_co_teams_data_sort_pct_quick(_arg0, _arg1) {
	return real(_arg1.pct_cnf) * 1000 - real(_arg0.pct_cnf) * 1000;
}

function s_co_teams_data_sort_conf_wins_losses(_arg0, _arg1) {
	var wl1 = _arg0.wins_cnf - _arg0.losses_cnf;
	var wl2 = _arg1.wins_cnf - _arg1.losses_cnf;
	if (wl1 != wl2) {
		return wl2 - wl1;
	} else {
		return s_co_teams_tiebreak(_arg0, _arg1, false);
	}
}

function s_co_teams_data_sort_wins_rank(_arg0, _arg1) {
	var wr1 = _arg0.wins * 1000 + _arg0.rank_pts;
	var wr2 = _arg1.wins * 1000 + _arg1.rank_pts;
	if (wr1 != wr2) {
		return wr2 - wr1;
	} else {
		return s_co_teams_tiebreak(_arg0, _arg1, false);
	}
}

function s_create_team_data_array(_arg0) {
	var teams_ext = [];
	var tm;
	for (var i = 0; i < array_length(_arg0); i++) {
		tm = _arg0[i];
		var team = {
			team: tm,
			uid: ds_map_find_value(tm, "uid"),
			cnf_id: ds_map_find_value(tm, "conference"),
			div_id: ds_map_find_value(tm, "division"),
			name: ds_map_find_value(tm, "name"),
			wins: real(ds_map_find_value(tm, "wins")),
			losses: real(ds_map_find_value(tm, "losses")),
			wins_cnf: real(ds_map_find_value(tm, "wins_cnf")),
			losses_cnf: real(ds_map_find_value(tm, "losses_cnf")),
			wins_div: real(ds_map_find_value(tm, "wins_div")),
			losses_div: real(ds_map_find_value(tm, "losses_div")),
			rank_pts: s_get_map_real(tm, "ranking_points", 0),
			rank_pts_prev: s_get_map_real(tm, "ranking_points_prev", 0),
			rank_season: s_get_map_real(tm, "ranking_points_season", 0),
			pct: s_get_team_winpct(tm),
			pct_cnf: s_get_team_pct_cnf(tm),
			seeded: false
		};
		array_push(teams_ext, team);
	}
	return teams_ext;
}

function s_update_team_data_rank_pos(_arg0, _arg1, _arg2) {
	if (_arg1 == undefined) {
		_arg1 = false;
	}
	if (_arg2 == undefined) {
		_arg2 = 0;
	}
	var rp = s_get_ranking_pos_data(_arg0.team).pos;
	var rpp = s_get_ranking_pos_data_prev(_arg0.team).pos;
	if (_arg1) {
		rp = _arg2 + 1;
		rpp = s_parse_ranking_pos(s_get_map_real(_arg0.team, "ranking_pos_season", 0)).pos;
	}
	_arg0.rank_pos = rp;
	_arg0.rank_pos_prev = rpp;
	_arg0.rank_s = rpp != 0 ? s_strfl("%1(%2)", rp, rpp) : rp;
}

function s_team_data_array_add_formatted_data(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = false;
	}
	var td, of, df;
	for (var i = 0; i < array_length(_arg0); i++) {
		td = _arg0[i];
		td.wins = s_get_map_real(td.team, "wins", 0);
		td.losses = s_get_map_real(td.team, "losses", 0);
		td.wins_cnf = s_get_map_real(td.team, "wins_cnf", 0);
		td.losses_cnf = s_get_map_real(td.team, "losses_cnf", 0);
		td.wins_div = s_get_map_real(td.team, "wins_div", 0);
		td.losses_div = s_get_map_real(td.team, "losses_div", 0);
		td.rank_pts = s_get_map_real(td.team, "ranking_points", 0);
		td.rank_pts_prev = s_get_map_real(td.team, "ranking_points_prev", 0);
		td.rank_season = s_get_map_real(td.team, "ranking_points_season", 0);
		td.pct_s = s_get_pct_string(td.pct);
		td.pct_cnf_s = s_get_pct_string(td.pct_cnf);
		td.net = s_get_team_net_points(td.uid);
		td.show_cnf_stats = !s_is_independent_conference_id(ds_map_find_value(td.team, "conference"));
		of = s_get_team_offense(td.team);
		df = s_get_team_defense(td.team);
		if (obj_master.op_difficulty == 4 && td.uid != _arg1) {
			of = real(ds_map_find_value(td.team, "offense"));
			df = real(ds_map_find_value(td.team, "defense"));
		}
		td.offense_s = string_format(of / 2, 1, 1);
		td.defense_s = string_format(df / 2, 1, 1);
		td.txt_col = 16777215;
		if (_arg2) {
			s_update_team_data_rank_pos(td, _arg2, i);
		}
	}
}

function s_co_teams_tiebreak(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = false;
	}
	var res, r1, r2;
	res = s_get_head_to_head(_arg0.uid, _arg1.uid);
	if (res != 0) {
		return res;
	}
	r1 = _arg0.wins_div - _arg0.losses_div;
	r2 = _arg1.wins_div - _arg1.losses_div;
	if (r1 != r2) {
		return r2 - r1;
	}
	if (_arg2) {
		slog("*** unable to split the tie - quick mode");
		return 0;
	}
	res = s_co_teams_tiebreak_record_next_best_placed_division(_arg0, _arg1);
	if (res != 0) {
		return res;
	}
	r1 = _arg0.wins - _arg0.wins_div - (_arg0.losses - _arg0.losses_div);
	r2 = _arg1.wins - _arg1.wins_div - (_arg1.losses - _arg1.losses_div);
	if (r1 != r2) {
		return r2 - r1;
	}
	return _arg1.rank_pts - _arg0.rank_pts;
	slog("*** unable to split the tie");
	return 0;
}

function s_co_teams_tiebreak_record_next_best_placed_division(_arg0, _arg1) {
	if (_arg0.cnf_id != _arg1.cnf_id || _arg0.div_id != _arg1.div_id) {
		return 0;
	}
	var comp = s_get_competition_by_conference_division(_arg0.cnf_id, _arg0.div_id);
	s_competition_update_standings(comp.conference, comp.division, true);
	var t, r1, r2, sp = -1;
	for (var i = 0; i < array_length(comp.standings_quick); i++) {
		t = comp.standings_quick[i];
		if (_arg0.uid == t.uid || _arg1.uid == t.uid) {
			sp = i;
			break;
		}
	}
	if (sp < 0) {
		return 0;
	}
	for (var i = sp; i < array_length(comp.standings_quick); i++) {
		t = comp.standings_quick[i];
		if (_arg0.uid != t.uid && _arg1.uid != t.uid) {
			r1 = s_get_head_to_head(_arg0.uid, t.uid);
			r2 = s_get_head_to_head(_arg1.uid, t.uid);
			if (r1 != r2) {
				return r1 < r2 ? -1 : 1;
			}
		}
	}
	return 0;
}

