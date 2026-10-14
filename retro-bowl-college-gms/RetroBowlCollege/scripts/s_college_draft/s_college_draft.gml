function s_college_draft_ranking(_arg0) {
	var pmap = _arg0;
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
			rating = tackles;
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
	return rating;
}

function s_college_draft_team_ranking() {
	var FBSrank = s_subdivision_get_player_ranking(1);
	var FCSrank = s_subdivision_get_player_ranking(2);
	slog("s_college_draft_team_ranking");
	slog("... Team Ranking FBSrank [" + string(FBSrank) + "]");
	slog("... Team Ranking FCSrank [" + string(FCSrank) + "]");
	if (FBSrank != 1) {
		if (FBSrank > 25) {
			slog("... [Case 1] Pts[0]");
			return 0;
		}
		slog("... [Case 2] Pts[" + string(51 - FBSrank) + "]");
		return 51 - FBSrank;
	}
	if (FCSrank != 1) {
		if (FCSrank > 25) {
			slog("... [Case 3] Pts[0]");
			return 0;
		}
		slog("... [Case 4] Pts[" + string(26 - FCSrank) + "]");
		return 26 - FCSrank;
	}
	slog("... [Case 5] Pts[0]");
	return 0;
}

function s_college_draft_team_pick(_arg0, _arg1) {
	var ts = ds_list_size(_arg1);
	return ds_list_find_value(_arg1, irandom(ts - 1));
}

