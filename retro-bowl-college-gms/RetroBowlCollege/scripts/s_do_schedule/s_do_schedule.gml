function s_do_schedule(_arg0) {
	slog("s_do_schedule week: " + string(obj_master.week) + " skipping: " + string(_arg0));
	var myresult = 0;
	with (obj_master) {
		if (week > obj_master.last_week_regular && !s_is_co_mode()) {
			return s_do_playoff_schedule(_arg0);
		}
		for (var f = 0; f < ds_list_size(schedule); f++) {
			var fix = ds_list_find_value(schedule, f);
			if (ds_map_find_value(fix, "week") == week) {
				var team_idAway = ds_map_find_value(fix, "away_team");
				var team_idHome = ds_map_find_value(fix, "home_team");
				if (s_is_co_mode() && (team_idAway < 0 || team_idHome < 0)) {
					slogf("*** WARNING: match %1 has not been filled with teams", ds_map_find_value(fix, "cid"));
					continue;
				}
				var team_mapAway = ds_list_find_value(teamlist, team_idAway);
				var team_mapHome = ds_list_find_value(teamlist, team_idHome);
				if (s_is_co_mode()) {
					var sim = s_co_get_sim_results(team_mapAway, team_mapHome, s_is_co_bowl_fix(fix) ? false : true);
					var scoredataAway = sim.scoredataAway;
					var scoredataHome = sim.scoredataHome;
				} else {
					var team_strengthAway = s_get_team_offense_with_reputation_boost(team_mapAway);
					team_strengthAway += s_get_team_defense_with_reputation_boost(team_mapAway);
					var team_strengthHome = s_get_team_offense_with_reputation_boost(team_mapHome);
					team_strengthHome += s_get_team_defense_with_reputation_boost(team_mapHome);
					team_strengthHome += 1;
					var scoredataAway = s_get_random_scoredata();
					var scoredataHome = s_get_random_scoredata();
					var r_no_ties = irandom(2);
					if (s_is_co_mode()) {
						r_no_ties = 1;
					}
					if (ds_map_find_value(scoredataAway, "points") == ds_map_find_value(scoredataHome, "points") && r_no_ties) {
						ds_map_set(scoredataHome, "points", ds_map_find_value(scoredataHome, "points") + 3);
					}
					var do_swap = false;
					var upset_chance = 99;
					upset_chance = abs(team_strengthAway - team_strengthHome);
					upset_chance = round(upset_chance * 0.25);
					if (ds_map_find_value(scoredataAway, "points") > ds_map_find_value(scoredataHome, "points")) {
						if (team_strengthAway < team_strengthHome) {
							do_swap = irandom(upset_chance);
						}
					} else if (team_strengthAway > team_strengthHome) {
						do_swap = irandom(upset_chance);
					}
					if (do_swap) {
						var temp_map = ds_map_create();
						ds_map_copy(temp_map, scoredataAway);
						ds_map_copy(scoredataAway, scoredataHome);
						ds_map_copy(scoredataHome, temp_map);
						ds_map_destroy(temp_map);
						temp_map = -1;
					}
				}
				if (!_arg0) {
					if (team_idAway == obj_master.myteam_id) {
						ds_map_set(scoredataAway, "points", obj_master.tscore[0]);
						ds_map_set(scoredataHome, "points", obj_master.tscore[1]);
						if (ds_map_find_value(scoredataAway, "points") > ds_map_find_value(scoredataHome, "points")) {
							myresult = 1;
						}
						if (ds_map_find_value(scoredataAway, "points") < ds_map_find_value(scoredataHome, "points")) {
							myresult = -1;
						}
					} else if (team_idHome == obj_master.myteam_id) {
						ds_map_set(scoredataHome, "points", obj_master.tscore[1]);
						ds_map_set(scoredataAway, "points", obj_master.tscore[0]);
						if (ds_map_find_value(scoredataAway, "points") < ds_map_find_value(scoredataHome, "points")) {
							myresult = 1;
						}
						if (ds_map_find_value(scoredataAway, "points") > ds_map_find_value(scoredataHome, "points")) {
							myresult = -1;
						}
					}
				} else if (global.debug && global.debug_force_skip_result != 0) {
					if (team_idAway == obj_master.myteam_id || team_idHome == obj_master.myteam_id) {
						myresult = global.debug_force_skip_result;
						if (myresult == 1 && team_idAway == obj_master.myteam_id || myresult == -1 && team_idHome == obj_master.myteam_id) {
							ds_map_set(scoredataAway, "points", 21);
							ds_map_set(scoredataHome, "points", 7);
						} else {
							ds_map_set(scoredataAway, "points", 7);
							ds_map_set(scoredataHome, "points", 21);
						}
					}
				}
				ds_map_set(fix, "away_score", ds_map_find_value(scoredataAway, "points"));
				ds_map_set(fix, "home_score", ds_map_find_value(scoredataHome, "points"));
				if (ds_map_find_value(scoredataAway, "points") > ds_map_find_value(scoredataHome, "points")) {
					ds_map_set(team_mapAway, "wins", real(ds_map_find_value(team_mapAway, "wins")) + 1);
					ds_map_set(team_mapHome, "losses", real(ds_map_find_value(team_mapHome, "losses")) + 1);
				} else if (ds_map_find_value(scoredataAway, "points") < ds_map_find_value(scoredataHome, "points")) {
					ds_map_set(team_mapAway, "losses", real(ds_map_find_value(team_mapAway, "losses")) + 1);
					ds_map_set(team_mapHome, "wins", real(ds_map_find_value(team_mapHome, "wins")) + 1);
				} else {
					ds_map_set(team_mapAway, "ties", real(ds_map_find_value(team_mapAway, "ties")) + 1);
					ds_map_set(team_mapHome, "ties", real(ds_map_find_value(team_mapHome, "ties")) + 1);
				}
				ds_map_destroy(scoredataAway);
				ds_map_destroy(scoredataHome);
				scoredataAway = -1;
				scoredataHome = -1;
				s_co_update_fix_rank(fix);
				s_update_fixture_teams_reputation(fix);
			}
		}
	}
	s_co_conference_stats();
	if (!_arg0) {
		s_competitions_status_update();
	}
	with (obj_master) {
		if (week == obj_master.last_week_regular) {
			s_competitions_status_update();
			var season_wins = s_get_map_real(myteam, "wins", 0);
			var season_losses = s_get_map_real(myteam, "losses", 0);
			if (season_wins > season_losses) {
				s_complete_achievement("ACH_WINNING_SEASON");
			}
			if (s_is_co_mode() && season_losses == 0 || !s_is_co_mode() && season_wins == 17) {
				s_complete_achievement("ACH_UNBEATEN_SEASON");
			}
			s_update_history(myresult);
		}
	}
}

