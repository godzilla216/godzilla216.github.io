function s_co_set_starting_rank(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	var of = s_get_team_offense_with_reputation_boost(_arg0);
	var df = s_get_team_defense_with_reputation_boost(_arg0);
	var rp = (df + of) * 5 + irandom_range(-2, 2);
	if (of + df > 16) {
		rp = 65 + (df + of) + irandom_range(-1, 2);
	}
	if (s_get_prestige(_arg0) == 2) {
		rp -= 10;
	}
	s_co_set_ranking_points(_arg0, rp);
	slogf("Team: %1 RP: %2", ds_map_find_value(_arg0, "name"), rp);
}

function s_co_set_ranking_points(_arg0, _arg1) {
	ds_map_set(_arg0, "ranking_points", _arg1);
	ds_map_set(_arg0, "ranking_points_prev", _arg1);
	ds_map_set(_arg0, "ranking_points_season", _arg1);
}

function s_co_reset_teams_rank() {
	if (!s_is_co_mode()) {
		return;
	}
	with (obj_master) {
		slogf("College: Reset teams ranking %1 to %2", min_team_id, max_team_id);
		for (var i = min_team_id; i <= max_team_id; i++) {
			s_co_set_starting_rank(ds_list_find_value(teamlist, i));
		}
	}
}

function s_co_update_fix_rank(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	if (_arg0 == -4) {
		return;
	}
	var tw_rc, tl_rc;
	var tw = s_get_team_by_id(ds_map_find_value(_arg0, "away_team"));
	var tl = s_get_team_by_id(ds_map_find_value(_arg0, "home_team"));
	if (real(ds_map_find_value(_arg0, "away_score")) < real(ds_map_find_value(_arg0, "home_score"))) {
		var tt = tl;
		tl = tw;
		tw = tt;
	}
	var tw_od = s_get_team_offense_with_reputation_boost(tw) + s_get_team_defense_with_reputation_boost(tw);
	var tl_od = s_get_team_offense_with_reputation_boost(tl) + s_get_team_defense_with_reputation_boost(tl);
	tw_rc = tl_od;
	tl_rc = tw_od;
	if (s_get_prestige(tw) == 1 && s_get_prestige(tl) != 1) {
		tl_rc -= 31;
	} else if (s_get_prestige(tw) == 2 && s_get_prestige(tl) == 3) {
		tl_rc -= 24;
	} else {
		tl_rc -= 21;
	}
	if (s_get_prestige(tw) != 2 && s_get_prestige(tl) == 2) {
		tw_rc = max(tw_rc, 5);
	}
	if (s_get_map_real(tl, "wins", 0) + s_get_map_real(tl, "losses", 0) <= 1) {
		tl_rc -= 10;
	}
	if (tw == global.g_m.myteam && s_get_ranking_pos_data(tw).pos < 25) {
		tl_rc = max(tl_rc, -10);
	}
	ds_map_set(tw, "ranking_points_prev", ds_map_find_value(tw, "ranking_points"));
	ds_map_set(tl, "ranking_points_prev", ds_map_find_value(tl, "ranking_points"));
	ds_map_set(tw, "ranking_points", ds_map_find_value(tw, "ranking_points") + tw_rc);
	ds_map_set(tl, "ranking_points", ds_map_find_value(tl, "ranking_points") + tl_rc);
	if (ds_map_find_value(tw, "ranking") <= 25 || ds_map_find_value(tl, "ranking") <= 25) {
		if (abs(ds_map_find_value(tw, "ranking_points") - ds_map_find_value(tl, "ranking_points")) < 5 || ds_map_find_value(tw, "ranking") + 1 == ds_map_find_value(tl, "ranking")) {
			if (ds_map_find_value(tw, "ranking_points") < ds_map_find_value(tl, "ranking_points")) {
				ds_map_set(tl, "ranking_points", ds_map_find_value(tw, "ranking_points"));
				ds_map_set(tw, "ranking_points", ds_map_find_value(tl, "ranking_points") + 1);
			}
		}
	}
	if (real(ds_map_find_value(_arg0, "week")) < obj_master.first_week_postseason + obj_master.extra_weeks_endofseason) {
		slogf("updating season team's ranking - week %1", ds_map_find_value(_arg0, "week"));
		ds_map_set(tw, "ranking_points_season", ds_map_find_value(tw, "ranking_points"));
		ds_map_set(tl, "ranking_points_season", ds_map_find_value(tl, "ranking_points"));
	}
	if (real(ds_map_find_value(_arg0, "week")) == s_get_last_schedule_week()) {
		switch (ds_map_find_value(_arg0, "cat")) {
			case "f":
				ds_map_set(tw, "ranking_points", ds_map_find_value(tw, "ranking_points") + 2000);
				ds_map_set(tl, "ranking_points", ds_map_find_value(tl, "ranking_points") + 1000);
				break;
		}
	}
}