function s_calculate_college_draft() {
	var y1_balance_seniorGrad = false;
	var proTeams = s_load_pro_teams();
	obj_master.college_draft = ds_list_create();
	with (obj_master) {
		var tR = s_college_draft_team_ranking();
		var sz = ds_list_size(roster);
		for (var i = 0; i < sz; i++) {
			var pmap = ds_list_find_value(roster, i);
			var year = ds_map_find_value(pmap, "age") - s_rookie_age_internal() + 1;
			if (year < 3) {
			} else {
				var imap = ds_map_create();
				var s = "" + string(ds_map_find_value(pmap, "lname"));
				ds_map_set(imap, "index", i);
				ds_map_set(imap, "year", year);
				s += " Y" + string(ds_map_find_value(imap, "year"));
				ds_map_set(imap, "rating", s_college_draft_ranking(pmap));
				s += " Rating[" + string(ds_map_find_value(imap, "rating")) + "]";
				ds_map_set(imap, "skills", s_get_player_rating(pmap) * 4);
				s += " Skills[" + string(ds_map_find_value(imap, "skills")) + "]";
				ds_map_set(imap, "team_ranking", tR);
				s += " T.Rank[" + string(ds_map_find_value(imap, "team_ranking")) + "]";
				var draftScore = ds_map_find_value(imap, "rating") + ds_map_find_value(imap, "skills") + ds_map_find_value(imap, "team_ranking");
				ds_map_set(imap, "draft_score", draftScore);
				s += " DraftScore[" + string(draftScore) + "]";
				var pickRound = -1;
				var pickLabel = s_str("ui_co_Draft_NotPicked");
				ds_map_set(imap, "pick_r1_rand", -1);
				ds_map_set(imap, "pick_r2_rand", -1);
				ds_map_set(imap, "pick_r3_rand", -1);
				ds_map_set(imap, "credits", 10);
				ds_map_set(imap, "reveal_attitude", ds_map_find_value(pmap, "attitude"));
				if (pickRound < 0) {
					var rRand = year == 4 ? irandom_range(120, 170) : irandom_range(120, 220);
					ds_map_set(imap, "pick_r1_rand", rRand);
					if (rRand < draftScore) {
						pickRound = 1;
						pickLabel = s_str("ui_co_Draft_R1");
						ds_map_set(imap, "credits", 50);
						ds_map_set(imap, "reveal_attitude", 90);
						if (year == 3) {
							ds_map_set(imap, "credits", 100);
							rRand = irandom_range(100, 170);
							ds_map_set(imap, "pick_r2_rand", rRand);
							if (rRand < draftScore) {
								pickRound = 1;
								pickLabel = s_str("ui_co_Draft_R1");
								ds_map_set(imap, "credits", 100);
								ds_map_set(imap, "reveal_attitude", 90);
							} else {
								pickRound = 2;
								pickLabel = s_str("ui_co_Draft_R2");
								ds_map_set(imap, "credits", 80);
								ds_map_set(imap, "reveal_attitude", 75);
							}
						}
					}
				}
				if (pickRound < 0 && year == 4) {
					var rRand = irandom_range(80, 140);
					ds_map_set(imap, "pick_r2_rand", rRand);
					if (rRand < draftScore) {
						pickRound = 2;
						pickLabel = s_str("ui_co_Draft_R2");
						ds_map_set(imap, "credits", 40);
						ds_map_set(imap, "reveal_attitude", 75);
					}
				}
				if (pickRound < 0 && year == 4) {
					var rRand = irandom_range(60, 110);
					ds_map_set(imap, "pick_r3_rand", rRand);
					if (rRand < draftScore) {
						pickRound = 3;
						pickLabel = s_str("ui_co_Draft_R3");
						ds_map_set(imap, "credits", 30);
						ds_map_set(imap, "reveal_attitude", 75);
					}
				}
				if (pickRound < 0 && year == 4) {
					pickRound = 4;
					pickLabel = s_str("ui_co_Draft_Graduate");
					ds_map_set(imap, "credits", 10);
					ds_map_set(imap, "reveal_attitude", 45);
				}
				if (pickRound < 0 && year == 3) {
					pickLabel = s_str("ui_co_Draft_SrYear");
					ds_map_set(imap, "credits", 0);
				}
				if (pickRound > 0 && pickRound < 4) {
					var team = s_college_draft_team_pick(pmap, proTeams);
					ds_map_set(imap, "team_pick", team);
					pickLabel += " - " + string(ds_map_find_value(team, "tla"));
				}
				if (obj_master.year == 1) {
					if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() + 2) {
						slog("Draft Y1 Corrections: Junior[" + ds_map_find_value(pmap, "lname") + "] force stay");
						pickRound = -1;
						pickLabel = s_str("ui_co_Draft_SrYear");
						ds_map_set(imap, "credits", 0);
					}
					if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() + 3) {
						if (y1_balance_seniorGrad == false) {
							y1_balance_seniorGrad = true;
							slog("Draft Y1 Corrections: Senior[" + ds_map_find_value(pmap, "lname") + "] force grad");
							pickRound = 4;
							pickLabel = s_str("ui_co_Draft_Graduate");
							ds_map_set(imap, "credits", 10);
							ds_map_set(imap, "reveal_attitude", 45);
						} else {
							slog("Draft Y1 Corrections: Senior[" + ds_map_find_value(pmap, "lname") + "] force R3");
							pickRound = 3;
							pickLabel = s_str("ui_co_Draft_R3");
							ds_map_set(imap, "credits", 30);
							ds_map_set(imap, "reveal_attitude", 75);
							var team = s_college_draft_team_pick(pmap, proTeams);
							ds_map_set(imap, "team_pick", team);
							pickLabel += " - " + string(ds_map_find_value(team, "tla"));
						}
					}
				}
				ds_map_set(imap, "pick_round", pickRound);
				ds_map_set(imap, "pick_label", pickLabel);
				s += "\n    Pick: " + string(pickLabel) + " | Chances (vs " + string(draftScore) + "): R1[" + string(ds_map_find_value(imap, "pick_r1_rand")) + "]  R2[" + string(ds_map_find_value(imap, "pick_r2_rand")) + "]  R3[" + string(ds_map_find_value(imap, "pick_r3_rand")) + "]";
				ds_map_set(imap, "debug_line", s);
				ds_list_add(college_draft, imap);
				s_draft_set_epilogue(imap, pmap);
			}
		}
	}
	ds_list_destroy(proTeams);
}

function s_destroy_college_draft() {
	var sz = ds_list_size(obj_master.college_draft);
	for (var i = 0; i < sz; i++) {
		ds_map_destroy(ds_list_find_value(obj_master.college_draft, i));
	}
	ds_list_destroy(obj_master.college_draft);
	obj_master.college_draft = -4;
}

function s_display_college_draft_debug() {
	var txt_test = s_create_label(10, 10, "COLLEGE DRAFT - DEBUG STATS");
	txt_test.halign = 0;
	var tx = 10;
	var ty = 30;
	with (obj_master) {
		var sz = ds_list_size(college_draft);
		for (var i = 0; i < sz; i++) {
			var imap = ds_list_find_value(college_draft, i);
			var p_txt = s_create_label(tx, ty, "" + string(ds_map_find_value(imap, "debug_line")));
			p_txt.halign = 0;
			ty += 30;
		}
	}
	instance_create_layer(376, 224, "Instances", obj_button, { text: s_str("ui_next"), onClickAction: btn_click_college_draft_next });
}

