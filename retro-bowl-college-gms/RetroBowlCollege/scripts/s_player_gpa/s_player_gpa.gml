function s_gpa_from_percent_grade(_arg0) {
	if (_arg0 < 65) {
		return 0;
	}
	if (_arg0 <= 66) {
		return 1;
	}
	if (_arg0 <= 69) {
		return 1.3;
	}
	if (_arg0 <= 72) {
		return 1.7;
	}
	if (_arg0 <= 76) {
		return 2;
	}
	if (_arg0 <= 79) {
		return 2.3;
	}
	if (_arg0 <= 82) {
		return 2.7;
	}
	if (_arg0 <= 86) {
		return 3;
	}
	if (_arg0 <= 89) {
		return 3.3;
	}
	if (_arg0 <= 92) {
		return 3.7;
	}
	if (_arg0 <= 96) {
		return 4;
	}
	return 4;
}

function s_gpa_string(_arg0) {
	return string_format(s_gpa_from_percent_grade(ds_map_find_value(_arg0, "percent_grade")), 1, 1);
}

function s_gpa_string_direct(_arg0) {
	return string_format(s_gpa_from_percent_grade(_arg0), 1, 1);
}

function s_decay_percent_grade(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	s_add_percent_grade(_arg0, -1 * s_get_decay(_arg0));
}

function s_debug_recover_percent_grade(_arg0) {
	if (!s_is_co_mode()) {
		return;
	}
	s_add_percent_grade(_arg0, 5);
}

function s_post_match_gpa_refresh() {
	if (!s_is_co_mode()) {
		return;
	}
	var finishedWeek = obj_master.week - 1;
	if (finishedWeek > obj_master.last_week_regular) {
		slog("s_post_match_gpa_refresh - Skipped during playoffs w[" + string(finishedWeek) + "] lwr[" + string(obj_master.last_week_regular) + "]");
		return;
	}
	if (obj_master.byeweek_gpaup) {
		obj_master.byeweek_gpaup = false;
		slog("s_post_match_gpa_refresh - Skipped  for bye-week GPAUP dilemma");
		return;
	}
	slog("s_post_match_gpa_refresh w[" + string(finishedWeek) + "] lwr[" + string(obj_master.last_week_regular) + "]");
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "saved_percent_grade", ds_map_find_value(pmap, "percent_grade"));
			s_decay_percent_grade(pmap);
			slog(ds_map_find_value(pmap, "lname") + " percent grade decreased from " + string(ds_map_find_value(pmap, "saved_percent_grade")) + " to " + string(ds_map_find_value(pmap, "percent_grade")) + " or in GPA: " + s_gpa_string_direct(ds_map_find_value(pmap, "percent_grade")));
		}
	}
}

function s_add_percent_grade(_arg0, _arg1) {
	if (!s_is_co_mode()) {
		return;
	}
	var minPR = 60;
	var maxPR = ds_map_find_value(_arg0, "max_percent_grade");
	var wantedPR = ds_map_find_value(_arg0, "percent_grade") + _arg1;
	slog("s_add_percent_grade . minPR[" + string(minPR) + "] maxPR[" + string(maxPR) + "] wantedPR[" + string(wantedPR) + "] ");
	var newPG = clamp(wantedPR, minPR, maxPR);
	slog("s_add_percent_grade . grade boost[" + string(_arg1) + "] PG[" + string(ds_map_find_value(_arg0, "percent_grade")) + "/" + s_gpa_string_direct(ds_map_find_value(_arg0, "percent_grade")) + "]->[" + string(newPG) + "/" + s_gpa_string_direct(newPG) + "] maxPR[" + string(maxPR) + "] minPR[" + string(minPR) + "]");
	ds_map_set(_arg0, "percent_grade", newPG);
	s_refresh_suspended(_arg0, true);
}

function s_get_decay(_arg0) {
	if (!s_is_co_mode()) {
		return 0;
	}
	var pmap = _arg0;
	var decay = 0.8;
	if (s_player_benched(pmap) || ds_map_find_value(pmap, "condition") <= -1) {
		decay = -2;
	} else {
		switch (s_get_training_reg(pmap)) {
			case 1:
				decay += -0.5;
				break;
			case 2:
				break;
			case 3:
				decay += 1.5;
				break;
		}
	}
	return decay;
}

