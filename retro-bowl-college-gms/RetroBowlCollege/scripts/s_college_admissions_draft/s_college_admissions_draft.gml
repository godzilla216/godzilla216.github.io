function s_check_draft_CO() {
	with (obj_master) {
		slog("s_check_draft_CO");
		slog("Week = " + string(week));
		slog("Draft = " + string(college_admissions_draft_round));
		if (intro > 0) {
			slog("s_check_draft_CO... skip: Intro");
			s_play(1);
			return;
		}
		if (s_college_admissions_check_trigger()) {
			return;
		}
		if (s_college_free_agent_check()) {
			return;
		}
		if (s_college_dilemma_check()) {
			return;
		}
		obj_master.prematch_dilemma_done = true;
		s_savegame();
		s_play(1);
	}
}

function s_college_free_agent_check() {
	var force = false;
	if (week < 2 || week > 7) {
		slog("s_college_free_agent_check skip - Week(" + string(week) + ") Out of valid week range(2-7)");
		return false;
	}
	if (offers_done) {
		slog("s_college_free_agent_check skip - Already checked this week");
		return false;
	}
	var rr = irandom(2);
	if (rr < 2) {
		slog("s_college_free_agent_check skip - 30% Random change failed");
		offers_done = true;
		return false;
	} else {
		slog("s_college_free_agent_check passed 30% chance with r[" + string(rr) + "]");
	}
	var less5 = ds_list_size(obj_master.roster) < 5;
	if (force) {
		less5 = true;
	}
	var hasQB = false;
	var hasRB = false;
	for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		if (ds_map_find_value(pmap, "position") == 1) {
			hasQB = true;
		}
		if (ds_map_find_value(pmap, "position") == 2) {
			hasRB = true;
		}
	}
	var cQB = 0;
	var cRB = 0;
	var cOther = 0;
	if (less5) {
		if (!hasQB && !hasRB) {
			cQB = 0.3;
			cRB = 0.3;
			cOther = 0.4;
		} else if (!hasQB) {
			cQB = 0.4;
			cRB = 0.1;
			cOther = 0.5;
		} else if (!hasRB) {
			cQB = 0.1;
			cRB = 0.4;
			cOther = 0.5;
		} else {
			cQB = 0.1;
			cRB = 0.1;
			cOther = 0.8;
		}
	} else if (!hasQB && !hasRB) {
		cQB = 0.5;
		cRB = 0.5;
		cOther = 0;
	} else if (!hasQB) {
		cQB = 1;
		cRB = 0;
		cOther = 0;
	} else if (!hasRB) {
		cQB = 0;
		cRB = 1;
		cOther = 0;
	} else {
		cQB = 0;
		cRB = 0;
		cOther = 0;
	}
	var cTotal = cQB + cRB + cOther;
	if (cTotal == 0) {
		slog("s_college_free_agent_check skip - Position selection chance is 0");
		return false;
	}
	var r = random_range(0, cTotal);
	var pos = -1;
	if (r <= cQB) {
		pos = 1;
	} else if (r <= cQB + cRB) {
		pos = 2;
	} else if (r <= cQB + cRB + cOther) {
		pos = s_get_required_position_no_QB_RB(false);
	}
	if (pos == -1) {
		slog("s_college_free_agent_check skip - Error. Failed pos select");
		return false;
	}
	offers_done = true;
	slog("s_college_free_agent_check: Trigger! [cQB:" + string(cQB) + " cRB:" + string(cRB) + " cOther:" + string(cOther) + " r:" + string(r) + "]");
	s_clear_freeagents();
	var pmap = s_create_player(pos, s_rookie_age_internal(), 1, 2);
	ds_map_set(pmap, "attitude", irandom_range(30, 90));
	ds_map_set(pmap, "rc_cost", 0);
	ds_map_set(pmap, "walk_on", 1);
	ds_map_set(pmap, "teamid", obj_master.myteam_id);
	s_college_correct_new_player(pmap);
	ds_map_set(pmap, "teamid", -1);
	ds_list_add(freeagentlist, pmap);
	if (force == false && s_position_already_on_roster(ds_map_find_value(pmap, "position"))) {
		slog("s_college_free_agent_check skip - Already got one of these (" + string(ds_map_find_value(pmap, "position")) + ")");
		return false;
	}
	var staffmap = -4;
	if (s_is_offensive_player(pmap)) {
		staffmap = s_get_staff(102);
	} else {
		staffmap = s_get_staff(101);
	}
	var msg = s_str("ui_WalkOnStudentOffer");
	msg = string_replace(msg, "$playername", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
	msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
	if (staffmap) {
		msg = string_replace(msg, "$coachname", s_get_player_name(staffmap, true));
	}
	s_create_message(s_str("ui_WalkOnStudent"), msg, s_str("ui_Cancel"), s_str("ui_Yes"), s_msg_clear, btn_respose_college_free_agent_yes, global.c_background, 1);
	return true;
}

function btn_respose_college_free_agent_yes() {
	room_goto(rm_freeagents);
}

function s_college_dilemma_check() {
	if (!obj_master.prematch_dilemma_done && !s_is_bye_week(obj_master.week) && obj_master.week < obj_master.last_week_regular && obj_master.year > 1) {
		if (s_do_prematch_dilemma(false)) {
			return true;
		}
	}
	return false;
}

function s_college_admissions_check_trigger() {
	if (week == 1) {
		if (college_admissions_draft_round > 0) {
			if (college_admissions_draft_round == 1) {
				s_create_draftlist();
			}
			room_goto(rm_draft);
			return true;
		}
	}
	return false;
}

function s_college_admissions_pick_player(_arg0) {
	slog("s_college_admissions_pick_player -> Drafted player at pos #" + string(_arg0) + " during round " + string(college_admissions_draft_round));
	recruitment_credits_add(-1 * ds_map_find_value(player_profile, "rc_cost"));
	ds_list_delete(draftlist, _arg0);
	var loseCount = s_college_admissions_players_lost_per_round();
	for (var i = 0; i < loseCount; i++) {
		var lPos = irandom_range(0, ds_list_size(draftlist) - 1);
		slog(".. another team picked player at pos #" + string(lPos));
		ds_list_delete(draftlist, lPos);
	}
	college_admissions_draft_round++;
	obj_master.college_admissions_doing_player_draft_sign = true;
}

function s_college_admissions_players_lost_per_round() {
	switch (college_admissions_draft_round) {
		case 1:
			return 9;
		case 2:
			return 7;
		case 3:
			return 5;
		case 4:
			return 3;
		case 5:
			return 1;
		case 6:
			return 1;
		case 7:
			return 1;
		case 8:
			return 1;
		case 9:
			return 1;
		case 10:
			return 1;
		case 11:
			return 1;
	}
	return 0;
}

function s_college_admissions_draft_done() {
	s_create_message("", s_str("ui_AdmissionsDraftConfirm"), s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_college_admissions_draft_done_yes, global.c_background, 1);
}

function btn_response_college_admissions_draft_done_yes() {
	with (obj_master) {
		college_admissions_draft_round = 0;
		s_destroy_draftlist();
		s_update_rank_after_adminssion_draft();
		s_add_news(s_str("news_DraftEnded"));
		stage = 1;
		s_savegame();
		room_goto(rm_home);
	}
}

