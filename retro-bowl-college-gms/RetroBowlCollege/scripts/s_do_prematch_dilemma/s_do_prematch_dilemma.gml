function s_do_prematch_dilemma(_arg0) {
	slog("s_do_prematch_dilemma START (chained count: " + string(obj_master.prematch_dilemma_shown_count) + ")");
	with (obj_master) {
		obj_master.prematch_dilemma_done = true;
		if (!s_get_human_fixture_next()) {
			return false;
		}
		var msg = "";
		var pmap = s_get_random_player(true, prematch_dilemma_chosen_players);
		var smap = s_get_staff(101);
		var dilemmas = ds_list_create();
		if (pmap == -4) {
			slog("Invalid PMAP (likely we've run out of fresh players in test/chained dilemmas) Discarded/Roster: [" + string(ds_list_size(prematch_dilemma_chosen_players)) + "/" + string(ds_list_size(roster)) + "] - Refreshing discard pile and picking new.");
			ds_list_clear(prematch_dilemma_chosen_players);
			pmap = s_get_random_player(true, prematch_dilemma_chosen_players);
		}
		if (pmap == -4) {
			slog2("ERROR! Invalid PMAP! - Aborting s_do_prematch_dilemma");
			return false;
		}
		slog("s_do_prematch_dilemma START chosen player[" + ds_map_find_value(pmap, "fname") + ds_map_find_value(pmap, "lname") + "]");
		if (irandom(2) && year > 1 || _arg0) {
			ds_list_add(prematch_dilemma_chosen_players, pmap);
			if (s_is_co_mode()) {
				s_get_college_dilemmas(pmap, smap, dilemmas);
			} else {
				s_get_standard_dilemmas(pmap, smap, dilemmas);
			}
			for (var i = 0; i < ds_list_size(dilemmas); i++) {
				slog("List: " + ds_list_find_value(dilemmas, i));
			}
			ds_list_shuffle(dilemmas);
			msg = s_choose_dilemma(ds_list_find_value(dilemmas, 0));
			slog("s_do_prematch_dilemma: " + msg);
		}
		if (string_count("dilemma_", msg)) {
			ds_map_destroy(map_dilemma);
			map_dilemma = -1;
			map_dilemma = s_parse_dilemma(msg, pmap, "ui_Dilemma");
			obj_master.player_profile = pmap;
			s_create_dilemma(map_dilemma);
			ds_list_destroy(dilemmas);
			dilemmas = -1;
			return true;
		} else if (string_count("news_", msg)) {
			obj_master.news_dilemma = msg;
			obj_master.player_profile = pmap;
			s_create_dilemma_news();
			ds_list_destroy(dilemmas);
			dilemmas = -1;
			return true;
		}
		ds_list_destroy(dilemmas);
		dilemmas = -1;
		return false;
	}
}

function s_create_dilemma_news() {
	var msg = obj_master.news_dilemma;
	var pmap = obj_master.player_profile;
	if (string_count("news_CharityWork", msg)) {
		msg = s_parse_player_message(s_str(msg), pmap);
		s_meter_change(1, obj_master.fans, -4, msg);
		obj_master.fans += 2;
	} else if (string_count("news_playerleaves_toxic", msg)) {
		msg = s_parse_player_message(s_str(msg), pmap);
		obj_master.profile_back_to = 2;
		s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end_toxic_max, "", global.c_background, 1, pmap);
	} else if (string_count("news_playerleaves_party", msg)) {
		msg = s_parse_player_message(s_str(msg), pmap);
		obj_master.profile_back_to = 2;
		s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end_party_max, "", global.c_background, 1, pmap);
	} else if (string_count("news_playerleaves_gpa", msg)) {
		msg = s_parse_player_message(s_str(msg), pmap);
		obj_master.profile_back_to = 2;
		s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_cut_player_end_gpa, "", global.c_background, 1, pmap);
	} else {
		msg = s_parse_player_message(s_str(msg), pmap);
		s_create_message(s_str("ui_News"), msg, s_str("ui_Continue"), "", s_clear_msg_and_back, "", global.c_background, 1);
	}
}