function s_get_prestige(_arg0) {
	var conference = s_get_struct_in_array_by_uid(obj_master.conferences, ds_map_find_value(_arg0, "conference"));
	if (conference) {
		return real(conference.prestige);
	}
	return -1;
}

function s_update_ranking_positions(_arg0, _arg1) {
	slogf("Update ranking positions");
	var _subdiv = obj_master.subdiv_data[_arg0];
	var td, rpd, rpsd;
	for (var i = 0; i < array_length(_subdiv.rankings); i++) {
		td = _subdiv.rankings[i];
		rpd = s_get_ranking_pos_data(td.team);
		if (_arg1 == 1 || rpd.week > _arg1) {
			ds_map_set(td.team, "ranking_pos_prev", 0);
			ds_map_set(td.team, "ranking_pos_season", 0);
			ds_map_set(td.team, "ranking_pos", s_encode_ranking_pos(i + 1, _arg1));
		} else if (rpd.week < _arg1) {
			ds_map_set(td.team, "ranking_pos_prev", s_encode_ranking_pos(rpd.pos, rpd.week));
			ds_map_set(td.team, "ranking_pos", s_encode_ranking_pos(i + 1, _arg1));
		}
		if (_arg1 == obj_master.last_week_regular + obj_master.extra_weeks_endofseason) {
			rpsd = s_parse_ranking_pos(s_get_map_real(td.team, "ranking_pos_season", 0));
			if (rpsd.week == 0) {
				slogf("*** ranking pos season team %1 pos %2", td.uid, i + 1);
				ds_map_set(td.team, "ranking_pos_season", s_encode_ranking_pos(i + 1, _arg1));
			}
		}
		s_update_team_data_rank_pos(td);
	}
}

function s_get_ranking_pos_data(_arg0) {
	return s_parse_ranking_pos(s_get_map_real(_arg0, "ranking_pos", 0));
}

function s_get_ranking_pos_data_prev(_arg0) {
	return s_parse_ranking_pos(s_get_map_real(_arg0, "ranking_pos_prev", 0));
}

function s_parse_ranking_pos(_arg0) {
	return { week: round((_arg0 - floor(_arg0)) * 100), pos: floor(_arg0) };
}

function s_encode_ranking_pos(_arg0, _arg1) {
	return _arg0 + _arg1 / 100;
}

function s_save_ranking_pos_end_of_season() {
	with (global.g_m) {
		ds_map_set(myteam, "rank_last_season", s_get_ranking_pos_data(myteam).pos);
		slogf("*** SAVE LAST SEASON RANK FOR MY TEAM\nranking pos: %1", ds_map_find_value(myteam, "rank_last_season"));
	}
}

function s_get_ranking_pos_last_season() {
	return s_get_map_real(global.g_m.myteam, "rank_last_season", 0);
}

function s_is_preseason_for_ranking() {
	if (!s_is_co_mode() || global.g_m.year == 1) {
		return false;
	}
	if (global.g_m.week == 1 && global.g_m.college_admissions_draft_round > 0) {
		return true;
	}
	return false;
}

function s_update_rank_after_adminssion_draft() {
	var tm = global.g_m.myteam;
	var starting_pts = s_get_map_real(tm, "ranking_points", 0);
	s_get_team_offense(tm);
	s_get_team_defense(tm);
	s_co_set_starting_rank(tm);
	var postdraft_pts = s_get_map_real(tm, "ranking_points", 0);
	var generosity_fallback_pts = 71 - s_get_ranking_pos_last_season();
	s_co_set_ranking_points(tm, max(postdraft_pts, generosity_fallback_pts));
	slogf("*** User team ranking points updated after the admission draft");
	slogf("start pts: %1 post draft pts: %2 generosity fallback pts: %3", starting_pts, postdraft_pts, generosity_fallback_pts);
	s_subdivision_update_rankings(s_get_subdivision(tm), true, true);
}

