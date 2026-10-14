function s_get_competition_id_from_fix(_arg0) {
	var conference = ds_map_find_value(_arg0, "conference");
	var division = ds_map_find_value(_arg0, "division");
	var comp;
	with (obj_master) {
		for (var i = 0; i < array_length(competitions); i++) {
			comp = competitions[i];
			if (comp.conference == conference && comp.division == division) {
				return comp.uid;
			}
		}
	}
	return -4;
}

function s_get_competition_by_conference_division(_arg0, _arg1) {
	var comp;
	with (obj_master) {
		for (var i = 0; i < array_length(competitions); i++) {
			comp = competitions[i];
			if (comp.conference == _arg0 && comp.division == _arg1) {
				return comp;
			}
		}
	}
	return -4;
}

function s_get_competition(_arg0) {
	var comp;
	with (obj_master) {
		for (var i = 0; i < array_length(competitions); i++) {
			comp = competitions[i];
			if (comp.uid == _arg0) {
				return comp;
			}
		}
	}
	return -4;
}

function s_get_competitions_in_editor_group(_arg0) {
	var comps = [];
	var comp;
	with (obj_master) {
		for (var i = 0; i < array_length(competitions); i++) {
			comp = competitions[i];
			if (comp.editor_group == _arg0 && real(comp.active)) {
				array_push(comps, comp);
			}
		}
	}
	return comps;
}

function s_get_last_schedule_week() {
	var last_week = 0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(schedule); i++) {
			last_week = max(real(ds_map_find_value(ds_list_find_value(schedule, i), "week")), last_week);
		}
	}
	return last_week;
}

function s_get_postseason_fixture_by_week(_arg0) {
	with (obj_master) {
		var fix;
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			if (ds_map_find_value(fix, "week") == _arg0 && ds_map_find_value(fix, "show") == 1) {
				return fix;
			}
		}
	}
	return -4;
}

function s_get_player_schedule_fixture_by_week(_arg0) {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			if (real(ds_map_find_value(fix, "week")) == _arg0 && s_is_human_fix(fix)) {
				return fix;
			}
		}
	}
	return -4;
}

function s_get_competition_win_access_list() {
	var comp, src;
	var list = [];
	with (obj_master) {
		for (var i = 0; i < array_length(competitions); i++) {
			comp = competitions[i];
			for (var s = 0; s < 2; s++) {
				src = s_get_tagged_source(s ? comp.src1 : comp.src2);
				if (src != -4 && src.tag == "tm" && src.source == "c_win") {
					array_push(list, { uid: real(src.key), access: real(comp.uid) });
				}
			}
		}
	}
	return list;
}

function s_schedule_generation(_arg0, _arg1, _arg2) {
	if (_arg0 == -4) {
		slogf("No competition to generate schedule for");
		return;
	}
	if (is_string(_arg0.cycle) && _arg0.cycle != "") {
		if (!s_is_cyclic_competition_year(_arg0.cycle, _arg2)) {
			slogf("Competition cycle %1 not in %2", _arg0.cycle, _arg2);
			return;
		}
	}
	slogf("Generating Schedule for %1 (%2)", _arg0.name, _arg0.uid);
	switch (_arg0.type) {
		case "tb":
			slogf("competition schedule has already been read from file");
			break;
		case "ch":
			slogf("adding championship %2 via scheme: %1", _arg0.scheme, _arg0.name);
			s_schedule_add_championship(_arg0, _arg1);
			break;
		case "gm":
			slogf("adding single game info schedule");
			s_schedule_add_game(_arg0, _arg1);
			break;
	}
}

function s_is_cyclic_competition_year(_arg0, _arg1) {
	var cc = string_split(_arg0, ",");
	if (array_length(cc) < 2) {
		return false;
	}
	if ((_arg1 - 1) mod real(cc[1]) == real(cc[0]) - 1) {
		return true;
	}
	return false;
}