function s_clear_msg_and_back() {
	obj_master.profile_back_to = -1;
	s_msg_clear();
}

function s_get_standard_dilemmas(_arg0, _arg1, _arg2) {
	slog(" s_do_prematch_dilemma choosing standard dilemmas");
	with (obj_master) {
		ds_list_add(_arg2, "dilemma_Owner");
		if (_arg0) {
			if (s_is_offensive_player(_arg0)) {
				_arg1 = s_get_staff(102);
			}
			if (!s_player_benched(_arg0) && ds_map_find_value(_arg0, "condition") > 0 && ds_map_find_value(_arg0, "condition") < 20 && week < obj_master.last_week_regular) {
				ds_list_add(_arg2, "dilemma_RestPlayer");
			}
			if (ds_map_find_value(_arg0, "attitude") <= 30) {
				ds_list_add(_arg2, "dilemma_toxic");
			}
			if (_arg1 && (ds_map_find_value(_arg0, "attitude") <= 30 || ds_map_find_value(_arg1, "attitude") <= 30)) {
				ds_list_add(_arg2, "dilemma_Coach_BustUp");
			}
			if (ds_map_find_value(_arg0, "attitude") <= 60) {
				ds_list_add(_arg2, "dilemma_late");
			}
			if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal()) {
				ds_list_add(_arg2, "dilemma_rookie");
			}
			if (ds_map_find_value(_arg0, "attitude") > 90 && obj_master.fans < 98) {
				ds_list_add(_arg2, "news_CharityWork");
			} else {
				ds_list_add(_arg2, "dilemma_random");
			}
		}
	}
}

function s_dilemma_defend_player_cost(_arg0, _arg1) {
	var cc_cost = -1;
	if (s_is_co_mode()) {
		if (string_pos("dilemma_leaverescue_gpa", _arg0)) {
			cc_cost = s_str_real("dlr_gpa_cost");
		}
		if (string_pos("dilemma_leaverescue_toxic", _arg0)) {
			if (ds_map_find_value(_arg1, "toxic_dilemmas") == 1) {
				cc_cost = s_str_real("dlr_toxic_cost_2nd");
			} else if (ds_map_find_value(_arg1, "toxic_dilemmas") == 2) {
				cc_cost = s_str_real("dlr_toxic_cost_3rd");
			} else {
				cc_cost = s_str_real("dlr_toxic_cost");
			}
		}
		if (string_pos("dilemma_leaverescue_party", _arg0)) {
			if (ds_map_find_value(_arg1, "party_dilemmas") == 1) {
				cc_cost = s_str_real("dlr_party_cost_2nd");
			} else if (ds_map_find_value(_arg1, "party_dilemmas") == 2) {
				cc_cost = s_str_real("dlr_party_cost_3rd");
			} else {
				cc_cost = s_str_real("dlr_party_cost");
			}
		}
	}
	return cc_cost;
}

function s_can_afford_dilemma_cc(_arg0, _arg1) {
	var cc_cost = s_dilemma_defend_player_cost(_arg0, _arg1);
	if (obj_master.coach_credit + cc_cost < 0) {
		return false;
	}
	return true;
}