function s_co_get_sim_results(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (_arg2 == undefined) {
		_arg2 = true;
	}
	if (_arg3 == undefined) {
		_arg3 = -4;
	}
	if (_arg4 == undefined) {
		_arg4 = -4;
	}
	if (_arg3 != -4 && _arg4 != -4) {
		var team_strengthAway = _arg3;
		var team_strengthHome = _arg4;
	} else {
		var team_strengthAway = real(ds_map_find_value(_arg0, "offense"));
		team_strengthAway += real(ds_map_find_value(_arg0, "defense"));
		var team_strengthHome = real(ds_map_find_value(_arg1, "offense"));
		team_strengthHome += real(ds_map_find_value(_arg1, "defense"));
		team_strengthAway += s_get_reputation_points(_arg0);
		team_strengthHome += s_get_reputation_points(_arg1);
	}
	if (_arg2) {
		team_strengthHome += 1;
	}
	team_strengthHome = power(team_strengthHome + 5, 3);
	team_strengthAway = power(team_strengthAway + 5, 3);
	var winningTeamRoll = irandom(team_strengthHome + team_strengthAway);
	var winningTeam = 0;
	if (winningTeamRoll > team_strengthHome) {
		winningTeam = 1;
	}
	var scoringChancePct = abs(team_strengthHome - winningTeamRoll) / (team_strengthHome + team_strengthAway);
	var scoringChances = irandom_range(7, 13);
	var scoringChancesHome = scoringChances;
	var scoringChancesAway = scoringChances;
	if (winningTeam == 0) {
		scoringChancesHome += scoringChancesHome * scoringChancePct;
		scoringChancesAway -= scoringChancesAway * scoringChancePct;
	} else {
		scoringChancesHome -= scoringChancesHome * scoringChancePct;
		scoringChancesAway += scoringChancesAway * scoringChancePct;
	}
	if (scoringChancesHome > 13) {
		scoringChancesHome = 13;
	}
	if (scoringChancesAway > 13) {
		scoringChancesAway = 13;
	}
	if (scoringChancesHome < 1) {
		scoringChancesHome = 1;
	}
	if (scoringChancesAway < 1) {
		scoringChancesAway = 1;
	}
	var do_swap = false;
	var sim = {
		scoredataAway: s_co_get_random_scoredata(scoringChancesAway),
		scoredataHome: s_co_get_random_scoredata(scoringChancesHome)
	};
	if (ds_map_find_value(sim.scoredataAway, "points") == ds_map_find_value(sim.scoredataHome, "points")) {
		var tie_scoredata = sim.scoredataHome;
		if (!_arg2 && ds_map_find_value(_arg0, "ranking_points") > ds_map_find_value(_arg1, "ranking_points")) {
			tie_scoredata = sim.scoredataAway;
		}
		if (irandom(3) == 1) {
			ds_map_set(tie_scoredata, "points", ds_map_find_value(tie_scoredata, "points") + 3);
		} else {
			ds_map_set(tie_scoredata, "points", ds_map_find_value(tie_scoredata, "points") + 7);
		}
	}
	if (ds_map_find_value(sim.scoredataAway, "points") > ds_map_find_value(sim.scoredataHome, "points")) {
		if (winningTeam == 0) {
			do_swap = true;
		}
	} else if (winningTeam == 1) {
		do_swap = true;
	}
	if (do_swap) {
		var temp = sim.scoredataAway;
		sim.scoredataAway = sim.scoredataHome;
		sim.scoredataHome = temp;
	}
	return sim;
}