function s_schedule_add_game(_arg0, _arg1) {
	var week = real(_arg0.time);
	var away_id = s_get_team_from_tag(_arg0.src1, _arg1, 1);
	var home_id = s_get_team_from_tag(_arg0.src2, _arg1, 1);
	if (away_id != -4 && home_id != -4) {
		var fix = s_get_schedule_fix_template();
		ds_map_set(fix, "cid", _arg0.uid);
		ds_map_set(fix, "week", week);
		ds_map_set(fix, "seed_time", _arg0.seed_time);
		ds_map_set(fix, "cat", _arg0.cat);
		ds_map_set(fix, "away_team", away_id);
		ds_map_set(fix, "home_team", home_id);
		ds_map_set(fix, "away_src", _arg0.src1);
		ds_map_set(fix, "home_src", _arg0.src2);
		ds_map_set(fix, "show", _arg0.show);
		ds_map_set(fix, "notify", _arg0.notify);
		ds_map_set(fix, "reputation", _arg0.reputation);
		ds_map_set(fix, "history_rec", _arg0.history_rec);
		ds_map_set(fix, "victory_show", _arg0.victory_show);
		ds_map_set(fix, "reward", _arg0.reward);
		ds_list_add(_arg1, fix);
	}
}

function s_schedule_add_championship(_arg0, _arg1) {
	var rd, away_id, home_id;
	for (var i = 0; i < array_length(obj_master.rounds); i++) {
		rd = obj_master.rounds[i];
		if (rd.scheme == _arg0.scheme) {
			away_id = s_get_team_from_tag(rd.src1, _arg1, 1);
			home_id = s_get_team_from_tag(rd.src2, _arg1, 1);
			if (away_id != -4 && home_id != -4) {
				var fix = s_get_schedule_fix_template();
				ds_map_set(fix, "cid", _arg0.uid);
				ds_map_set(fix, "mid", rd.mid);
				ds_map_set(fix, "cat", rd.cat);
				ds_map_set(fix, "week", rd.time);
				ds_map_set(fix, "seed_time", _arg0.seed_time);
				ds_map_set(fix, "away_team", away_id);
				ds_map_set(fix, "home_team", home_id);
				ds_map_set(fix, "away_src", rd.src1);
				ds_map_set(fix, "home_src", rd.src2);
				ds_map_set(fix, "show", rd.show);
				ds_map_set(fix, "notify", rd.notify);
				ds_map_set(fix, "reputation", rd.reputation);
				ds_map_set(fix, "history_rec", rd.history_rec);
				ds_map_set(fix, "victory_show", rd.victory_show);
				ds_map_set(fix, "reward", rd.reward);
				ds_list_add(_arg1, fix);
			}
		}
	}
}

function s_get_schedule_fix_template() {
	var fix = ds_map_create();
	ds_map_set(fix, "cid", -1);
	ds_map_set(fix, "mid", "");
	ds_map_set(fix, "year", 1);
	ds_map_set(fix, "week", 1);
	ds_map_set(fix, "seed_time", 0);
	ds_map_set(fix, "cat", "");
	ds_map_set(fix, "away_team", -1);
	ds_map_set(fix, "home_team", -1);
	ds_map_set(fix, "away_score", -1);
	ds_map_set(fix, "home_score", -1);
	ds_map_set(fix, "away_src", "");
	ds_map_set(fix, "home_src", "");
	ds_map_set(fix, "human_win", "unplayed");
	ds_map_set(fix, "show", "std");
	ds_map_set(fix, "notify", "none");
	ds_map_set(fix, "history_rec", "none");
	ds_map_set(fix, "victory_show", "none");
	ds_map_set(fix, "reward", "none");
	return fix;
}

function s_fixture_victory_screen(_arg0, _arg1) {
	if (ds_map_exists(_arg0, "victory_show") && _arg1 == "win") {
		return ds_map_find_value(fix, "victory_show");
	}
	return "none";
}