function s_get_decay_info(_arg0) {
	var pmap = _arg0;
	var decayExt = "";
	if (s_player_benched(pmap) || ds_map_find_value(pmap, "condition") <= -1) {
		decayExt = "Benched|Injured[" + string(-2) + "]";
	} else {
		decayExt = "Base[" + string(0.8) + "] ";
		switch (s_get_training_reg(pmap)) {
			case 1:
				decayExt += " Train(L)[" + string(-0.5) + "]";
				break;
			case 2:
				break;
			case 3:
				decayExt += " Train(H)[" + string(1.5) + "]";
				break;
		}
	}
	var msg = "Percent[" + string(ds_map_find_value(pmap, "percent_grade")) + "%]->GPA[" + string(s_gpa_from_percent_grade(ds_map_find_value(pmap, "percent_grade"))) + "] MAX Grade[" + string(ds_map_find_value(pmap, "max_percent_grade")) + "]";
	msg += " Decay:" + string(s_get_decay(pmap)) + "(" + decayExt + ")";
	msg += " Suspend (Player):" + string(s_player_grade_suspend(pmap)) + "% Lift Susp:" + string(s_player_grade_lift_suspension(pmap)) + "% " + " (Academics:" + string(s_my_team_academics()) + ")";
	msg += " " + s_player_gpa_colors_info(pmap);
	return msg;
}

function s_refresh_suspended(_arg0, _arg1) {
	if (!s_is_co_mode()) {
		return;
	}
	var wasSus = ds_map_find_value(_arg0, "suspended");
	if (ds_map_find_value(_arg0, "percent_grade") <= s_player_grade_suspend(_arg0)) {
		slog("Suspended!");
		ds_map_set(_arg0, "suspended", 1);
	}
	if (ds_map_find_value(_arg0, "percent_grade") >= s_player_grade_lift_suspension(_arg0)) {
		slog("Un-Suspended!");
		ds_map_set(_arg0, "suspended", 0);
	}
	if (_arg1) {
		if (wasSus == 0 && ds_map_find_value(_arg0, "suspended") == 1) {
			s_add_news_if_new(s_parse_player_message(s_str("msg_Suspended"), _arg0));
		}
		if (wasSus == 1 && ds_map_find_value(_arg0, "suspended") == 0) {
			s_remove_news(s_parse_player_message(s_str("msg_Suspended"), _arg0));
		}
	}
}

function s_get_percent_grade_squad() {
	var con = 0;
	with (obj_master) {
		var size = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "percent_grade") > 0) {
				con += ds_map_find_value(pmap, "percent_grade");
				size++;
			}
		}
		if (size > 0) {
			con /= size;
		}
		return round(con);
	}
}

