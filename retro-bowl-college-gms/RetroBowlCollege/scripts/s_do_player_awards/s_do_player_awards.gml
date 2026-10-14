function s_do_player_awards() {
	with (obj_master) {
		slog("s_do_player_awards");
		if (year == 1) {
			return;
		}
		var won_div = s_get_division_winner(myconference, mydivision) == myteam;
		var mvp_rating = 90;
		var opoy_rating = 90;
		var dpoy_rating = 85;
		var roty_rating = 85;
		var min_games = 12;
		var mvp = -4;
		var opoy = -4;
		var dpoy = -4;
		var roty = -4;
		var debug_msg = s_str("msg_SeasonRatings") + "##";
		var sz = ds_list_size(roster);
		if (sz < 1) {
			return;
		}
		for (var i = 0; i < sz; i++) {
			var pmap = ds_list_find_value(roster, i);
			var games = ds_map_find_value(pmap, "season_games");
			var pos = ds_map_find_value(pmap, "position");
			var yards = ds_map_find_value(pmap, "season_yards") + ds_map_find_value(pmap, "season_rush_yards") * 1.35;
			var avg_yds = yards / games;
			var tds = ds_map_find_value(pmap, "season_touchdowns");
			var fumbles = ds_map_find_value(pmap, "season_fumbles");
			var tackles = ds_map_find_value(pmap, "season_tackles");
			var ints = ds_map_find_value(pmap, "season_int");
			var sacks = ds_map_find_value(pmap, "season_sacks");
			var atts = ds_map_find_value(pmap, "season_attempts");
			var comp = ds_map_find_value(pmap, "season_complete");
			if (ds_map_exists(pmap, "season_attempts_XP") && ds_map_exists(pmap, "season_complete_XP")) {
				atts += string(round(ds_map_find_value(pmap, "season_attempts_XP")));
				comp += string(round(ds_map_find_value(pmap, "season_complete_XP")));
			}
			var comp_prc = 0;
			if (atts > 0) {
				comp_prc = comp / atts * 100;
			}
			var rating = 0;
			var yard_target = 1;
			switch (pos) {
				case 1:
					rating = clamp(yards / 3300 * 100, 1, 150);
					rating += tds;
					rating -= ints;
					rating -= sacks * 0.5;
					rating = round(rating);
					if (games > min_games && won_div) {
						if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() && rating >= roty_rating) {
							roty_rating = rating;
							roty = pmap;
						} else if (rating >= mvp_rating) {
							mvp_rating = rating;
							mvp = pmap;
						}
					}
					break;
				case 2:
				case 3:
				case 4:
					if (pos == 2) {
						yard_target = 1750;
					}
					if (pos == 3) {
						yard_target = 1350;
					}
					if (pos == 4) {
						yard_target = 2100;
					}
					rating = clamp(yards / yard_target * 100, 1, 150);
					rating -= fumbles * 5;
					rating += tds * 1.25;
					rating = round(rating);
					if (games > min_games && won_div) {
						if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() && rating >= roty_rating) {
							roty_rating = rating;
							roty = pmap;
						} else if (rating >= mvp_rating) {
							mvp_rating = rating;
							mvp = pmap;
						} else if (rating >= opoy_rating) {
							opoy_rating = rating;
							opoy = pmap;
						}
					}
					break;
				case 5:
					rating = tackles * 1.25;
					break;
					if (games > min_games && won_div) {
						if (rating >= opoy_rating) {
							opoy_rating = rating;
							opoy = pmap;
						}
					}
					break;
				case 6:
				case 7:
				case 8:
				case 9:
					rating = tackles * 0.5;
					rating += ints * 3;
					rating += sacks * 3;
					rating += fumbles * 3;
					rating = round(rating);
					if (games > min_games && won_div) {
						if (rating >= dpoy_rating) {
							dpoy_rating = rating;
							dpoy = pmap;
						}
					}
					break;
				case 10:
					rating = clamp(yards / 4000 * 100, 1, 100);
					rating = (rating + comp_prc) / 2;
					rating = round(rating);
					if (games > min_games && won_div) {
						if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() && rating >= roty_rating) {
							roty_rating = rating;
							roty = pmap;
						}
					}
					break;
			}
			debug_msg += s_get_string_position(pos) + " " + s_get_player_name(pmap, true) + "... " + s_get_string_performance(rating) + "#";
		}
		debug_msg = string_hash_to_newline(debug_msg);
		slog(debug_msg);
		s_add_news(debug_msg);
		if (mvp) {
			if (ds_map_exists(mvp, "mvp")) {
				ds_map_set(mvp, "mvp", ds_map_find_value(mvp, "mvp") + 1);
			} else {
				ds_map_set(mvp, "mvp", 1);
			}
			var msg = string_replace(s_str("news_mvp"), "$playername", s_get_player_name(mvp, false));
			msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(mvp, "position")));
			s_add_news(msg);
		}
		if (opoy) {
			if (ds_map_exists(opoy, "opoy")) {
				ds_map_set(opoy, "opoy", ds_map_find_value(opoy, "opoy") + 1);
			} else {
				ds_map_set(opoy, "opoy", 1);
			}
			var msg = string_replace(s_str("news_opoy"), "$playername", s_get_player_name(opoy, false));
			msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(opoy, "position")));
			s_add_news(msg);
		}
		if (dpoy) {
			if (ds_map_exists(dpoy, "dpoy")) {
				ds_map_set(dpoy, "dpoy", ds_map_find_value(dpoy, "dpoy") + 1);
			} else {
				ds_map_set(dpoy, "dpoy", 1);
			}
			var msg = string_replace(s_str("news_dpoy"), "$playername", s_get_player_name(dpoy, false));
			msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(dpoy, "position")));
			s_add_news(msg);
		}
		if (roty) {
			if (ds_map_exists(roty, "roty")) {
				ds_map_set(roty, "roty", ds_map_find_value(roty, "roty") + 1);
			} else {
				ds_map_set(roty, "roty", 1);
			}
			var msg = string_replace(s_str("news_roty"), "$playername", s_get_player_name(roty, false));
			msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(roty, "position")));
			s_add_news(msg);
		}
	}
}