function s_handle_fixture_notification(_arg0, _arg1) {
	var fix = _arg0;
	slog_map("s_handle_fixture_notification[" + _arg1 + "]", fix);
	if (_arg1 == "win" && (ds_map_find_value(fix, "notify") == "cv_w" || ds_map_find_value(fix, "notify") == "cv_wl")) {
		s_fixture_notifications_roster_cv_entry(fix, _arg1, "cv_WinComp");
		return true;
	}
	if (_arg1 == "loss" && (ds_map_find_value(fix, "notify") == "cv_l" || ds_map_find_value(fix, "notify") == "cv_wl")) {
		s_fixture_notifications_roster_cv_entry(fix, _arg1, "cv_RunnerUpComp");
	}
	if (_arg1 == "loss" && ds_map_find_value(fix, "notify") == "cv_r") {
		var level = array_get(string_split(ds_map_find_value(fix, "mid"), "."), 0);
		var cv_key = "cv_ReachedCompRound" + level;
		s_fixture_notifications_roster_cv_entry(fix, _arg1, cv_key);
	}
	return false;
}

function s_fixture_notifications_roster_cv_entry(_arg0, _arg1, _arg2) {
	for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		if (s_college_academics_type("Military")) {
			_arg2 = "cvMilitary_" + string_delete(_arg2, 1, 3);
		}
		var award_txt = s_str(s_get_random_cv_entry(pmap, _arg2));
		award_txt = s_parse_player_message(award_txt, pmap);
		var comp = s_get_competition(ds_map_find_value(_arg0, "cid"));
		award_txt = string_replace_all(award_txt, "$compname", comp.name);
		s_add_cv_entry_direct(pmap, award_txt);
	}
}

function s_handle_fixture_history_record(_arg0, _arg1) {
	var fix = _arg0;
	slog_map("s_handle_fixture_history_record[" + _arg1 + "]", fix);
	var comp = s_get_competition(ds_map_find_value(fix, "cid"));
	if (_arg1 == "win" && ds_map_find_value(fix, "history_rec") == "h_confCh") {
		obj_master.rec_conf_champ_wins += 1;
		s_update_history_won_championship(ds_map_find_value(fix, "cid"));
	}
	if (_arg1 == "win" && ds_map_find_value(fix, "history_rec") == "h_bowl") {
		obj_master.rec_bowl_wins += 1;
	}
	if (_arg1 == "win" && ds_map_find_value(fix, "history_rec") == "h_champ") {
		obj_master.rec_champ_wins += 1;
		var FBSrank = s_subdivision_get_player_ranking(1);
		if (FBSrank == -1) {
			s_complete_achievement("ACH_WIN_MINOR_SUB");
		} else {
			s_complete_achievement("ACH_WIN_MAJOR_SUB");
		}
	}
	if (ds_map_find_value(fix, "history_rec") == "h_champ") {
		s_update_history_subdivisional_champ_finals(_arg1);
	}
	if (_arg1 == "win" && (ds_map_find_value(fix, "history_rec") == "h_bowl" || ds_map_find_value(fix, "history_rec") == "h_bowl_nr")) {
		s_update_history_won_bowl(ds_map_find_value(fix, "cid"));
		s_complete_achievement("ACH_WIN_ANY_BOWL");
	}
	if (_arg1 == "loss" && ds_map_find_value(fix, "history_rec") == "h_round" && ds_map_exists(fix, "mid")) {
		var level = array_get(string_split(ds_map_find_value(fix, "mid"), "."), 0);
		if (level != -4 && level != "" && string_length(level) > 0) {
			s_update_history_reached_playoffs_round(level);
		}
	}
}