function s_co_conference_stats() {
	if (!s_is_co_mode()) {
		return;
	}
	slog("s_do_conference_stats");
	var team, team_away, team_home, fix;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(teamlist); i++) {
			team = ds_list_find_value(teamlist, i);
			ds_map_set(team, "wins_cnf", 0);
			ds_map_set(team, "losses_cnf", 0);
			ds_map_set(team, "wins_div", 0);
			ds_map_set(team, "losses_div", 0);
		}
		for (var f = 0; f < ds_list_size(schedule); f++) {
			fix = ds_list_find_value(schedule, f);
			if (real(ds_map_find_value(fix, "away_score")) < 0 && real(ds_map_find_value(fix, "home_score")) < 0) {
				continue;
			}
			if (real(ds_map_find_value(fix, "week")) > obj_master.last_week_regular) {
				continue;
			}
			team_away = ds_list_find_value(teamlist, ds_map_find_value(fix, "away_team"));
			team_home = ds_list_find_value(teamlist, ds_map_find_value(fix, "home_team"));
			if (!s_is_co_team(team_away) || !s_is_co_team(team_home)) {
				continue;
			}
			if (ds_map_find_value(team_away, "conference") == ds_map_find_value(team_home, "conference")) {
				if (real(ds_map_find_value(fix, "away_score")) > real(ds_map_find_value(fix, "home_score"))) {
					ds_map_set_post(team_away, "wins_cnf", ds_map_find_value(team_away, "wins_cnf") + 1);
					ds_map_set_post(team_home, "losses_cnf", ds_map_find_value(team_home, "losses_cnf") + 1);
				} else {
					ds_map_set_post(team_away, "losses_cnf", ds_map_find_value(team_away, "losses_cnf") + 1);
					ds_map_set_post(team_home, "wins_cnf", ds_map_find_value(team_home, "wins_cnf") + 1);
				}
				if (ds_map_find_value(team_away, "division") == ds_map_find_value(team_home, "division")) {
					if (real(ds_map_find_value(fix, "away_score")) > real(ds_map_find_value(fix, "home_score"))) {
						ds_map_set_post(team_away, "wins_div", ds_map_find_value(team_away, "wins_div") + 1);
						ds_map_set_post(team_home, "losses_div", ds_map_find_value(team_home, "losses_div") + 1);
					} else {
						ds_map_set_post(team_away, "losses_div", ds_map_find_value(team_away, "losses_div") + 1);
						ds_map_set_post(team_home, "wins_div", ds_map_find_value(team_home, "wins_div") + 1);
					}
				}
			}
		}
	}
}