function s_do_player_awards_college() {
	with (obj_master) {
		if (obj_master.college_awards_done == true) {
			return;
		}
		obj_master.college_awards_done = true;
		var hackForceAwards = false;
		var FBS_REQ_RANKING = 15;
		var FBC_REQ_RANKING = 5;
		var MIN_GAMES_PLAYED = 12;
		slog2("3.s_do_player_awards_college");
		if (ds_list_size(roster) == 0) {
			slog("- Bail. No players on roster");
			return;
		}
		var FBSrank = s_subdivision_get_player_ranking(1);
		var FCSrank = s_subdivision_get_player_ranking(2);
		if (hackForceAwards) {
			FBSrank = 9;
		}
		var inTopFBS = FBSrank != -1 && FBSrank <= FBS_REQ_RANKING;
		var inTopFCS = FCSrank != -1 && FCSrank <= FBC_REQ_RANKING;
		slog("- Team Ranking FBS[" + string(FBSrank) + "] FCS[" + string(FCSrank) + "]");
		if (inTopFBS == false && inTopFCS == false) {
			slog("- Bailing, no awards. FCSrank[" + string(FCSrank) + "] worse than FBC_REQ_RANKING[" + string(FBC_REQ_RANKING) + "] or FBSrank[" + string(FBSrank) + "] worse than FBS_REQ_RANKING[" + string(FBS_REQ_RANKING) + "]");
			return;
		}
		slog("- Calculate player ratings:");
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "award_rating", 0);
			ds_map_set(pmap, "award_recieved", "");
			var games = ds_map_find_value(pmap, "season_games");
			if (games < MIN_GAMES_PLAYED && hackForceAwards == false) {
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "]: Skipped. Only played [" + string(games) + "/" + string(MIN_GAMES_PLAYED) + "]");
				continue;
			}
			var pos = ds_map_find_value(pmap, "position");
			var yards = ds_map_find_value(pmap, "season_yards") + ds_map_find_value(pmap, "season_rush_yards") * 1.35;
			var avg_yds = yards / games;
			var tds = ds_map_find_value(pmap, "season_touchdowns");
			var fumbles = ds_map_find_value(pmap, "season_fumbles");
			var tackles = ds_map_find_value(pmap, "season_tackles");
			var ints = ds_map_find_value(pmap, "season_int");
			var sacks = ds_map_find_value(pmap, "season_sacks");
			var atts = ds_map_find_value(pmap, "season_attempts");
			var comp = ds_map_find_value(pmap, "season_complete");
			if (ds_map_exists(pmap, "season_attempts_XP") && ds_map_exists(pmap, "season_complete_XP")) {
				atts += string(round(ds_map_find_value(pmap, "season_attempts_XP")));
				comp += string(round(ds_map_find_value(pmap, "season_complete_XP")));
			}
			var comp_prc = 0;
			if (atts > 0) {
				comp_prc = comp / atts * 100;
			}
			var rating = 0;
			var yard_target = 1;
			switch (pos) {
				case 1:
					rating = clamp(yards / 3300 * 100, 1, 150);
					rating += tds;
					rating -= ints;
					rating -= sacks * 0.5;
					rating = round(rating);
					break;
				case 2:
				case 3:
				case 4:
					if (pos == 2) {
						yard_target = 1750;
					}
					if (pos == 3) {
						yard_target = 1350;
					}
					if (pos == 4) {
						yard_target = 2100;
					}
					rating = clamp(yards / yard_target * 100, 1, 150);
					rating -= fumbles * 5;
					rating += tds * 1.25;
					rating = round(rating);
					break;
				case 5:
					rating = tackles * 1.25;
					break;
				case 6:
				case 7:
				case 8:
				case 9:
					rating = tackles * 0.5;
					rating += ints * 3;
					rating += sacks * 3;
					rating += fumbles * 3;
					rating = round(rating);
					break;
				case 10:
					rating = clamp(yards / 4000 * 100, 1, 100);
					rating = (rating + comp_prc) / 2;
					rating = round(rating);
					break;
			}
			if (hackForceAwards) {
				rating = irandom_range(70, 99);
			}
			ds_map_set(pmap, "award_rating", rating);
			slog("-- Player[" + ds_map_find_value(pmap, "lname") + "]: Rating[" + string(ds_map_find_value(pmap, "award_rating")) + "] for pos " + s_get_string_position(ds_map_find_value(pmap, "position")));
		}
		roster = s_sort_players(roster, 6);
		slog("- Players sorted by rating:");
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] award_rating:[" + string(ds_map_find_value(pmap, "award_rating")) + "]");
		}
		slog("- Assign awards:");
		s_Award_OutstandingPOTY();
		s_Award_ExtraordinaryAcademicPOTY();
		s_Award_OffensivePOTY();
		s_Award_DefensivePOTY();
		s_Award_PositionPOTY(1, "cv_QuarterbackPOTY");
		s_Award_PositionPOTY(2, "cv_RunningBackPOTY");
		s_Award_PositionPOTY(3, "cv_TightEndPOTY");
		s_Award_PositionPOTY(4, "cv_WideReceiverPOTY");
		s_Award_PositionPOTY(5, "cv_OffensiveLinemanPOTY");
		s_Award_PositionPOTY(6, "cv_DefensiveLinemanPOTY");
		s_Award_AnyPositionPOTY(9, 8, "cv_DefensiveBackPOTY");
		s_Award_PositionPOTY(7, "cv_LinebackerPOTY");
		s_Award_PositionPOTY(10, "cv_KickerPOTY");
		s_Award_CommunityServicePOTY();
		s_Award_WalkOnPOTY();
		s_Award_FreshmanPOTY();
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") == "") {
				continue;
			}
			var newsTag = ds_map_find_value(pmap, "award_recieved") + "_news";
			if (s_college_academics_type("Military")) {
				newsTag = "cvMilitary_" + string_delete(newsTag, 1, 3);
			}
			s_add_news(s_parse_player_message(s_str(newsTag), pmap));
			s_add_cv_entry_from_key(pmap, ds_map_find_value(pmap, "award_recieved"));
		}
		s_Award_AcademicPrize();
		for (var i = 0; i < ds_list_size(roster); i++) {
			ds_map_delete(ds_list_find_value(roster, i), "award_rating");
			ds_map_delete(ds_list_find_value(roster, i), "award_recieved");
		}
		roster = s_sort_players(roster, 4);
	}
}