function s_handle_fixture_reward(_arg0, _arg1) {
	var fix = _arg0;
	if (_arg1 != "win") {
		return;
	}
	var reward = ds_map_find_value(fix, "reward");
	if (string_length(reward) < 2) {
		return;
	}
	var prefix = string_copy(reward, 1, 2);
	if (prefix == "rc" || prefix == "cc") {
		var msg = "";
		if (prefix == "rc") {
			msg = s_str("news_CompWinRC");
		}
		if (prefix == "cc") {
			msg = s_str("news_CompWinCC");
		}
		var number = string_copy(reward, 3, string_length(reward) - 2);
		var origReward = real(number);
		var finalReward = origReward;
		if (prefix == "rc") {
			if (can_fit_recruitment_credits(origReward) == false) {
				var rc_space = recruitment_credits_space();
				finalReward = rc_space;
				msg = s_str("news_CompWinRC_NoSpace");
				msg = string_replace(msg, "$actualNum", string(finalReward));
			}
		}
		var roundLabel = "";
		if (ds_map_exists(fix, "mid") && string_length(ds_map_find_value(fix, "mid")) > 0) {
			slog("roundLabel a: " + ds_map_find_value(fix, "mid"));
			var lvl = array_get(string_split(ds_map_find_value(fix, "mid"), "."), 0);
			slog("roundLabel b: " + lvl);
			roundLabel = " " + s_get_comp_level_str_plain(lvl);
			slog("roundLabel c: " + roundLabel);
		} else {
			var comp = s_get_competition(ds_map_find_value(fix, "cid"));
			slog("No MID for comp " + string(ds_map_find_value(fix, "cid")) + " comp.name: " + comp.name);
		}
		var comp = s_get_competition(ds_map_find_value(fix, "cid"));
		msg = string_replace(msg, "$compname", comp.name + roundLabel);
		msg = string_replace(msg, "$num", string(origReward));
		s_add_news(msg);
		if (prefix == "rc") {
			recruitment_credits_add(finalReward);
		}
		if (prefix == "cc") {
			obj_master.coach_credit += finalReward;
		}
	}
}

function s_reset_competitions_and_subdivisions_pools_and_rankings() {
	with (global.g_m) {
		subdiv_data = [{}, { rankings: [], rankings_week: 0, rankings_week_done: 0, prestige_pool: [] }, { rankings: [], rankings_week: 0, rankings_week_done: 0 }];
		var i;
		if (variable_instance_exists(global.g_m, "competitions")) {
			for (i = 0; i < array_length(competitions); i++) {
				competitions[i].pool = -4;
				s_competition_reset_standings(competitions[i]);
			}
		}
		if (variable_instance_exists(global.g_m, "conferences")) {
			for (i = 0; i < array_length(conferences); i++) {
				s_conference_reset_standings(conferences[i]);
			}
		}
	}
}

function s_competitions_status_update() {
	if (!s_is_co_mode()) {
		return;
	}
	if (!variable_instance_exists(obj_master, "competitions")) {
		slog("*** WARNING: competitions data missing");
		return;
	}
	s_update_week_done();
	s_debug_start_time();
	slogf("*** competitions status update - year %1 week %2", obj_master.year, obj_master.week);
	s_competitions_update_quick_standings();
	s_debug_show_time();
	s_subdivision_update_rankings(1);
	s_subdivision_update_rankings(2);
	s_debug_show_time();
	s_schedule_advance_teams();
	s_prestige_pool_list();
	s_debug_show_time();
	s_update_human_postseason_fixtures();
	slog("1.s_competitions_status_update");
	if (s_season_competitions_done()) {
		slog("2.s_season_competitions_done");
		s_do_player_awards_college();
	}
	slogf("*** competitions status update complete - year %1 week %2", obj_master.year, obj_master.week);
}

function s_competitions_update_quick_standings() {
	var comp;
	with (obj_master) {
		for (var i = 0; i < array_length(competitions); i++) {
			comp = competitions[i];
			if (comp.conference != "" && comp.division != "") {
				s_competition_update_standings(comp.conference, comp.division, true);
			}
		}
	}
}

