function s_pre_match() {
	slog("s_next_match");
	obj_master.gamepractice = 0;
	var week = obj_master.week;
	var fix = s_get_human_fixture_by_week(week);
	if (fix && ds_map_find_value(fix, "human_win") != "unplayed") {
		obj_master.week++;
		obj_master.stage = 2;
		return;
	}
	if (fix) {
		room_goto(rm_pre_match);
	} else if (week < obj_master.first_week_playoffs) {
		s_do_bye_week();
	} else if (week == obj_master.first_week_playoffs && (obj_master.myteam == s_get_division_winner_by_seed(0, 1) || obj_master.myteam == s_get_division_winner_by_seed(1, 1))) {
		s_do_bye_week();
	} else if (week <= s_get_week_superbowl()) {
		obj_master.playoff_proceed = true;
		btn_click_PlayOffs();
	} else if (!obj_master.done_season_review && obj_master.year > 1) {
		obj_master.stage = 1;
		obj_master.done_season_review = true;
		room_goto(rm_season_tally);
	} else if (s_is_co_mode()) {
		obj_master.stage = -11;
		s_create_message("", s_str("msg_TimeForProDraft"), "", s_str("ui_Continue"), "", s_continue_time_for_draft_msg, global.c_background, 1);
	} else if (s_count_joboffers() > 0) {
		room_goto(rm_choose_team);
	} else {
		s_start_new_season(false);
	}
}

function s_continue_time_for_draft_msg() {
	room_goto(rm_home);
	s_msg_clear();
}

function s_co_pre_match() {
	slog("s_co_pre_match - College: next match or next season");
	obj_master.gamepractice = 0;
	var week = obj_master.week;
	var fix = s_get_human_fixture_by_week(week);
	if (fix && ds_map_find_value(fix, "human_win") != "unplayed") {
		obj_master.week++;
		obj_master.stage = 2;
		return;
	}
	if (fix) {
		slogf("*** Enter: Next human match (season or post season)");
		if (current_room == rm_home && s_is_co_postseason()) {
			s_goto_room(rm_postseason);
		} else {
			room_goto(rm_pre_match);
		}
	} else if (week < obj_master.first_week_postseason) {
		slogf("*** Enter: Bye week");
		s_do_bye_week();
	} else if (week >= obj_master.first_week_postseason && week <= s_get_last_schedule_week()) {
		slogf("*** Enter: Postseason (non player)");
		s_goto_room(rm_postseason);
	} else if (!obj_master.done_season_review && obj_master.year > 1) {
		slogf("*** Enter: Season review");
		obj_master.stage = 1;
		obj_master.done_season_review = true;
		room_goto(rm_season_tally);
	} else if (s_is_co_mode()) {
		slogf("*** Enter: Pro draft");
		obj_master.stage = -11;
		s_create_message("", s_str("msg_TimeForProDraft"), "", s_str("ui_Continue"), "", s_continue_time_for_draft_msg, global.c_background, 1);
	} else if (s_count_joboffers() > 0) {
		slogf("*** Enter: Job offers");
		room_goto(rm_choose_team);
	} else {
		slogf("*** Enter: New season");
		s_start_new_season(false);
	}
}

