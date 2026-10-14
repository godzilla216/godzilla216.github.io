function s_update_human_playoff_fixtures() {
	slog("s_update_human_playoff_fixtures");
	for (var f = 0; f < ds_list_size(obj_master.playoffs); f++) {
		var po_fix = ds_list_find_value(obj_master.playoffs, f);
		if (ds_map_find_value(po_fix, "away_team") == obj_master.myteam_id || ds_map_find_value(po_fix, "home_team") == obj_master.myteam_id) {
			var fixweek = real(ds_map_find_value(po_fix, "week"));
			var my_fix = s_get_human_fixture_by_week(fixweek);
			if (!my_fix) {
				s_add_to_human_fixtures(fixweek, ds_map_find_value(po_fix, "away_team"), ds_map_find_value(po_fix, "home_team"));
				s_check_rearranged_human_playoff(fixweek);
			} else {
				ds_map_set(my_fix, "away_team", ds_map_find_value(po_fix, "away_team"));
				ds_map_set(my_fix, "home_team", ds_map_find_value(po_fix, "home_team"));
				if (ds_map_find_value(my_fix, "human_win") == "unplayed") {
					s_check_rearranged_human_playoff(fixweek);
				}
			}
		}
	}
}

function s_check_rearranged_human_playoff(_arg0) {
	slog("s_check_rearranged_human_playoff: " + string(_arg0));
	for (var f = 0; f < ds_list_size(obj_master.fixturelist); f++) {
		var fix = ds_list_find_value(obj_master.fixturelist, f);
		if (fix && ds_map_find_value(fix, "week") != _arg0 && ds_map_find_value(fix, "human_win") == "unplayed") {
			var teamid_away = ds_map_find_value(fix, "away_team");
			var teamid_home = ds_map_find_value(fix, "home_team");
			slog("Destroying human fixture week: " + string(ds_map_find_value(fix, "week")));
			slog("Team " + string(teamid_away) + " @ Team " + string(teamid_home));
			ds_map_destroy(ds_list_find_value(obj_master.fixturelist, f));
			ds_list_delete(obj_master.fixturelist, f);
		}
	}
}

function s_update_human_fixtures() {
	slog("s_update_human_fixtures");
	for (var f = 0; f < ds_list_size(obj_master.schedule); f++) {
		var po_fix = ds_list_find_value(obj_master.schedule, f);
		if (ds_map_find_value(po_fix, "away_team") == obj_master.myteam_id || ds_map_find_value(po_fix, "home_team") == obj_master.myteam_id) {
			if (ds_map_find_value(po_fix, "away_score") + ds_map_find_value(po_fix, "home_score") > -1) {
				var fixweek = real(ds_map_find_value(po_fix, "week"));
				var my_fix = s_get_human_fixture_by_week(fixweek);
				if (my_fix) {
					ds_map_set(my_fix, "away_score", ds_map_find_value(po_fix, "away_score"));
					ds_map_set(my_fix, "home_score", ds_map_find_value(po_fix, "home_score"));
					ds_map_set(my_fix, "away_team", ds_map_find_value(po_fix, "away_team"));
					ds_map_set(my_fix, "home_team", ds_map_find_value(po_fix, "home_team"));
					if (ds_map_find_value(my_fix, "human_win") == "unplayed") {
						if (ds_map_find_value(po_fix, "away_score") == ds_map_find_value(po_fix, "home_score")) {
							ds_map_set(my_fix, "human_win", "tie");
						} else if (ds_map_find_value(po_fix, "away_team") == obj_master.myteam_id && ds_map_find_value(po_fix, "away_score") > ds_map_find_value(po_fix, "home_score")) {
							ds_map_set(my_fix, "human_win", "win");
						} else if (ds_map_find_value(po_fix, "home_team") == obj_master.myteam_id && ds_map_find_value(po_fix, "home_score") > ds_map_find_value(po_fix, "away_score")) {
							ds_map_set(my_fix, "human_win", "win");
						} else {
							ds_map_set(my_fix, "human_win", "loss");
						}
					}
					s_update_fixturelist_fix_extra_data(po_fix, my_fix);
				}
			}
		}
	}
}

function s_update_fixturelist_fix_extra_data(_arg0, _arg1) {
	if (s_is_co_mode()) {
		ds_map_set(_arg1, "cid", ds_map_find_value(_arg0, "cid"));
		ds_map_set(_arg1, "mid", ds_map_find_value(_arg0, "mid"));
		ds_map_set(_arg1, "cat", ds_map_find_value(_arg0, "cat"));
	}
}