function s_message_college_draft_pick(_arg0) {
	var pick_i = _arg0;
	slog("btn_click_college_draft_next pick_i:" + string(pick_i));
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
	var team = ds_map_find_value(imap, "team_pick");
	var msg = string_replace(s_str("msg_co_draft_pick"), "$playername", ds_map_find_value(pmap, "lname"));
	msg = string_replace(msg, "$position", s_get_string_position(ds_map_find_value(pmap, "position")));
	msg = string_replace(msg, "$round", string(ds_map_find_value(imap, "pick_round")));
	msg = string_replace(msg, "$team", ds_map_find_value(team, "name"));
	msg = string_replace(msg, "$reccred", string(ds_map_find_value(imap, "credits")));
	s_create_message(string(ds_map_find_value(pmap, "lname")), msg, s_str("ui_Continue"), "", s_message_college_draft_pick_continue, "", global.c_background, 1);
	s_college_draft_check_achievements(imap);
}

function s_college_draft_check_achievements(_arg0) {
	var pick_round = ds_map_find_value(_arg0, "pick_round");
	var year = ds_map_find_value(_arg0, "year");
	if (pick_round > 0 && pick_round < 4) {
		if (year == 3) {
			s_complete_achievement("ACH_JUNIOR_DRAFT");
		} else {
			if (pick_round == 1) {
				s_complete_achievement("ACH_SENIOR_DRAFTR1");
			}
			if (pick_round == 2) {
				s_complete_achievement("ACH_SENIOR_DRAFTR2");
			}
			if (pick_round == 3) {
				s_complete_achievement("ACH_SENIOR_DRAFTR3");
			}
		}
	} else if (year == 3) {
	} else {
		s_complete_achievement("ACH_SENIOR_GRAD");
	}
}

function s_message_college_draft_notpick(_arg0) {
	var pick_i = _arg0;
	slog("btn_click_college_draft_next pick_i:" + string(pick_i));
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
	var msg = string_replace(s_str("msg_co_draft_notpick"), "$playername", ds_map_find_value(pmap, "lname"));
	msg = string_replace(msg, "$position", s_get_string_position(ds_map_find_value(pmap, "position")));
	msg = string_replace(msg, "$reccred", string(ds_map_find_value(imap, "credits")));
	s_create_message(string(ds_map_find_value(pmap, "lname")), msg, s_str("ui_Continue"), "", s_message_college_draft_pick_continue, "", global.c_background, 1);
	s_college_draft_check_achievements(imap);
}

function s_message_college_draft_nottrydraft_y3(_arg0) {
	var pick_i = _arg0;
	slog("btn_click_college_draft_next pick_i:" + string(pick_i));
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
	var msg = string_replace(s_str("msg_co_draft_nottrydraft_y3"), "$playername", ds_map_find_value(pmap, "lname"));
	msg = string_replace(msg, "$position", s_get_string_position(ds_map_find_value(pmap, "position")));
	msg = string_replace(msg, "$teamname", s_get_team_name_by_id(obj_master.myteam_id));
	s_create_message(string(ds_map_find_value(pmap, "lname")), msg, s_str("ui_Continue"), "", s_message_college_draft_pick_continue, "", global.c_background, 1);
}

function s_message_college_draft_early_y3(_arg0) {
	var pick_i = _arg0;
	slog("btn_click_college_draft_next pick_i:" + string(pick_i));
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
	var msg = string_replace(s_str("msg_co_draft_early_y3"), "$playername", ds_map_find_value(pmap, "lname"));
	msg = string_replace(msg, "$position", s_get_string_position(ds_map_find_value(pmap, "position")));
	s_create_message3(string(ds_map_find_value(pmap, "lname")), msg, s_str("ui_Info"), s_str("ui_Yes"), s_str("ui_No"), s_message_college_earyly_info, s_message_college_earyly_yes, s_message_college_earyly_no, global.c_background, 1);
}

function s_message_college_draft_pick_continue() {
	s_college_draft_refresh_current_attitude();
	s_college_draft_refresh();
	s_msg_clear();
}

function s_message_college_earyly_yes() {
	s_msg_clear();
	if (obj_master.college_draft_skip) {
		s_college_draft_refresh_current_attitude();
		obj_master.college_draft_stage++;
		college_draft_do_skip();
	} else {
		s_message_college_draft_pick(s_college_draft_player_pick());
	}
}