function s_Award_OutstandingPOTY() {
	var AWARD_RATING = 95;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			ds_map_set(pmap, "award_recieved", "cv_OutstandingPOTY");
			slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "]");
			return;
		}
	}
}

function s_Award_ExtraordinaryAcademicPOTY() {
	var AWARD_RATING = 80;
	var GPA_SCORE = 93;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			if (ds_map_find_value(pmap, "percent_grade") >= GPA_SCORE) {
				ds_map_set(pmap, "award_recieved", "cv_ExtraordinaryAcademicPOTY");
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] grade [" + string(ds_map_find_value(pmap, "percent_grade")) + "]");
				return;
			}
		}
	}
}

function s_Award_OffensivePOTY() {
	var AWARD_RATING = 90;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			switch (ds_map_find_value(pmap, "position")) {
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
					ds_map_set(pmap, "award_recieved", "cv_OffensivePOTY");
					slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] pos [" + s_get_string_position(ds_map_find_value(pmap, "position")) + "]");
					return;
			}
		}
	}
}

function s_Award_DefensivePOTY() {
	var AWARD_RATING = 90;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			switch (ds_map_find_value(pmap, "position")) {
				case 6:
				case 7:
				case 8:
				case 9:
					ds_map_set(pmap, "award_recieved", "cv_DefensivePOTY");
					slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] pos [" + s_get_string_position(ds_map_find_value(pmap, "position")) + "]");
					return;
			}
		}
	}
}