function s_resolve_non_champ_conferences() {
	if (!s_is_co_mode()) {
		return false;
	}
	if (obj_master.non_champ_conferences_resolved == true) {
		return;
	}
	if (obj_master.week > obj_master.last_week_regular) {
		var my_confId = ds_map_find_value(obj_master.myteam, "conference");
		slog("s_resolve_non_champ_conferences. my_confId[" + string(my_confId) + "]");
		var conf = s_get_conference_data(my_confId);
		if (conf.completion == "end_season") {
			var final_pos = s_get_my_conference_current_place();
			slog("s_resolve_non_champ_conferences - end_season completion. Position in rank:[" + string(final_pos) + "]");
			if (final_pos == 0) {
				slog("Player at the top of his champ-less division, award results");
				var cv_key = "cv_WinComp";
				for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
					var pmap = ds_list_find_value(obj_master.roster, i);
					if (s_college_academics_type("Military")) {
						cv_key = "cvMilitary_" + string_delete(cv_key, 1, 3);
					}
					var award_txt = s_str(s_get_random_cv_entry(pmap, cv_key));
					award_txt = s_parse_player_message(award_txt, pmap);
					award_txt = string_replace_all(award_txt, "$compname", conf.name);
					s_add_cv_entry_direct(pmap, award_txt);
				}
				s_show_rm_winners(0, -1, "v_bronze", conf.name, btn_click_Home, true);
			}
		}
		obj_master.non_champ_conferences_resolved = true;
	}
}

function s_schedule_advance_teams(_arg0, _arg1, _arg2) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.schedule;
	}
	if (_arg1 == undefined) {
		_arg1 = 1;
	}
	if (_arg2 == undefined) {
		_arg2 = 4;
	}
	for (var loop = _arg1; loop <= _arg2; loop++) {
		slogf("\n*** schedule advance teams - loop %1", loop);
		var fix, tag, tid, st, comp;
		var tags = [];
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			fix = ds_list_find_value(_arg0, i);
			if (!s_is_fix_filled(fix)) {
				st = s_get_map_real(fix, "seed_time", -1);
				if (st < 0) {
					comp = s_get_competition(ds_map_find_value(fix, "cid"));
					st = comp == -4 ? 0 : comp.seed_time;
				}
				if (st > obj_master.week) {
					continue;
				}
				slogf("match %1 week %6 not filled: %2 v %3 - source %4 v %5", ds_map_find_value(fix, "cid"), ds_map_find_value(fix, "away_team"), ds_map_find_value(fix, "home_team"), ds_map_find_value(fix, "away_src"), ds_map_find_value(fix, "home_src"), ds_map_find_value(fix, "week"));
				if (ds_map_find_value(fix, "away_team") == -1) {
					s_schedule_add_fixtag(tags, fix, ds_map_find_value(fix, "away_src"), "away");
				}
				if (ds_map_find_value(fix, "home_team") == -1) {
					s_schedule_add_fixtag(tags, fix, ds_map_find_value(fix, "home_src"), "home");
				}
			}
		}
		array_sort(tags, s_fixtag_sort_priority);
		for (var i = 0; i < array_length(tags); i++) {
			tag = tags[i];
			tid = s_get_team_from_tag(ds_map_find_value(tag.fix, tag.label + "_src"), undefined, loop, tag.fix);
			if (tid != -4 && tid > -1) {
				ds_map_set(tag.fix, tag.label + "_team", tid);
				slogf("%1 team %2 seeded for match %3 week %4 (tag %5 loop %6)", tag.label, tid, ds_map_find_value(tag.fix, "cid"), ds_map_find_value(tag.fix, "week"), tag.tag, loop);
				s_schedule_move_better_team_to_home_slot(tag.fix);
			}
		}
	}
}

