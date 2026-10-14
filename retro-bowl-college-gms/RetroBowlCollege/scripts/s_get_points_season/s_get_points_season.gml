function s_get_points_season(_arg0) {
	var points = 0;
	with (obj_master) {
		for (var f = 0; f < ds_list_size(schedule); f++) {
			var fix = ds_list_find_value(schedule, f);
			if (!ds_exists(fix, 1)) {
				return 0;
			}
			if (!ds_map_exists(fix, "away_team")) {
				return 0;
			}
			if (!ds_map_exists(fix, "home_team")) {
				return 0;
			}
			var team_idAway = real(ds_map_find_value(fix, "away_team"));
			var team_idHome = real(ds_map_find_value(fix, "home_team"));
			if (ds_map_find_value(fix, "away_score") > -1) {
				if (team_idAway == _arg0) {
					points += ds_map_find_value(fix, "away_score");
				} else if (team_idHome == _arg0) {
					points += ds_map_find_value(fix, "home_score");
				}
			}
		}
	}
	return points;
}