function s_Award_PositionPOTY(_arg0, _arg1) {
	var AWARD_RATING = 85;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			if (ds_map_find_value(pmap, "position") == _arg0) {
				ds_map_set(pmap, "award_recieved", _arg1);
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] pos [" + s_get_string_position(ds_map_find_value(pmap, "position")) + "]");
				return;
			}
		}
	}
}

function s_Award_AnyPositionPOTY(_arg0, _arg1, _arg2) {
	var AWARD_RATING = 85;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			if (ds_map_find_value(pmap, "position") == _arg0 || ds_map_find_value(pmap, "position") == _arg1) {
				ds_map_set(pmap, "award_recieved", _arg2);
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] pos [" + s_get_string_position(ds_map_find_value(pmap, "position")) + "]");
				return;
			}
		}
	}
}

function s_Award_CommunityServicePOTY() {
	var AWARD_RATING = 80;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			switch (ds_map_find_value(pmap, "hobby")) {
				case 43:
				case 60:
				case 64:
				case 94:
				case 111:
				case 112:
				case 141:
				case 166:
				case 171:
					ds_map_set(pmap, "award_recieved", "cv_CommunityServicePOTY");
					slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] hobby [" + s_get_hobby_name(pmap, false) + "]");
					return;
			}
		}
	}
}

function s_Award_WalkOnPOTY() {
	var AWARD_RATING = 80;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			if (ds_map_find_value(pmap, "walk_on") == 1) {
				ds_map_set(pmap, "award_recieved", "cv_WalkOnPOTY");
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] walk-on [" + string(ds_map_find_value(pmap, "walk_on")) + "]");
				return;
			}
		}
	}
}

function s_Award_FreshmanPOTY() {
	var AWARD_RATING = 75;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "award_recieved") != "") {
				continue;
			}
			if (ds_map_find_value(pmap, "award_rating") < AWARD_RATING) {
				break;
			}
			if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
				ds_map_set(pmap, "award_recieved", "cv_FreshmanPOTY");
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [" + ds_map_find_value(pmap, "award_recieved") + "] age [" + s_college_age_simple(pmap) + "]");
				return;
			}
		}
	}
}

function s_Award_AcademicPrize() {
	var GPA_SCORE = 90;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "percent_grade") >= GPA_SCORE) {
				s_add_cv_entry_from_key(pmap, "cv_AcademicPrize");
				slog("-- Player[" + ds_map_find_value(pmap, "lname") + "] got [cv_AcademicPrize]");
			}
		}
	}
}