function s_schedule_move_better_team_to_home_slot(_arg0) {
	if (!s_is_fix_filled(_arg0)) {
		return;
	}
	if (!s_is_fix_on_neutral_ground(_arg0)) {
		return;
	}
	var swap = false;
	var at = s_get_map_real(_arg0, "away_team", -1);
	var ht = s_get_map_real(_arg0, "home_team", -1);
	var as = s_get_subdivision(at);
	var hs = s_get_subdivision(ht);
	if (as != hs && as == 1) {
		swap = true;
	}
	var ar = s_get_ranking_pos_data(at).pos;
	var hr = s_get_ranking_pos_data(ht).pos;
	if (as == hs && ar < hr) {
		swap = true;
	}
	if (swap) {
		slogf("swapping %1 t:%2.%3 and %4 t:%5.%6", ds_map_find_value(at, "name"), as, ar, ds_map_find_value(ht, "name"), hs, hr);
		s_map_swap(_arg0, "home_team", "away_team");
		s_map_swap(_arg0, "home_src", "away_src");
	}
}

function s_schedule_add_fixtag(_arg0, _arg1, _arg2, _arg3) {
	var fixtag = { fix: _arg1, tag: _arg2, label: _arg3, priority: s_get_fixtag_priority(_arg1, _arg2) };
	array_push(_arg0, fixtag);
}

function s_get_fixtag_priority(_arg0, _arg1) {
	var tp;
	if (string_pos(":bowl:", _arg1) != 0) {
		tp = 4;
	} else if (string_pos(":pbowl:", _arg1) != 0) {
		tp = string_pos("-1", _arg1) != 0 ? 3 : 2;
	} else {
		tp = 1;
	}
	return real(ds_map_find_value(_arg0, "cid")) + tp * 100000;
}

function s_fixtag_sort_priority(_arg0, _arg1) {
	return real(_arg0.priority) - real(_arg1.priority);
}

function s_competition_update_standings(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = false;
	}
	var comp = s_get_competition_by_conference_division(_arg0, _arg1);
	if (!_arg2 && variable_instance_exists(comp, "standings_week") && comp.standings_week == obj_master.week) {
		return;
	}
	if (_arg2 && variable_instance_exists(comp, "standings_week_quick") && (comp.standings_week_quick == obj_master.week || comp.standings_week_quick > obj_master.last_week_regular)) {
		return;
	}
	slogf("Updating standings: %1 (%2.%3) week %4 - %5 mode", comp.uid, comp.conference, comp.division, obj_master.week, _arg2 ? "quick" : "standard");
	var teams = s_get_team_list(comp.conference, comp.division);
	if (_arg2) {
		comp.standings_quick = s_create_team_data_array(teams);
		array_sort(comp.standings_quick, s_co_teams_data_sort_pct_quick);
		comp.standings_week_quick = obj_master.week;
	} else {
		comp.standings = s_create_team_data_array(teams);
		array_sort(comp.standings, s_co_teams_data_sort_pct);
		comp.standings_week = obj_master.week;
	}
}

function s_competition_reset_standings(_arg0) {
	_arg0.standings = [];
	_arg0.standings_week = 0;
	_arg0.standings_quick = [];
	_arg0.standings_week_quick = 0;
}

function s_conference_update_standings(_arg0) {
	if (variable_instance_exists(_arg0, "standings_week") && _arg0.standings_week == obj_master.week) {
		return;
	}
	slogf("conference %1 week %2", _arg0.uid, obj_master.week);
	var teams = s_get_team_list(_arg0.uid);
	_arg0.standings = s_create_team_data_array(teams);
	array_sort(_arg0.standings, s_co_teams_data_sort_pct);
	_arg0.standings_week = obj_master.week;
}

