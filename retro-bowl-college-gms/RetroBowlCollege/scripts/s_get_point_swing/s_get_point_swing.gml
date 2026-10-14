function s_get_point_swing(_arg0, _arg1) {
	var uid1 = _arg0;
	var uid2 = _arg1;
	var wins = array_create(2, 0);
	var points = array_create(2, 0);
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
				if (team_idAway == uid1 && team_idHome == uid2) {
					points[0] += ds_map_find_value(fix, "away_score");
					points[1] += ds_map_find_value(fix, "home_score");
					if (ds_map_find_value(fix, "away_score") > ds_map_find_value(fix, "home_score")) {
						wins[0]++;
					} else if (ds_map_find_value(fix, "away_score") < ds_map_find_value(fix, "home_score")) {
						wins[1]++;
					}
				} else if (team_idAway == uid2 && team_idHome == uid1) {
					points[0] += ds_map_find_value(fix, "home_score");
					points[1] += ds_map_find_value(fix, "away_score");
					if (ds_map_find_value(fix, "away_score") > ds_map_find_value(fix, "home_score")) {
						wins[1]++;
					} else if (ds_map_find_value(fix, "away_score") < ds_map_find_value(fix, "home_score")) {
						wins[0]++;
					}
				}
			}
		}
	}
	if (wins[0] > wins[1]) {
		return -1;
	}
	if (wins[0] < wins[1]) {
		return 1;
	}
	if (points[0] > points[1]) {
		return -1;
	}
	if (points[0] < points[1]) {
		return 1;
	}
	return 0;
}

function s_get_head_to_head(_arg0, _arg1) {
	var wins = array_create(2, 0);
	var points = array_create(2, 0);
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
				if (team_idAway == _arg0 && team_idHome == _arg1) {
					if (ds_map_find_value(fix, "away_score") > ds_map_find_value(fix, "home_score")) {
						wins[0]++;
					} else if (ds_map_find_value(fix, "away_score") < ds_map_find_value(fix, "home_score")) {
						wins[1]++;
					}
				} else if (team_idAway == _arg1 && team_idHome == _arg0) {
					if (ds_map_find_value(fix, "away_score") > ds_map_find_value(fix, "home_score")) {
						wins[1]++;
					} else if (ds_map_find_value(fix, "away_score") < ds_map_find_value(fix, "home_score")) {
						wins[0]++;
					}
				}
			}
		}
	}
	if (wins[0] > wins[1]) {
		return -1;
	}
	if (wins[0] < wins[1]) {
		return 1;
	}
	return 0;
}

function s_get_win_pecentage_by_confdiv(_arg0, _arg1) {
	var wins = 0;
	var losses = 0;
	var ties = 0;
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
			if (ds_map_find_value(fix, "away_score") > -1 && (team_idAway == _arg0 || team_idHome == _arg0)) {
				var tmap1 = s_get_team_by_id(team_idAway);
				var tmap2 = s_get_team_by_id(team_idHome);
				if (ds_map_find_value(tmap1, _arg1) == ds_map_find_value(tmap2, _arg1)) {
					if (team_idAway == _arg0) {
						if (ds_map_find_value(fix, "away_score") == ds_map_find_value(fix, "home_score")) {
							ties++;
						} else if (ds_map_find_value(fix, "away_score") > ds_map_find_value(fix, "home_score")) {
							wins++;
						} else {
							losses++;
						}
					} else if (ds_map_find_value(fix, "away_score") == ds_map_find_value(fix, "home_score")) {
						ties++;
					} else if (ds_map_find_value(fix, "away_score") < ds_map_find_value(fix, "home_score")) {
						wins++;
					} else {
						losses++;
					}
				}
			}
		}
	}
	var games = wins + losses + ties;
	var winpct = (wins + ties * 0.5) / games;
	return winpct;
}

