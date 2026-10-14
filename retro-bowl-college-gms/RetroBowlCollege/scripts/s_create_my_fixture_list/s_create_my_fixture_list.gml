function s_create_my_fixture_list() {
	slog("s_create_my_fixture_list");
	var fixlist = ds_list_create();
	for (var f = 0; f < ds_list_size(schedule); f++) {
		var fix = ds_list_find_value(schedule, f);
		var team_id1 = ds_map_find_value(fix, "away_team");
		var team_id2 = ds_map_find_value(fix, "home_team");
		if (team_id1 == myteam_id || team_id2 == myteam_id) {
			var map = ds_map_create();
			ds_map_set(map, "week", ds_map_find_value(fix, "week"));
			ds_map_set(map, "away_team", team_id1);
			ds_map_set(map, "home_team", team_id2);
			ds_map_set(map, "away_score", ds_map_find_value(fix, "away_score"));
			ds_map_set(map, "home_score", ds_map_find_value(fix, "home_score"));
			ds_map_set(map, "human_win", "unplayed");
			if (ds_map_find_value(fix, "away_score") > -1) {
				if (ds_map_find_value(fix, "away_score") == ds_map_find_value(fix, "home_score")) {
					ds_map_set(map, "human_win", "tie");
				} else if (ds_map_find_value(fix, "away_team") == myteam_id && ds_map_find_value(fix, "away_score") > ds_map_find_value(fix, "home_score")) {
					ds_map_set(map, "human_win", "win");
				} else if (ds_map_find_value(fix, "home_team") == myteam_id && ds_map_find_value(fix, "home_score") > ds_map_find_value(fix, "away_score")) {
					ds_map_set(map, "human_win", "win");
				} else {
					ds_map_set(map, "human_win", "loss");
				}
			}
			s_update_fixturelist_fix_extra_data(fix, map);
			ds_list_add(fixlist, map);
		}
	}
	return fixlist;
}