function s_message_college_earyly_no() {
	var pick_i = s_college_draft_player_pick();
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	ds_map_set(imap, "pick_round", -1);
	ds_map_set(imap, "pick_label", s_str("ui_co_Draft_SrYear"));
	ds_map_set(imap, "credits", 0);
	ds_map_set(imap, "reveal_attitude", s_attitude_reduce_step(ds_map_find_value(imap, "reveal_attitude")));
	ds_map_set(imap, "reveal_attitude", s_attitude_reduce_step(ds_map_find_value(imap, "reveal_attitude")));
	if (obj_master.college_draft_skip) {
		s_msg_clear();
		s_college_draft_refresh_current_attitude();
		obj_master.college_draft_stage++;
		college_draft_do_skip();
	} else {
		s_college_draft_refresh_current_attitude();
		s_college_draft_refresh();
		s_msg_clear();
	}
}

function s_message_college_earyly_info() {
	var pick_i = s_college_draft_player_pick();
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
	obj_master.player_profile = pmap;
	obj_master.profile_back_to = 3;
	room_goto(rm_profile_player);
}

function s_college_draft_earyly_info_return() {
	room_goto(rm_draft_college);
	obj_master.college_draft_queueY3Msg = 1;
}

function s_college_draft_refresh_current_attitude() {
	var sz = ds_list_size(obj_master.college_draft);
	var pick_i = s_college_draft_player_pick();
	if (pick_i < 0 || pick_i >= sz) {
		return;
	}
	var imap = ds_list_find_value(obj_master.college_draft, pick_i);
	var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
	slog("New attitude: [" + s_get_string_attitude(ds_map_find_value(pmap, "attitude")) + "] -> [" + s_get_string_attitude(ds_map_find_value(imap, "reveal_attitude")) + "]");
	ds_map_set(pmap, "attitude", ds_map_find_value(imap, "reveal_attitude"));
}

function s_doing_college_draft() {
	if (s_is_co_mode() && variable_instance_exists(obj_master, "college_draft") && obj_master.college_draft != -4) {
		return true;
	}
	return false;
}

function s_check_college_draft_start() {
	if (!s_is_co_mode()) {
		return false;
	}
	return obj_master.college_draft_stage == -1;
}

function s_start_college_draft() {
	s_save_ranking_pos_end_of_season();
	room_goto(rm_draft_college);
	obj_master.college_draft_stage = 0;
	obj_master.college_draft_skip = 0;
	obj_master.college_draft_queueY3Msg = 0;
	s_calculate_college_draft();
}

function s_draft_set_epilogue(_arg0, _arg1) {
	var epilogue_tag = "epi_graduated";
	var reason = "graduated";
	var cv_entry = "";
	if (ds_map_find_value(_arg0, "pick_round") < 4) {
		reason = "drafted";
		cv_entry = "cv_Drafted";
		epilogue_tag = "epi_draftR" + string(ds_map_find_value(_arg0, "pick_round"));
		if (ds_map_find_value(_arg0, "year") == 3) {
			epilogue_tag += "Junior";
		} else {
			epilogue_tag += "Senior";
		}
	}
	ds_map_set(_arg0, "epilogue", s_pick_epilogue_story(epilogue_tag));
	ds_map_set(_arg0, "reason", reason);
	ds_map_set(_arg0, "curriculum_entry", cv_entry);
	ds_map_set(_arg1, "class_of", obj_master.start_year + obj_master.year);
}

function s_end_college_draft() {
	var showMsg = false;
	var sz = ds_list_size(obj_master.college_draft);
	var totCred = 0;
	for (var r = 0; r < sz; r++) {
		var imap = ds_list_find_value(obj_master.college_draft, r);
		totCred += ds_map_find_value(imap, "credits");
		s_college_draft_check_achievements(imap);
	}
	if (can_fit_recruitment_credits(totCred) == false) {
		var msg = s_str("msg_CollegeProDraftRC_NoSpace");
		var rc_space = recruitment_credits_space();
		msg = string_replace(msg, "$maxNum", totCred);
		msg = string_replace(msg, "$num", rc_space);
		s_create_message("", msg, s_str("ui_Continue"), "", s_end_college_draft_late_msg_clear, "", global.c_background, 1);
		showMsg = true;
	}
	recruitment_credits_add(totCred);
	return showMsg;
}

function s_end_college_draft_late_msg_clear() {
	s_msg_clear();
	s_end_college_draft_late();
}

