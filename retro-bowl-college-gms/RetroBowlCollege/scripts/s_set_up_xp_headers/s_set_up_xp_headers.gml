function s_set_up_xp_headers(_arg0, _arg1) {
	slog("s_set_up_xp_headers(show_skills:" + string(_arg0) + ", show_xp:" + string(_arg1) + ")");
	if (_arg0) {
		ds_list_add(l_attitude, s_str("tla_Attitude"));
		ds_list_add(l_names, s_str("ui_Name"));
		ds_list_add(l_pos, s_str("tla_Position"));
		ds_list_add(l_condition, s_str("tla_Condition"));
		ds_list_add(l_resting, "");
		ds_list_add(l_yards, s_str("tla_Skill"));
		ds_list_add(l_tds, s_str("tla_Strength"));
		ds_list_add(l_tackles, s_str("tla_Speed"));
		ds_list_add(l_intsacks, s_str("tla_Stamina"));
		if (s_is_co_mode()) {
			ds_list_add(l_suspended, "");
		}
		if (obj_master.qb_mode) {
			ds_list_add(l_fumbles, 0);
		} else {
			ds_list_add(l_fumbles, s_str("tla_Salary"));
		}
		ds_list_add(l_rating, s_str("tla_Contract"));
		if (_arg1) {
			ds_list_add(l_xp, "+" + s_str("ui_XP"));
			ds_list_add(l_levelup, s_str("short_LevelUp"));
		} else {
			if (s_is_co_mode()) {
				ds_list_add(l_xp, s_str("ui_Year_Short"));
			} else {
				ds_list_add(l_xp, s_str("tla_Age"));
			}
			ds_list_add(l_levelup, s_str("short_LevelXP"));
		}
		if (s_is_co_mode()) {
			ds_list_add(l_gpa, s_str("ui_GPA"));
			ds_list_add(l_gpa_col, 16777215);
		}
		for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
			var pmap = ds_list_find_value(obj_master.roster, i);
			ds_list_add(l_attitude, ds_map_find_value(pmap, "attitude"));
			ds_list_add(l_names, s_get_player_name(pmap, true));
			ds_list_add(l_pos, ds_map_find_value(pmap, "position"));
			ds_list_add(l_condition, ds_map_find_value(pmap, "condition"));
			ds_list_add(l_resting, ds_map_find_value(pmap, "resting"));
			ds_list_add(l_yards, ds_map_find_value(pmap, "skill"));
			ds_list_add(l_tds, ds_map_find_value(pmap, "strength"));
			ds_list_add(l_tackles, ds_map_find_value(pmap, "speed"));
			ds_list_add(l_intsacks, ds_map_find_value(pmap, "stamina"));
			if (s_is_co_mode()) {
				ds_list_add(l_suspended, ds_map_find_value(pmap, "suspended"));
			}
			if (obj_master.qb_mode) {
				ds_list_add(l_fumbles, s_get_player_rating(pmap));
			} else {
				ds_list_add(l_fumbles, "$" + string(ds_map_find_value(pmap, "salary")) + s_str("sla_Million"));
			}
			ds_list_add(l_rating, string(ds_map_find_value(pmap, "contract")) + s_str("sla_Year"));
			if (_arg1) {
				ds_list_add(l_xp, ds_map_find_value(pmap, "xp_gain"));
				if (s_has_xp_gain(pmap)) {
					ds_list_add(l_levelup, "flash_" + s_str("ui_Yes"));
				} else {
					ds_list_add(l_levelup, s_str("ui_No"));
				}
			} else {
				if (s_is_co_mode()) {
					ds_list_add(l_xp, s_college_age_simple_short(pmap));
				} else {
					ds_list_add(l_xp, ds_map_find_value(pmap, "age"));
				}
				ds_list_add(l_levelup, ds_map_find_value(pmap, "xp_level"));
			}
			if (s_is_co_mode()) {
				var grade = ds_map_find_value(pmap, "percent_grade");
				if (ds_map_exists(pmap, "saved_percent_grade")) {
					grade = ds_map_find_value(pmap, "saved_percent_grade");
					ds_map_delete(pmap, "saved_percent_grade");
				}
				slog("rm_xp/CreateA: " + ds_map_find_value(pmap, "lname") + " grade:" + string(grade) + "/" + s_gpa_string_direct(grade));
				ds_list_add(l_gpa, grade);
				ds_list_add(l_gpa_col, s_player_gpa_color(pmap));
			}
		}
	} else {
		ds_list_add(l_attitude, s_str("tla_Attitude"));
		ds_list_add(l_names, s_str("ui_Name"));
		ds_list_add(l_pos, s_str("tla_Position"));
		ds_list_add(l_condition, s_str("tla_Condition"));
		ds_list_add(l_resting, "");
		ds_list_add(l_yards, s_str("ui_stat_yards"));
		ds_list_add(l_tds, s_str("ui_stat_touchdowns"));
		ds_list_add(l_tackles, s_str("ui_stat_tackles"));
		ds_list_add(l_intsacks, s_str("ui_stat_intsacks"));
		ds_list_add(l_fumbles, s_str("ui_stat_fumbles"));
		ds_list_add(l_rating, s_str("tla_Rating"));
		ds_list_add(l_xp, "+" + s_str("ui_XP"));
		ds_list_add(l_levelup, s_str("short_LevelUp"));
		if (s_is_co_mode()) {
			ds_list_add(l_suspended, "");
		}
		if (s_is_co_mode()) {
			ds_list_add(l_gpa, s_str("ui_GPA"));
			ds_list_add(l_gpa_col, 16777215);
		}
		for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
			var pmap = ds_list_find_value(obj_master.roster, i);
			var pos = ds_map_find_value(pmap, "position");
			var con = ds_map_find_value(pmap, "condition");
			var rst = ds_map_find_value(pmap, "resting");
			var att = ds_map_find_value(pmap, "attitude");
			var yds = string(round(ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_rush_yards") + ds_map_find_value(pmap, "stat_return_yards")));
			var tds = string(ds_map_find_value(pmap, "stat_touchdowns") + ds_map_find_value(pmap, "stat_rush_touchdowns") + ds_map_find_value(pmap, "stat_return_tds"));
			var fum = string(ds_map_find_value(pmap, "stat_fumbles"));
			var tck = string(ds_map_find_value(pmap, "stat_tackles"));
			var intsck = "-";
			var xpg = ds_map_find_value(pmap, "xp_gain");
			switch (pos) {
				case 1:
					tck = "-";
					intsck = string(ds_map_find_value(pmap, "stat_int")) + "/" + string(ds_map_find_value(pmap, "stat_sacks"));
					break;
				case 6:
				case 7:
				case 8:
				case 9:
					intsck = string(ds_map_find_value(pmap, "stat_int")) + "/" + string(ds_map_find_value(pmap, "stat_sacks"));
					break;
				case 10:
					tck = "-";
					tds = "-";
					fum = "-";
					break;
			}
			var rat = string(s_get_match_rating(pmap));
			if (ds_map_find_value(pmap, "condition") < 0 && ds_map_find_value(pmap, "injury_week") != obj_master.week || s_player_benched(pmap) || ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup")) {
				fum = "-";
				tck = "-";
				intsck = "-";
				if (!ds_map_exists(pmap, "kr") || !ds_map_find_value(pmap, "kr")) {
					yds = "-";
					tds = "-";
					rat = "-";
				}
			}
			ds_list_add(l_names, s_get_player_name(pmap, true));
			ds_list_add(l_attitude, att);
			ds_list_add(l_pos, pos);
			ds_list_add(l_condition, con);
			ds_list_add(l_resting, rst);
			ds_list_add(l_yards, yds);
			ds_list_add(l_tds, tds);
			ds_list_add(l_fumbles, fum);
			ds_list_add(l_tackles, tck);
			ds_list_add(l_intsacks, intsck);
			ds_list_add(l_rating, rat);
			ds_list_add(l_xp, xpg);
			if (s_is_co_mode()) {
				ds_list_add(l_suspended, ds_map_find_value(pmap, "suspended"));
			}
			if (s_has_xp_gain(pmap)) {
				ds_list_add(l_levelup, "flash_" + s_str("ui_Yes"));
			} else {
				ds_list_add(l_levelup, s_str("ui_No"));
			}
			if (s_is_co_mode()) {
				var grade = ds_map_find_value(pmap, "percent_grade");
				if (ds_map_exists(pmap, "saved_percent_grade")) {
					grade = ds_map_find_value(pmap, "saved_percent_grade");
					ds_map_delete(pmap, "saved_percent_grade");
				}
				slog("rm_xp/CreateB: " + ds_map_find_value(pmap, "lname") + " grade:" + string(grade) + "/" + s_gpa_string_direct(grade));
				ds_list_add(l_gpa, grade);
				ds_list_add(l_gpa_col, s_player_gpa_color(pmap));
			}
		}
	}
}