function s_subdivision_update_rankings(_arg0, _arg1, _arg2) {
	if (_arg1 == undefined) {
		_arg1 = false;
	}
	if (_arg2 == undefined) {
		_arg2 = false;
	}
	with (obj_master) {
		if (!s_is_co_mode()) {
			return;
		}
		if (variable_instance_exists(id, "subdiv_data") && subdiv_data[_arg0].rankings_week > obj_master.last_week_regular + obj_master.extra_weeks_endofseason && !_arg2) {
			return;
		}
		if (subdiv_data[_arg0].rankings_week == obj_master.week && subdiv_data[_arg0].rankings_week_done == s_is_week_done() && !_arg2) {
			return;
		}
		var _subdiv = subdiv_data[_arg0];
		slogf("*** Updating rankings subdivision %1 week %2 (%3) week done %4", _arg0, week, _arg1 ? "Q" : "F", s_is_week_done());
		var teams = s_get_team_list_by_tier(_arg0);
		_subdiv.rankings = s_create_team_data_array(teams);
		slogf("%1 teams in subdiv", array_length(teams));
		var sorting_method = s_co_teams_data_sort_rank;
		if (_arg1) {
			sorting_method = s_co_teams_data_sort_rank_quick;
		} else if (s_is_co_actual_postseason()) {
			sorting_method = s_co_teams_data_sort_rank_season;
		}
		array_sort(_subdiv.rankings, sorting_method);
		if (!_arg1 || year == 1 && week == s_get_skip_to_week()) {
			s_update_ranking_positions(_arg0, week);
		}
		if (!_arg1) {
			_subdiv.rankings_week = week;
			_subdiv.rankings_week_done = s_is_week_done();
		}
	}
}

function s_conference_reset_standings(_arg0) {
	_arg0.standings = [];
	_arg0.standings_week = 0;
}

function s_subdivision_get_player_ranking(_arg0) {
	return s_subdivision_get_team_ranking(_arg0, obj_master.myteam_id);
}

function s_subdivision_get_team_ranking(_arg0, _arg1) {
	with (obj_master) {
		s_subdivision_update_rankings(_arg0);
		with (obj_master.subdiv_data[_arg0]) {
			for (var i = 0; i < array_length(rankings); i++) {
				if (rankings[i].uid == _arg1) {
					return i;
				}
			}
		}
	}
	return -1;
}

function s_get_my_conference_current_place() {
	var my_conf = ds_map_find_value(obj_master.myteam, "conference");
	var my_div = ds_map_find_value(obj_master.myteam, "division");
	var comp = s_get_competition_by_conference_division(my_conf, my_div);
	s_competition_update_standings(comp.conference, comp.division);
	if (is_undefined(comp.standings) || !is_array(comp.standings)) {
		return -1;
	}
	for (var i = 0; i < array_length(comp.standings); i++) {
		if (comp.standings[i].uid == obj_master.myteam_id) {
			return i;
		}
	}
	return -1;
}

function s_update_human_postseason_fixtures() {
	if (!s_is_co_mode()) {
		return;
	}
	slog("s_update_human_postseason_fixtures");
	var fix, hfix, week;
	for (var f = 0; f < ds_list_size(obj_master.schedule); f++) {
		fix = ds_list_find_value(obj_master.schedule, f);
		if (ds_map_find_value(fix, "away_team") == obj_master.myteam_id || ds_map_find_value(fix, "home_team") == obj_master.myteam_id) {
			week = real(ds_map_find_value(fix, "week"));
			hfix = s_get_human_fixture_by_week(week);
			if (hfix == -4) {
				slogf("*** human postseason match copy - week: %1 : %2 vs %3", week, ds_map_find_value(fix, "away_team"), ds_map_find_value(fix, "home_team"));
				s_add_to_human_fixtures(week, ds_map_find_value(fix, "away_team"), ds_map_find_value(fix, "home_team"));
			} else if (ds_map_find_value(hfix, "away_team") == -1 || ds_map_find_value(hfix, "home_team") == -1) {
				slogf("*** human postseason match update - week: %1 : %2 vs %3", week, ds_map_find_value(hfix, "away_team"), ds_map_find_value(hfix, "home_team"));
				ds_map_set(hfix, "away_team", ds_map_find_value(fix, "away_team"));
				ds_map_set(hfix, "home_team", ds_map_find_value(fix, "home_team"));
			}
		}
	}
}