function s_get_college_dilemmas(_arg0, _arg1, _arg2) {
	slog(" s_do_prematch_dilemma choosing college dilemmas");
	with (obj_master) {
		ds_list_add(_arg2, "dilemma_Owner");
		ds_list_add(_arg2, "dilemma_hobby");
		var leaveRescueAllowed = true;
		if (global.browser) {
			leaveRescueAllowed = false;
		}
		if (_arg0) {
			if (s_is_offensive_player(_arg0)) {
				_arg1 = s_get_staff(102);
			}
			if (!s_player_benched(_arg0) && ds_map_find_value(_arg0, "condition") > 0 && ds_map_find_value(_arg0, "condition") < 20 && week < obj_master.last_week_regular) {
				ds_list_add(_arg2, "dilemma_RestPlayer");
			}
			if (ds_map_find_value(_arg0, "attitude") <= 30) {
				var isLeaveRescue = false;
				var canAfford = s_can_afford_dilemma_cc("dilemma_leaverescue_toxic", _arg0);
				if (leaveRescueAllowed || canAfford) {
					if (ds_map_find_value(_arg0, "toxic_dilemmas") == 0) {
						isLeaveRescue = false;
					} else if (ds_map_find_value(_arg0, "toxic_dilemmas") == 1) {
						isLeaveRescue = random(1) < 0.3;
					} else if (ds_map_find_value(_arg0, "toxic_dilemmas") == 2) {
						isLeaveRescue = random(1) < 0.6;
					} else {
						isLeaveRescue = random(1) < 0.9;
					}
				} else if (ds_map_find_value(_arg0, "toxic_dilemmas") == 0) {
					isLeaveRescue = false;
				} else if (ds_map_find_value(_arg0, "toxic_dilemmas") == 1) {
					isLeaveRescue = random(1) < 0;
				} else if (ds_map_find_value(_arg0, "toxic_dilemmas") == 2) {
					isLeaveRescue = random(1) < 0.3;
				} else {
					isLeaveRescue = random(1) < 0.4;
				}
				if (obj_master.year < 3 && 1) {
					isLeaveRescue = false;
				}
				if (isLeaveRescue) {
					if (leaveRescueAllowed) {
						ds_list_add(_arg2, "dilemma_leaverescue_toxic");
					} else {
						ds_list_add(_arg2, "news_playerleaves_toxic");
					}
				} else {
					ds_list_add(_arg2, "dilemma_toxic");
				}
			}
			if (ds_map_find_value(_arg0, "attitude") <= 60) {
				if (ds_map_find_value(_arg0, "party_meter") >= 60) {
					ds_list_add(_arg2, "dilemma_hangover_party");
				} else {
					ds_list_add(_arg2, "dilemma_late");
				}
			}
			if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal()) {
				ds_list_add(_arg2, "dilemma_rookie");
			}
			if (ds_map_find_value(_arg0, "attitude") > 90 && obj_master.fans < 98) {
				ds_list_add(_arg2, "news_CharityWork");
			} else {
				ds_list_add(_arg2, "dilemma_random");
			}
			if (ds_map_find_value(_arg0, "suspended") == 1) {
				if (leaveRescueAllowed) {
					ds_list_add(_arg2, "dilemma_leaverescue_gpa");
				} else {
					ds_list_add(_arg2, "news_playerleaves_gpa");
				}
			}
			if (ds_map_find_value(_arg0, "percent_grade") >= 68 && ds_map_find_value(_arg0, "percent_grade") <= 82) {
				ds_list_add(_arg2, "dilemma_study");
			}
			if (ds_map_find_value(_arg0, "party_meter") >= 85) {
				ds_list_clear(_arg2);
				var isLeaveRescue = false;
				var canAfford = s_can_afford_dilemma_cc("dilemma_leaverescue_party", _arg0);
				if (leaveRescueAllowed || canAfford) {
					if (ds_map_find_value(_arg0, "party_dilemmas") == 0) {
						isLeaveRescue = false;
					} else if (ds_map_find_value(_arg0, "party_dilemmas") == 1) {
						isLeaveRescue = random(1) < 0.3;
					} else if (ds_map_find_value(_arg0, "party_dilemmas") == 2) {
						isLeaveRescue = random(1) < 0.6;
					} else {
						isLeaveRescue = random(1) < 0.9;
					}
				} else if (ds_map_find_value(_arg0, "party_dilemmas") == 0) {
					isLeaveRescue = false;
				} else if (ds_map_find_value(_arg0, "party_dilemmas") == 1) {
					isLeaveRescue = random(1) < 0;
				} else if (ds_map_find_value(_arg0, "party_dilemmas") == 2) {
					isLeaveRescue = random(1) < 0.2;
				} else {
					isLeaveRescue = random(1) < 0.3;
				}
				if (obj_master.year < 3 && 1) {
					isLeaveRescue = false;
				}
				if (isLeaveRescue) {
					if (leaveRescueAllowed) {
						ds_list_add(_arg2, "dilemma_leaverescue_party");
					} else {
						ds_list_add(_arg2, "news_playerleaves_party");
					}
				} else {
					ds_list_add(_arg2, "dilemma_party");
				}
			}
		}
	}
}