function s_end_college_draft_late() {
	with (obj_player_profile) {
		instance_destroy();
	}
	var sz = ds_list_size(obj_master.college_draft);
	for (var r = sz - 1; r >= 0; r--) {
		var imap = ds_list_find_value(obj_master.college_draft, r);
		if (ds_map_find_value(imap, "pick_round") > 0 && ds_map_find_value(imap, "pick_round") < 4) {
			obj_master.pro_drafted_players += 1;
		}
		if (ds_map_find_value(imap, "pick_round") > 0) {
			var del_index = ds_map_find_value(imap, "index");
			var pmap = ds_list_find_value(obj_master.roster, ds_map_find_value(imap, "index"));
			slog("DELETING PLAYER @[" + string(del_index) + "]: " + string(ds_map_find_value(pmap, "lname")));
			ds_map_set(pmap, "class_of", obj_master.start_year + obj_master.year);
			var del = s_remove_player(pmap, ds_map_find_value(imap, "reason"), ds_map_find_value(imap, "epilogue"));
			if (del == false && pmap != -4) {
				s_add_cv_entry_from_key(pmap, "cv_Graduated");
				if (ds_map_find_value(imap, "pick_round") < 4) {
					var team = ds_map_find_value(imap, "team_pick");
					ds_map_set(pmap, "uniform_record", s_extract_uniform_cols_to_record(ds_map_find_value(team, "uid"), "uniforms_default.txt", true));
					ds_map_set(pmap, "drafted_pro_team", ds_map_find_value(team, "uid"));
					ds_map_set(pmap, "draft_round_pick", ds_map_find_value(imap, "pick_round"));
					if (ds_map_find_value(imap, "curriculum_entry") != "") {
						s_add_cv_entry_from_key(pmap, ds_map_find_value(imap, "curriculum_entry"));
					}
				}
			}
		}
	}
	s_destroy_college_draft();
	obj_master.college_draft_stage = 99;
	if (s_count_joboffers() > 0) {
		if (s_is_co_mode()) {
			s_goto_room(rm_choose_team_college, { mode: 2 });
		} else {
			room_goto(rm_choose_team);
		}
		return;
	}
	if (!s_offer_data_upgrade()) {
		s_college_draft_new_season_loading();
	}
}

function s_college_draft_new_season_loading() {
	s_loading_start(s_college_draft_new_season);
}

function s_college_draft_new_season() {
	s_start_new_season(false);
	s_play(0);
}

function btn_click_college_draft_next() {
	var d_count = ds_list_size(obj_master.college_draft);
	if (obj_master.college_draft_stage >= d_count) {
		var showMsg = s_end_college_draft();
		if (showMsg == false) {
			s_end_college_draft_late();
		}
		return;
	}
	obj_master.college_draft_stage++;
	var pick_i = s_college_draft_player_pick();
	if (pick_i >= 0 && pick_i < d_count) {
		var imap = ds_list_find_value(obj_master.college_draft, pick_i);
		var pick_round = ds_map_find_value(imap, "pick_round");
		if (pick_round > 0 && pick_round < 4) {
			if (ds_map_find_value(imap, "year") == 3) {
				s_message_college_draft_early_y3(pick_i);
			} else {
				s_message_college_draft_pick(pick_i);
			}
		} else if (ds_map_find_value(imap, "year") == 3) {
			s_message_college_draft_nottrydraft_y3(pick_i);
		} else {
			s_message_college_draft_notpick(pick_i);
		}
	}
	if (obj_master.college_draft_stage == 0) {
		s_college_draft_refresh();
	}
}

function s_college_draft_refresh() {
	if (obj_master.college_draft_stage == -1) {
		s_display_college_draft_debug();
	} else {
		s_display_college_draft_roster();
	}
}

function btn_click_college_draft_skip() {
	var d_count = ds_list_size(obj_master.college_draft);
	if (obj_master.college_draft_stage == d_count) {
		return;
	}
	obj_master.college_draft_skip = 1;
	obj_master.college_draft_stage++;
	college_draft_do_skip();
}

function college_draft_do_skip() {
	var d_count = ds_list_size(obj_master.college_draft);
	for (var i = s_college_draft_player_pick(); i < d_count; i++) {
		var pick_i = s_college_draft_player_pick();
		var imap = ds_list_find_value(obj_master.college_draft, pick_i);
		var pick_round = ds_map_find_value(imap, "pick_round");
		if (pick_round > 0 && pick_round < 4) {
			if (ds_map_find_value(imap, "year") == 3) {
				s_message_college_draft_early_y3(pick_i);
				return;
			}
		}
		s_college_draft_refresh_current_attitude();
		obj_master.college_draft_stage++;
	}
	s_display_college_draft_roster();
}

