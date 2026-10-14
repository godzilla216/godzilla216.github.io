function s_do_playoff_schedule(_arg0) {
	var week_afc_champ = 26;
	var week_nfc_champ = 27;
	var week_superbowl = 28;
	with (obj_master) {
		if (!s_playoffs_12()) {
			week_afc_champ += 2;
			week_nfc_champ += 2;
			week_superbowl += 2;
		}
		if (first_week_playoffs == 19) {
			week_afc_champ += 1;
			week_nfc_champ += 1;
			week_superbowl += 1;
		}
		slog("s_do_playoff_schedule:" + string(week));
		var fix = s_get_playoff_fixture_by_week(week);
		if (!ds_exists(fix, 1)) {
			slog("Fixture error! Trying to recreate playoffs");
			s_create_playoffs2();
			fix = s_get_playoff_fixture_by_week(week);
			if (!ds_exists(fix, 1)) {
				slog("Fixture error! Skipping season");
				s_start_new_season(false);
				return false;
			}
		}
		var team_idAway = ds_map_find_value(fix, "away_team");
		var team_idHome = ds_map_find_value(fix, "home_team");
		var team_mapAway = ds_list_find_value(teamlist, team_idAway);
		var team_mapHome = ds_list_find_value(teamlist, team_idHome);
		var team_strengthAway = s_get_team_offense_with_reputation_boost(team_mapAway);
		team_strengthAway += s_get_team_defense_with_reputation_boost(team_mapAway);
		var team_strengthHome = s_get_team_offense_with_reputation_boost(team_mapHome);
		team_strengthHome += s_get_team_defense_with_reputation_boost(team_mapHome);
		team_strengthHome += 1;
		team_strengthHome += 1;
		var scoredataAway = s_get_random_scoredata();
		var scoredataHome = s_get_random_scoredata();
		if (ds_map_find_value(scoredataAway, "points") == ds_map_find_value(scoredataHome, "points")) {
			ds_map_set(scoredataHome, "points", ds_map_find_value(scoredataHome, "points") + 3);
		}
		if (!irandom(4) && ds_map_find_value(scoredataAway, "points") > ds_map_find_value(scoredataHome, "points") && team_strengthAway < team_strengthHome) {
			var temp_map = ds_map_create();
			ds_map_copy(temp_map, scoredataAway);
			ds_map_copy(scoredataAway, scoredataHome);
			ds_map_copy(scoredataHome, temp_map);
			ds_map_destroy(temp_map);
			temp_map = -1;
		}
		if (team_idAway == obj_master.myteam_id || team_idHome == obj_master.myteam_id) {
			ds_map_set(scoredataAway, "points", obj_master.tscore[0]);
			ds_map_set(scoredataHome, "points", obj_master.tscore[1]);
		}
		ds_map_set(fix, "away_score", ds_map_find_value(scoredataAway, "points"));
		ds_map_set(fix, "home_score", ds_map_find_value(scoredataHome, "points"));
		var winning_team = team_mapAway;
		var losing_team = team_mapHome;
		if (ds_map_find_value(scoredataAway, "points") < ds_map_find_value(scoredataHome, "points")) {
			winning_team = team_mapHome;
			losing_team = team_mapAway;
		}
		var scr1 = real(ds_map_find_value(fix, "away_score"));
		var scr2 = real(ds_map_find_value(fix, "home_score"));
		if (scr2 > scr1) {
			scr2 = real(ds_map_find_value(fix, "away_score"));
			scr1 = real(ds_map_find_value(fix, "home_score"));
		}
		if (week == week_superbowl) {
			s_add_news(s_parse_news("msg_SuperBowlWinner", winning_team, losing_team, ds_map_find_value(fix, "away_score"), ds_map_find_value(fix, "home_score")));
			var map = ds_map_create();
			ds_map_set(map, "year", start_year + year);
			ds_map_set(map, "winner", ds_map_find_value(winning_team, "name"));
			ds_map_set(map, "score", string(scr1) + "-" + string(scr2));
			ds_map_set(map, "loser", ds_map_find_value(losing_team, "tla"));
			ds_map_set(map, "human", 0);
			if (team_idAway == obj_master.myteam_id || team_idHome == obj_master.myteam_id) {
				if (winning_team == obj_master.myteam) {
					obj_master.retrobowlwinner = 1;
					ds_map_set(map, "human", 1);
					s_get_retrobowl_mvp_winner();
				} else {
					obj_master.retrobowlwinner = -1;
					ds_map_set(map, "human", -1);
				}
			} else {
				s_do_player_awards();
			}
			ds_list_add(rbhistorylist, map);
		} else {
			s_add_news(s_parse_news("msg_PlayOffResult", winning_team, losing_team, scr1, scr2));
			s_promote_playoff_winner(week, ds_map_find_value(winning_team, "uid"));
			if (week == week_afc_champ || week == week_nfc_champ) {
				var str = s_str("news_ConferenceChamps");
				str = string_replace(str, "$teamname", ds_map_find_value(winning_team, "name"));
				str = string_replace(str, "$conference", s_get_string_conference(ds_map_find_value(winning_team, "conference")));
				s_add_news(str);
			}
		}
		ds_map_destroy(scoredataAway);
		ds_map_destroy(scoredataHome);
		scoredataAway = -1;
		scoredataHome = -1;
	}
	return true;
}

function s_get_retrobowl_mvp_winner() {
	with (obj_master) {
		var mvp = -4;
		var qb = s_get_qb_pmap();
		if (qb && s_get_match_rating(qb) > 9 && ds_map_find_value(qb, "condition") > 0 && !s_player_benched(qb)) {
			mvp = qb;
		} else {
			var rat = 0;
			for (var i = 0; i < ds_list_size(roster); i++) {
				var pmap = ds_list_find_value(roster, i);
				if (ds_map_find_value(pmap, "condition") < 0 || s_player_benched(pmap) || ds_map_find_value(pmap, "position") == 10) {
					continue;
				}
				var mr = s_get_match_rating(pmap);
				if (mr > rat && s_is_offensive_player(pmap)) {
					rat = mr;
					mvp = pmap;
				} else if (mr - 1 > rat && !s_is_offensive_player(pmap)) {
					rat = mr - 1;
					mvp = pmap;
				} else if (mr == rat && s_is_offensive_player(pmap)) {
					if (ds_map_find_value(pmap, "stat_yards") + ds_map_find_value(pmap, "stat_rush_yards") > ds_map_find_value(mvp, "stat_yards") + ds_map_find_value(mvp, "stat_rush_yards")) {
						rat = mr;
						mvp = pmap;
					}
				}
			}
		}
		if (mvp) {
			var msg = string_replace(s_str("msg_RetroBowlMVPWinner"), "$playername", ds_map_find_value(mvp, "fname") + " " + ds_map_find_value(mvp, "lname"));
			s_add_news(msg);
			if (!ds_map_exists(mvp, "rbmvp")) {
				ds_map_set(mvp, "rbmvp", 1);
			} else {
				ds_map_set(mvp, "rbmvp", real(ds_map_find_value(mvp, "rbmvp")) + 1);
			}
		}
	}
}