function btn_click_Boost_GPA() {
	if (obj_master.boost_gpa_done) {
		s_create_message("", s_str("msg_BoostGPAAlreadyDone"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else if (25 > obj_master.coach_credit) {
		var msg = s_str("msg_BoostGPANoCredit");
		msg = string_replace(msg, "$num", string(25));
		s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else {
		var msg = s_str("msg_BoostGPA");
		msg = string_replace(msg, "$num", string(25));
		s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_boost_gpa, global.c_background, 1);
	}
}

function btn_response_boost_gpa() {
	s_msg_clear();
	with (obj_master) {
		boost_gpa_done = true;
		coach_credit -= 25;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			s_add_percent_grade(ds_list_find_value(roster, i), 20);
		}
		s_team_halve_all_party_meters();
		s_create_message("", s_str("msg_BoostGPAEvent" + string(irandom(5))), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	}
}

function s_my_team_academics() {
	var tmap = s_get_team_by_id(obj_master.myteam_id);
	if (is_undefined(tmap)) {
		return 0;
	}
	return ds_map_find_value(tmap, "academics");
}

function s_player_grade_suspend(_arg0) {
	var age = ds_map_find_value(_arg0, "age");
	return s_player_grade_suspend_from_age(age);
}

function s_player_grade_suspend_from_age(_arg0) {
	var academics = s_my_team_academics();
	switch (academics) {
		case 0:
			if (_arg0 == s_rookie_age_internal()) {
				return 64;
			}
			if (_arg0 == s_rookie_age_internal() + 1) {
				return 64;
			}
			if (_arg0 == s_rookie_age_internal() + 2) {
				return 66;
			}
			if (_arg0 == s_rookie_age_internal() + 3) {
				return 66;
			}
		case 1:
			if (_arg0 == s_rookie_age_internal()) {
				return 64;
			}
			if (_arg0 == s_rookie_age_internal() + 1) {
				return 66;
			}
			if (_arg0 == s_rookie_age_internal() + 2) {
				return 69;
			}
			if (_arg0 == s_rookie_age_internal() + 3) {
				return 69;
			}
		case 2:
			if (_arg0 == s_rookie_age_internal()) {
				return 64;
			}
			if (_arg0 == s_rookie_age_internal() + 1) {
				return 69;
			}
			if (_arg0 == s_rookie_age_internal() + 2) {
				return 72;
			}
			if (_arg0 == s_rookie_age_internal() + 3) {
				return 72;
			}
		case 3:
			if (_arg0 == s_rookie_age_internal()) {
				return 66;
			}
			if (_arg0 == s_rookie_age_internal() + 1) {
				return 72;
			}
			if (_arg0 == s_rookie_age_internal() + 2) {
				return 76;
			}
			if (_arg0 == s_rookie_age_internal() + 3) {
				return 76;
			}
	}
	slog("ERROR! Unexpected team academics(" + string(academics) + ") range is 0-3 or player age(" + string(_arg0) + ")");
	return 60;
}

function s_player_grade_lift_suspension() {
	var academics = s_my_team_academics();
	switch (academics) {
		case 0:
			return 70;
		case 1:
			return 73;
		case 2:
			return 76;
		case 3:
			return 80;
	}
	slog("ERROR! Unexpected team academics(" + string(academics) + ") range is 0-3");
	return 70;
}

function s_gpa_step_from_percent_grade(_arg0) {
	if (_arg0 < 65) {
		return 0;
	}
	if (_arg0 <= 66) {
		return 1;
	}
	if (_arg0 <= 69) {
		return 2;
	}
	if (_arg0 <= 72) {
		return 3;
	}
	if (_arg0 <= 76) {
		return 4;
	}
	if (_arg0 <= 79) {
		return 5;
	}
	if (_arg0 <= 82) {
		return 6;
	}
	if (_arg0 <= 86) {
		return 7;
	}
	if (_arg0 <= 89) {
		return 8;
	}
	if (_arg0 <= 92) {
		return 9;
	}
	if (_arg0 <= 96) {
		return 10;
	}
	return 10;
}

function s_percent_grade_from_gpa_step_UPPER(_arg0) {
	if (_arg0 == 0) {
		return 64;
	}
	if (_arg0 == 1) {
		return 66;
	}
	if (_arg0 == 2) {
		return 69;
	}
	if (_arg0 == 3) {
		return 72;
	}
	if (_arg0 == 4) {
		return 76;
	}
	if (_arg0 == 5) {
		return 79;
	}
	if (_arg0 == 6) {
		return 82;
	}
	if (_arg0 == 7) {
		return 86;
	}
	if (_arg0 == 8) {
		return 89;
	}
	if (_arg0 == 9) {
		return 92;
	}
	if (_arg0 == 10) {
		return 96;
	}
	return 10;
}

function s_player_gpa_color(_arg0) {
	if (!s_is_co_mode()) {
		return 16777215;
	}
	var pPG = ds_map_find_value(_arg0, "percent_grade");
	var susPG = s_player_grade_suspend(_arg0);
	var pSt = s_gpa_step_from_percent_grade(pPG);
	var susSt = s_gpa_step_from_percent_grade(susPG);
	if (pSt >= 6) {
		return 16777215;
	}
	if (pSt <= susSt) {
		return 255;
	}
	if (pSt <= susSt + 1) {
		return 4235519;
	}
	if (pSt <= susSt + 3) {
		return 65535;
	}
	return 16777215;
}

function s_player_gpa_colors_info(_arg0) {
	var pPG = ds_map_find_value(_arg0, "percent_grade");
	var susPG = s_player_grade_suspend(_arg0);
	var pSt = s_gpa_step_from_percent_grade(pPG);
	var susSt = s_gpa_step_from_percent_grade(susPG);
	var s = "Colors grade[" + string(pPG) + "|" + string(pSt) + "] susGrade[" + string(susPG) + "|" + string(susSt) + "] ";
	s += "RED[" + string(s_percent_grade_from_gpa_step_UPPER(susSt)) + "] ";
	s += "ORANGE[" + string(s_percent_grade_from_gpa_step_UPPER(susSt + 1)) + "] ";
	s += "YELLOW[" + string(s_percent_grade_from_gpa_step_UPPER(susSt + 3)) + "]";
	return s;
}