function s_college_draft_player_pick() {
	return obj_master.college_draft_stage - 1;
}

function s_display_college_draft_roster() {
	slog("s_display_college_draft_roster");
	with (obj_player_profile) {
		instance_destroy();
	}
	with (obj_text) {
		instance_destroy();
	}
	with (obj_smallbox) {
		instance_destroy();
	}
	with (obj_button) {
		instance_destroy();
	}
	with (obj_vbox) {
		instance_destroy();
	}
	var titleTxt = s_create_label(240, 10, "Draft-Eligible Players");
	titleTxt.font = global.fnt_flex;
	var sz = ds_list_size(obj_master.college_draft);
	var count = 0;
	var totCred = 0;
	var pmap, imap, pos, str, label;
	for (var r = 0; r < sz; r++) {
		imap = ds_list_find_value(obj_master.college_draft, r);
		pmap = ds_list_find_value(obj_master.roster, real(ds_map_find_value(imap, "index")));
		if (!ds_exists(pmap, 1)) {
			slogf("warning pmap instance invalid: %1", pmap);
		}
		if (ds_map_find_value(imap, "year") < 3) {
			continue;
		}
		pos = s_card_layout_pos(sz, r);
		profile[count] = instance_create_layer(pos.x, pos.y, "Instances", obj_player_profile, { pmap: pmap });
		str = "?";
		if (count < obj_master.college_draft_stage) {
			str = "" + string(ds_map_find_value(imap, "pick_label"));
			totCred += ds_map_find_value(imap, "credits");
		}
		label = s_create_label(pos.x + 35, pos.y + 85, string(str));
		label.halign = 1;
		count++;
	}
	instance_create_layer(236, 224, "Instances", obj_vbox, {
		image_xscale: 0.8,
		image_yscale: 0.25,
		text: "$" + string(totCred) + s_str("sla_Thousand"),
		title: s_str("ui_NewDonations")
	});
	if (obj_master.college_draft_stage >= sz) {
		instance_create_layer(376, 224, "Instances", obj_button, { text: s_str("ui_Continue"), onClickAction: btn_click_college_draft_next });
	} else {
		instance_create_layer(376, 224, "Instances", obj_button, { text: s_str("ui_next"), onClickAction: btn_click_college_draft_next });
		instance_create_layer(8, 224, "Instances", obj_button, { text: s_str("ui_Skip"), onClickAction: btn_click_college_draft_skip });
	}
	if (obj_master.college_draft_queueY3Msg) {
		obj_master.college_draft_queueY3Msg = 0;
		var pick_i = s_college_draft_player_pick();
		s_message_college_draft_early_y3(pick_i);
	}
}

function s_card_layout_pos(_arg0, _arg1) {
	var pos = { x: 1, y: 2 };
	var sw = 480;
	var sh = 270;
	var cw = 64;
	var ch = 80;
	var cw2 = cw / 2;
	var ch2 = ch / 2;
	var lp = 18;
	var tp = 24;
	var gap = 12;
	var yjump = 100;
	var cardsT = 0;
	var cardsB = 0;
	if (_arg0 <= 3) {
		cardsT = _arg0;
	} else {
		cardsB = _arg0 / 2;
		cardsT = _arg0 - cardsB;
	}
	var row = 0;
	var rowIndex = 0;
	var cardsR = 0;
	if (_arg1 < cardsT) {
		cardsR = cardsT;
		rowIndex = _arg1;
		row = 0;
	} else {
		cardsR = cardsB;
		rowIndex = _arg1 - cardsT;
		row = 1;
	}
	var rowW = cardsR * cw + (cardsR - 1) * gap;
	var startX = (sw - rowW) / 2 + lp / 2;
	pos.x = startX + rowIndex * cw + (rowIndex - 1) * gap;
	pos.y = tp + row * yjump;
	if (_arg0 <= 3) {
		pos.y += ch2;
	}
	return pos;
}

function s_load_pro_teams() {
	slog("s_load_pro_teams");
	var list = ds_list_create();
	var file = file_text_open_read("ProTeams_CO.txt");
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var map = ds_map_create();
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		for (var i = 0; i < array_length_1d(keys); i++) {
			ds_map_add(map, keys[i], values[i]);
		}
		ds_list_add(list, map);
	}
	file_text_close(file);
	return list;
}

