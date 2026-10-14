function s_populate_schedulebox() {
	slog("s_populate_schedulebox");
	with (inst_100254) {
		highlight = -1;
		var w = clamp(sweek, 1, obj_master.last_week_regular);
		var count = 0;
		for (var f = 0; f < 16; f++) {
			str_fix_a[f] = "";
			str_fix_h[f] = "";
			str_scr_a[f] = "";
			str_scr_h[f] = "";
			str_fix_vs[f] = "";
			str_fix_alf[f] = 0.6;
		}
		for (var f = 0; f < ds_list_size(obj_master.schedule); f++) {
			var fix = ds_list_find_value(obj_master.schedule, f);
			if (ds_map_find_value(fix, "week") == w) {
				var team_id1 = ds_map_find_value(fix, "away_team");
				var team_id2 = ds_map_find_value(fix, "home_team");
				var score1 = ds_map_find_value(fix, "away_score");
				var score2 = ds_map_find_value(fix, "home_score");
				var team_map1 = ds_list_find_value(obj_master.teamlist, team_id1);
				var team_map2 = ds_list_find_value(obj_master.teamlist, team_id2);
				var team_name1 = ds_map_find_value(team_map1, "tla");
				var team_name2 = ds_map_find_value(team_map2, "tla");
				if (is_undefined(ds_map_find_value(team_map1, "tla"))) {
					team_name1 = string(team_id1);
				}
				if (is_undefined(ds_map_find_value(team_map2, "tla"))) {
					team_name2 = string(team_id2);
				}
				var conf_1 = ds_map_find_value(team_map1, "conference");
				var conf_2 = ds_map_find_value(team_map2, "conference");
				var div_1 = ds_map_find_value(team_map1, "division");
				var div_2 = ds_map_find_value(team_map2, "division");
				str_fix_a[count] = team_name1;
				str_fix_h[count] = team_name2;
				str_scr_a[count] = "";
				str_scr_h[count] = "";
				str_fix_vs[count] = s_str("tla_At") + " ";
				str_fix_alf[count] = 0.6;
				if (conf_1 == obj_master.myconference && div_1 == obj_master.mydivision) {
					str_fix_alf[count] = 1;
				} else if (div_2 == obj_master.mydivision && conf_2 == obj_master.myconference) {
					str_fix_alf[count] = 1;
				}
				if (score1 > -1) {
					buf = 40;
					str_fix_vs[count] = "";
					str_scr_a[count] = string(score1);
					str_scr_h[count] = string(score2);
				}
				if (team_id1 == obj_master.myteam_id || team_id2 == obj_master.myteam_id) {
					highlight = count;
				}
				count++;
			}
		}
	}
}

