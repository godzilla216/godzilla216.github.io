function s_update_stats() {
	with (obj_master) {
		slog("s_update_stats");
		ds_list_shuffle(roster);
		var injury_done = false;
		var oc = s_get_staff(102);
		var dc = s_get_staff(101);
		if (!obj_master.qb_mode) {
			ds_map_set(oc, "xp_gain", ds_map_find_value(oc, "xp_gain") + clamp(round(ds_map_find_value(oc, "attitude") * 0.25), 1, 25));
			ds_map_set(dc, "xp_gain", ds_map_find_value(dc, "xp_gain") + clamp(round(ds_map_find_value(dc, "attitude") * 0.25), 1, 25));
		}
		var total_passing = 0;
		var qb_passing = 0;
		var total_rushing = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			s_check_for_return_stats(pmap);
			s_update_party_meter(pmap);
			if (!ds_map_exists(pmap, "xp_dev")) {
				ds_map_set(pmap, "xp_dev", random_range(0.75, 1.5));
			}
			if (ds_map_find_value(pmap, "condition") < 0 || s_player_benched(pmap)) {
				continue;
			}
			if (ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup") && (!ds_map_exists(pmap, "kr") || !ds_map_find_value(pmap, "kr"))) {
				ds_map_set(pmap, "xp_gain", ds_map_find_value(pmap, "xp_gain") + round(10 * real(ds_map_find_value(pmap, "xp_dev") * 0.8)));
				continue;
			}
			ds_map_set_post(pmap, "season_games", ds_map_find_value(pmap, "season_games") + 1);
			ds_map_set(pmap, "season_attempts", ds_map_find_value(pmap, "season_attempts") + ds_map_find_value(pmap, "stat_attempts"));
			ds_map_set(pmap, "season_complete", ds_map_find_value(pmap, "season_complete") + ds_map_find_value(pmap, "stat_complete"));
			ds_map_set(pmap, "season_yards", ds_map_find_value(pmap, "season_yards") + ds_map_find_value(pmap, "stat_yards"));
			ds_map_set(pmap, "season_touchdowns", ds_map_find_value(pmap, "season_touchdowns") + ds_map_find_value(pmap, "stat_touchdowns"));
			ds_map_set(pmap, "season_fumbles", ds_map_find_value(pmap, "season_fumbles") + ds_map_find_value(pmap, "stat_fumbles"));
			ds_map_set(pmap, "season_int", ds_map_find_value(pmap, "season_int") + ds_map_find_value(pmap, "stat_int"));
			ds_map_set(pmap, "season_sacks", ds_map_find_value(pmap, "season_sacks") + ds_map_find_value(pmap, "stat_sacks"));
			ds_map_set(pmap, "season_tackles", ds_map_find_value(pmap, "season_tackles") + ds_map_find_value(pmap, "stat_tackles"));
			ds_map_set(pmap, "season_rush_attempts", ds_map_find_value(pmap, "season_rush_attempts") + ds_map_find_value(pmap, "stat_rush_attempts"));
			ds_map_set(pmap, "season_rush_yards", ds_map_find_value(pmap, "season_rush_yards") + ds_map_find_value(pmap, "stat_rush_yards"));
			ds_map_set(pmap, "season_rush_touchdowns", ds_map_find_value(pmap, "season_rush_touchdowns") + ds_map_find_value(pmap, "stat_rush_touchdowns"));
			ds_map_set(pmap, "season_return_yards", ds_map_find_value(pmap, "season_return_yards") + ds_map_find_value(pmap, "stat_return_yards"));
			ds_map_set(pmap, "season_return_tds", ds_map_find_value(pmap, "season_return_tds") + ds_map_find_value(pmap, "stat_return_tds"));
			ds_map_set(pmap, "season_return_attempts", ds_map_find_value(pmap, "season_return_attempts") + ds_map_find_value(pmap, "stat_return_attempts"));
			if (ds_map_find_value(pmap, "position") == 10) {
				if (ds_map_exists(pmap, "stat_attempts_XP")) {
					ds_map_set(pmap, "season_attempts_XP", ds_map_find_value(pmap, "season_attempts_XP") + ds_map_find_value(pmap, "stat_attempts_XP"));
				}
				if (ds_map_exists(pmap, "stat_complete_XP")) {
					ds_map_set(pmap, "season_complete_XP", ds_map_find_value(pmap, "season_complete_XP") + ds_map_find_value(pmap, "stat_complete_XP"));
				}
			}
			if (ds_map_find_value(pmap, "position") == 1) {
				qb_passing = ds_map_find_value(pmap, "stat_yards");
			} else if (ds_map_find_value(pmap, "position") != 10) {
				total_passing += ds_map_find_value(pmap, "stat_yards");
			}
			total_rushing += ds_map_find_value(pmap, "stat_rush_yards");
			if (ds_map_find_value(pmap, "stat_longest") > ds_map_find_value(pmap, "season_longest")) {
				ds_map_set(pmap, "season_longest", ds_map_find_value(pmap, "stat_longest"));
			}
			if (ds_map_find_value(pmap, "stat_rush_longest") > ds_map_find_value(pmap, "season_rush_longest")) {
				ds_map_set(pmap, "season_rush_longest", ds_map_find_value(pmap, "stat_rush_longest"));
			}
			if (ds_map_find_value(pmap, "stat_return_longest") > ds_map_find_value(pmap, "season_return_longest")) {
				ds_map_set(pmap, "season_return_longest", ds_map_find_value(pmap, "stat_return_longest"));
			}
			ds_map_set_post(pmap, "career_games", ds_map_find_value(pmap, "career_games") + 1);
			ds_map_set(pmap, "career_attempts", ds_map_find_value(pmap, "career_attempts") + ds_map_find_value(pmap, "stat_attempts"));
			ds_map_set(pmap, "career_complete", ds_map_find_value(pmap, "career_complete") + ds_map_find_value(pmap, "stat_complete"));
			ds_map_set(pmap, "career_yards", ds_map_find_value(pmap, "career_yards") + ds_map_find_value(pmap, "stat_yards"));
			ds_map_set(pmap, "career_touchdowns", ds_map_find_value(pmap, "career_touchdowns") + ds_map_find_value(pmap, "stat_touchdowns"));
			ds_map_set(pmap, "career_fumbles", ds_map_find_value(pmap, "career_fumbles") + ds_map_find_value(pmap, "stat_fumbles"));
			ds_map_set(pmap, "career_int", ds_map_find_value(pmap, "career_int") + ds_map_find_value(pmap, "stat_int"));
			ds_map_set(pmap, "career_sacks", ds_map_find_value(pmap, "career_sacks") + ds_map_find_value(pmap, "stat_sacks"));
			ds_map_set(pmap, "career_tackles", ds_map_find_value(pmap, "career_tackles") + ds_map_find_value(pmap, "stat_tackles"));
			ds_map_set(pmap, "career_rush_attempts", ds_map_find_value(pmap, "career_rush_attempts") + ds_map_find_value(pmap, "stat_rush_attempts"));
			ds_map_set(pmap, "career_rush_yards", ds_map_find_value(pmap, "career_rush_yards") + ds_map_find_value(pmap, "stat_rush_yards"));
			ds_map_set(pmap, "career_rush_touchdowns", ds_map_find_value(pmap, "career_rush_touchdowns") + ds_map_find_value(pmap, "stat_rush_touchdowns"));
			ds_map_set(pmap, "career_return_yards", ds_map_find_value(pmap, "career_return_yards") + ds_map_find_value(pmap, "stat_return_yards"));
			ds_map_set(pmap, "career_return_tds", ds_map_find_value(pmap, "career_return_tds") + ds_map_find_value(pmap, "stat_return_tds"));
			ds_map_set(pmap, "career_return_attempts", ds_map_find_value(pmap, "career_return_attempts") + ds_map_find_value(pmap, "stat_return_attempts"));
			if (ds_map_find_value(pmap, "position") == 10) {
				if (ds_map_exists(pmap, "stat_attempts_XP")) {
					ds_map_set(pmap, "career_attempts_XP", ds_map_find_value(pmap, "career_attempts_XP") + ds_map_find_value(pmap, "stat_attempts_XP"));
				}
				if (ds_map_exists(pmap, "stat_complete_XP")) {
					ds_map_set(pmap, "career_complete_XP", ds_map_find_value(pmap, "career_complete_XP") + ds_map_find_value(pmap, "stat_complete_XP"));
				}
			}
			if (ds_map_find_value(pmap, "stat_longest") > ds_map_find_value(pmap, "career_longest")) {
				ds_map_set(pmap, "career_longest", ds_map_find_value(pmap, "stat_longest"));
			}
			if (ds_map_find_value(pmap, "stat_rush_longest") > ds_map_find_value(pmap, "career_rush_longest")) {
				ds_map_set(pmap, "career_rush_longest", ds_map_find_value(pmap, "stat_rush_longest"));
			}
			if (ds_map_find_value(pmap, "stat_return_longest") > ds_map_find_value(pmap, "career_return_longest")) {
				ds_map_set(pmap, "career_return_longest", ds_map_find_value(pmap, "stat_return_longest"));
			}
			if (ds_map_find_value(pmap, "position") == 1) {
				s_check_record("ui_BestPassGame", ds_map_find_value(pmap, "stat_yards"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_BestPassSeason", ds_map_find_value(pmap, "season_yards"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_BestPassCareer", ds_map_find_value(pmap, "career_yards"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostTDPassesGame", ds_map_find_value(pmap, "stat_touchdowns"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostTDPassesSeason", ds_map_find_value(pmap, "season_touchdowns"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostTDPassesCareer", ds_map_find_value(pmap, "career_touchdowns"), s_get_player_name_for_record(pmap), "", "");
				if (!s_simming_action()) {
					if (ds_map_find_value(pmap, "season_touchdowns") > 50) {
						s_complete_achievement("ACH_TD_PASS50");
					}
					if (ds_map_find_value(pmap, "stat_attempts") > 0 && ds_map_find_value(pmap, "stat_attempts") == ds_map_find_value(pmap, "stat_complete")) {
						s_complete_achievement("ACH_GAME_COMPLETE_100");
					}
				}
			} else if (ds_map_find_value(pmap, "position") == 10) {
				s_check_record("ui_BestFGDistGame", ds_map_find_value(pmap, "stat_yards"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_BestFGDistSeason", ds_map_find_value(pmap, "season_yards"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_BestFGDistCareer", ds_map_find_value(pmap, "career_yards"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostFGGame", ds_map_find_value(pmap, "stat_complete"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostFGSeason", ds_map_find_value(pmap, "season_complete"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostFGCareer", ds_map_find_value(pmap, "career_complete"), s_get_player_name_for_record(pmap), "", "");
			} else if (ds_map_find_value(pmap, "position") == 4 || ds_map_find_value(pmap, "position") == 3 || ds_map_find_value(pmap, "position") == 2) {
				s_check_record("ui_BestRecGame", ds_map_find_value(pmap, "stat_yards"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_BestRecSeason", ds_map_find_value(pmap, "season_yards"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_BestRecCareer", ds_map_find_value(pmap, "career_yards"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostTDRecGame", ds_map_find_value(pmap, "stat_touchdowns"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostTDRecSeason", ds_map_find_value(pmap, "season_touchdowns"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostTDRecCareer", ds_map_find_value(pmap, "career_touchdowns"), s_get_player_name_for_record(pmap), "", "");
			} else if (ds_map_find_value(pmap, "position") != 5) {
				s_check_record("ui_MostTacklesGame", ds_map_find_value(pmap, "stat_tackles"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostTacklesSeason", ds_map_find_value(pmap, "season_tackles"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostTacklesCareer", ds_map_find_value(pmap, "career_tackles"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostSacksGame", ds_map_find_value(pmap, "stat_sacks"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostSacksSeason", ds_map_find_value(pmap, "season_sacks"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostSacksCareer", ds_map_find_value(pmap, "career_sacks"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostIntGame", ds_map_find_value(pmap, "stat_int"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostIntSeason", ds_map_find_value(pmap, "season_int"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostIntCareer", ds_map_find_value(pmap, "career_int"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostFFGame", ds_map_find_value(pmap, "stat_fumbles"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
				s_check_record("ui_MostFFSeason", ds_map_find_value(pmap, "season_fumbles"), s_get_player_name_for_record(pmap), "", "");
				s_check_record("ui_MostFFCareer", ds_map_find_value(pmap, "career_fumbles"), s_get_player_name_for_record(pmap), "", "");
			} else {
			}
			s_check_record("ui_BestRushGame", ds_map_find_value(pmap, "stat_rush_yards"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
			s_check_record("ui_BestRushSeason", ds_map_find_value(pmap, "season_rush_yards"), s_get_player_name_for_record(pmap), "", "");
			s_check_record("ui_BestRushCareer", ds_map_find_value(pmap, "career_rush_yards"), s_get_player_name_for_record(pmap), "", "");
			s_check_record("ui_MostTDRushGame", ds_map_find_value(pmap, "stat_rush_touchdowns"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
			s_check_record("ui_MostTDRushSeason", ds_map_find_value(pmap, "season_rush_touchdowns"), s_get_player_name_for_record(pmap), "", "");
			s_check_record("ui_MostTDRushCareer", ds_map_find_value(pmap, "career_rush_touchdowns"), s_get_player_name_for_record(pmap), "", "");
			s_check_record("ui_MostReturnYardsGame", ds_map_find_value(pmap, "stat_return_yards"), s_get_player_name_for_record(pmap), "", s_get_opponent_team_tla());
			s_check_record("ui_MostReturnYardsSeason", ds_map_find_value(pmap, "season_return_yards"), s_get_player_name_for_record(pmap), "", "");
			s_check_record("ui_MostReturnYardsCareer", ds_map_find_value(pmap, "career_return_yards"), s_get_player_name_for_record(pmap), "", "");
			var xp_lev = ds_map_find_value(pmap, "xp_level");
			var xp_g = facility_training * 2;
			var effort = 0;
			switch (ds_map_find_value(pmap, "position")) {
				case 1:
					xp_g += ds_map_find_value(pmap, "stat_touchdowns") * 5 * 0.5;
					xp_g += ds_map_find_value(pmap, "stat_rush_touchdowns") * 5 * 0.5;
					xp_g += ds_map_find_value(pmap, "stat_yards") * 0.1;
					xp_g += ds_map_find_value(pmap, "stat_rush_yards") * 0.1;
					xp_g -= ds_map_find_value(pmap, "stat_fumbles") * 5;
					xp_g -= ds_map_find_value(pmap, "stat_int") * 2.5;
					xp_g -= ds_map_find_value(pmap, "stat_sacks") * 2.5;
					effort = clamp((ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_yards")) / 100, 0, 10);
					effort += ds_map_find_value(pmap, "stat_sacks") * 2;
					break;
				case 2:
					xp_g += ds_map_find_value(pmap, "stat_touchdowns") * 5;
					xp_g += ds_map_find_value(pmap, "stat_return_tds") * 5;
					xp_g += ds_map_find_value(pmap, "stat_rush_touchdowns") * 5;
					xp_g += ds_map_find_value(pmap, "stat_rush_yards") * 0.1 * 3;
					xp_g += ds_map_find_value(pmap, "stat_yards") * 0.1 * 2.5;
					xp_g -= ds_map_find_value(pmap, "stat_fumbles") * 5;
					xp_g += ds_map_find_value(pmap, "stat_return_yards") * 0.1;
					effort = clamp((ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_yards")) / 50, 0, 10);
					break;
				case 4:
					xp_g += ds_map_find_value(pmap, "stat_tackles") * 5;
					xp_g += ds_map_find_value(pmap, "stat_touchdowns") * 5;
					xp_g += ds_map_find_value(pmap, "stat_return_tds") * 5;
					xp_g += ds_map_find_value(pmap, "stat_yards") * 0.1 * 2;
					xp_g -= ds_map_find_value(pmap, "stat_fumbles") * 5;
					xp_g += ds_map_find_value(pmap, "stat_return_yards") * 0.1;
					effort = clamp((ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_yards")) / 50, 0, 10);
					break;
				case 3:
					xp_g += ds_map_find_value(pmap, "stat_tackles") * 5;
					xp_g += ds_map_find_value(pmap, "stat_touchdowns") * 5;
					xp_g += ds_map_find_value(pmap, "stat_yards") * 0.1 * 3;
					xp_g -= ds_map_find_value(pmap, "stat_fumbles") * 5;
					effort = clamp((ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_yards")) / 25, 0, 10);
					break;
				case 10:
					xp_g += ds_map_find_value(pmap, "stat_yards") * 0.4;
					effort = clamp((ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_yards")) / 50, 0, 10);
					break;
				case 5:
					xp_g += ds_map_find_value(pmap, "stat_tackles") * 5;
					xp_g -= ds_map_find_value(pmap, "stat_sacks") * 2.5;
					effort += ds_map_find_value(pmap, "stat_tackles");
					break;
				default:
					xp_g += ds_map_find_value(pmap, "stat_tackles") * 5;
					xp_g += ds_map_find_value(pmap, "stat_fumbles") * 5;
					xp_g += ds_map_find_value(pmap, "stat_sacks") * 2.5 * 2;
					xp_g += ds_map_find_value(pmap, "stat_return_yards") * 0.1;
					xp_g += ds_map_find_value(pmap, "stat_return_tds") * 5;
					effort += ds_map_find_value(pmap, "stat_tackles");
					break;
			}
			if (ds_map_find_value(oc, "trait") == 7 && s_is_offensive_player(pmap)) {
				xp_g += xp_lev * 5;
			} else if (ds_map_find_value(dc, "trait") == 7 && !s_is_offensive_player(pmap)) {
				xp_g += xp_lev * 5;
			}
			var trainingreg = obj_master.training_reg_df;
			if (s_is_offensive_player(pmap)) {
				trainingreg = obj_master.training_reg_of;
			}
			if (trainingreg == 1) {
				xp_g *= 0.6;
			} else if (trainingreg == 3) {
				xp_g *= 1.5;
			}
			xp_g *= real(ds_map_find_value(pmap, "xp_dev"));
			xp_g *= 0.8;
			xp_g = clamp(xp_g, 0, xp_lev * 200);
			ds_map_set(pmap, "xp_gain", ds_map_find_value(pmap, "xp_gain") + round(xp_g));
			effort = 25 + real(ds_map_find_value(pmap, "age"));
			effort += clamp(round(obj_master.week * 0.6), 2, 10);
			effort += s_get_match_rating(pmap);
			if (ds_map_find_value(pmap, "position") == 10) {
				effort *= 0.5;
			}
			ds_map_set(pmap, "condition", clamp(round(ds_map_find_value(pmap, "condition") - effort), 1, 100));
			if (ds_map_find_value(pmap, "position") == 10 && ds_map_find_value(pmap, "stat_attempts") < 1) {
				continue;
			}
			if (!injury_done) {
				injury_done = s_check_for_injury(pmap);
			}
		}
		if (!s_simming_action()) {
			if (qb_passing >= 200) {
				s_complete_achievement("ACH_GAME_PASS_200");
			}
			if (qb_passing >= 300) {
				s_complete_achievement("ACH_GAME_PASS_300");
			}
			if (qb_passing >= 400) {
				s_complete_achievement("ACH_GAME_PASS_400");
			}
			if (qb_passing >= 500) {
				s_complete_achievement("ACH_GAME_PASS_500");
			}
			if (total_passing >= 200) {
				s_complete_achievement("ACH_GAME_PASS_200");
			}
			if (total_passing >= 300) {
				s_complete_achievement("ACH_GAME_PASS_300");
			}
			if (total_passing >= 400) {
				s_complete_achievement("ACH_GAME_PASS_400");
			}
			if (total_passing >= 500) {
				s_complete_achievement("ACH_GAME_PASS_500");
			}
			if (total_rushing >= 50) {
				s_complete_achievement("ACH_GAME_RUSH_50");
			}
			if (total_rushing >= 100) {
				s_complete_achievement("ACH_GAME_RUSH_100");
			}
			if (total_rushing >= 150) {
				s_complete_achievement("ACH_GAME_RUSH_150");
			}
		}
	}
}

