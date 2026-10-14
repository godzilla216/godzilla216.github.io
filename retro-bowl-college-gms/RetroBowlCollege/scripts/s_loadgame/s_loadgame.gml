function btn_click_LoadSlot1() {
	btn_click_slot(1, global.g_savename1, false);
}

function btn_click_LoadSlot2() {
	btn_click_slot(2, global.g_savename2, false);
}

function btn_click_LoadSlot3() {
	btn_click_slot(3, global.g_savename3, false);
}

function btn_click_LoadSlot4() {
	btn_click_slot(4, global.g_savename4, false);
}

function btn_click_LoadSlot5() {
	btn_click_slot(5, global.g_savename5, false);
}

function btn_click_slot(_arg0, _arg1, _arg2) {
	ds_map_set(obj_master.map_options, "saveslot", _arg0);
	s_save_options();
	s_destroy_master();
	if (file_exists(_arg1)) {
		if (_arg2) {
			s_loading_start(s_master_load_from_backup);
		} else {
			s_loading_start(s_master_load);
		}
	} else {
		instance_create_layer(0, 0, "Instances", obj_master);
		room_goto(rm_details);
	}
}

function s_master_load() {
	instance_create_layer(0, 0, "Instances", obj_master);
	room_goto(rm_home);
}

function s_master_load_from_backup() {
	instance_create_layer(0, 0, "Instances", obj_master);
	obj_master.gamestarts += 100;
	room_goto(rm_home);
}

function s_loadgame(_arg0) {
	with (obj_master) {
		slog("loading save data: " + _arg0);
		ini_open(_arg0);
		if (s_is_co_mode()) {
			data_version = ini_read_real("savegame", "data_version", 1);
			year_offset = ini_read_real("savegame", "year_offset", 0);
		}
		start_year = ini_read_real("savegame", "start_year", 2021);
		year_stagger = ini_read_real("savegame", "year_stagger", s_get_schedule_year_stagger());
		last_week_regular = ini_read_real("savegame", "last_week_regular", 17);
		first_week_playoffs = ini_read_real("savegame", "first_week_playoffs", 18);
		year = ini_read_real("savegame", "year", 1);
		week = ini_read_real("savegame", "week", 1);
		stage = ini_read_real("savegame", "stage", 1);
		intro = ini_read_real("savegame", "intro", 1);
		fname = ini_read_string("savegame", "fname", "");
		lname = ini_read_string("savegame", "lname", "");
		qb_mode = ini_read_real("savegame", "qb_mode", 0);
		co_mode = ini_read_real("savegame", "co_mode", 0);
		fr_mode = ini_read_real("savegame", "fr_mode", 1);
		fname_coach = ini_read_string("savegame", "fname_coach", "");
		lname_coach = ini_read_string("savegame", "lname_coach", "");
		starrating = ini_read_real("savegame", "starrating", 0);
		relationship_boss = ini_read_real("savegame", "relationship_boss", 50);
		qb_salary = ini_read_real("savegame", "qb_salary", 1);
		qb_tdbonus = ini_read_real("savegame", "qb_tdbonus", 1);
		qb_training_hiscore = ini_read_real("savegame", "qb_training_hiscore", 0);
		qb_nrg = ini_read_real("savegame", "qb_nrg", 1);
		myteam_id = ini_read_real("savegame", "myteam_id", 0);
		slog("loading myteam_id " + string(myteam_id));
		myface_x = ini_read_real("savegame", "myface_x", -1);
		myface_y = ini_read_real("savegame", "myface_y", -1);
		favourite_team_id = ini_read_real("savegame", "favourite_team_id", 0);
		suppress_difficulty = ini_read_real("savegame", "suppress_difficulty", 5);
		salary_cap = ini_read_real("savegame", "salary_cap", 150);
		if (salary_cap < 150) {
			salary_cap = 150;
		}
		if (global.console_build || 0) {
			salary_cap = 200;
		}
		boost_salary_cap = abs(ini_read_real("savegame", "boost_salary_cap", 0));
		prematch_dilemma_done = ini_read_real("savegame", "prematch_dilemma_done", 0);
		tip_count = ini_read_real("savegame", "tip_count", 0);
		matchcount = ini_read_real("savegame", "matchcount", 0);
		gamestarts = ini_read_real("savegame", "gamestarts", 0);
		timeout_message_done = ini_read_real("savegame", "timeout_message_done", 0);
		bullet_throw_message_done = ini_read_real("savegame", "bullet_throw_message_done", 0);
		tag_hof_message_done = ini_read_real("savegame", "tag_hof_message_done", 0);
		tag_kr_message_done = ini_read_real("savegame", "tag_kr_message_done", 0);
		season_credits_purchased = ini_read_real("savegame", "season_credits_purchased", 0);
		op_ball = ini_read_real("savegame", "op_ball", 0);
		coach_credit = ini_read_real("savegame", "coach_credit", 0);
		purchased_credit = ini_read_real("savegame", "purchased_credit", 0);
		coach_rating = ini_read_real("savegame", "coach_rating", 1);
		fans = ini_read_real("savegame", "fans", 30);
		facility_stadium = ini_read_real("savegame", "facility_stadium", 1);
		facility_training = ini_read_real("savegame", "facility_training", 1);
		facility_rehab = ini_read_real("savegame", "facility_rehab", 1);
		facility_upgraded_stadium = ini_read_real("savegame", "facility_upgraded_stadium", 0);
		facility_upgraded_training = ini_read_real("savegame", "facility_upgraded_training", 0);
		facility_upgraded_rehab = ini_read_real("savegame", "facility_upgraded_rehab", 0);
		training_reg_df = ini_read_real("savegame", "training_reg_df", 2);
		training_reg_of = ini_read_real("savegame", "training_reg_of", 2);
		draft_round = ini_read_real("savegame", "draft_round", 0);
		draft_picks[0] = ini_read_real("savegame", "draft_picks_0", 0);
		draft_picks[1] = ini_read_real("savegame", "draft_picks_1", 0);
		draft_picks[2] = ini_read_real("savegame", "draft_picks_2", 0);
		draft_info_done = ini_read_real("savegame", "draft_info_done", 0);
		expiredcontract_msg_done = ini_read_real("savegame", "expiredcontract_msg_done", 0);
		offers_done = ini_read_real("savegame", "offers_done", 0);
		op_difficulty = ini_read_real("savegame", "op_difficulty", 0);
		op_matchlength = ini_read_real("savegame", "op_matchlength", 0);
		op_autorun = ini_read_real("savegame", "op_autorun", 1);
		op_autorun_p2 = ini_read_real("savegame", "op_autorun_p2", 1);
		name_conf1 = ini_read_string("savegame", "name_conf1", s_str("conf_AFC"));
		slog(">>>>>>>>>>>>>>>>>>>>>>> " + name_conf1);
		name_conf2 = ini_read_string("savegame", "name_conf2", s_str("conf_NFC"));
		name_div1 = ini_read_string("savegame", "name_div1", s_str("division_East"));
		name_div2 = ini_read_string("savegame", "name_div2", s_str("division_West"));
		name_div3 = ini_read_string("savegame", "name_div3", s_str("division_North"));
		name_div4 = ini_read_string("savegame", "name_div4", s_str("division_South"));
		name_div1b = ini_read_string("savegame", "name_div1b", s_str("division_East"));
		name_div2b = ini_read_string("savegame", "name_div2b", s_str("division_West"));
		name_div3b = ini_read_string("savegame", "name_div3b", s_str("division_North"));
		name_div4b = ini_read_string("savegame", "name_div4b", s_str("division_South"));
		newslist = ds_list_create();
		list_news_dyn = ds_list_create();
		dilemma_tags = ds_list_create();
		news_tags = ds_list_create();
		teamlist = ds_list_create();
		achievements = ds_list_create();
		records = ds_list_create();
		history = ds_list_create();
		schedule = ds_list_create();
		fixturelist = ds_list_create();
		playoffs = ds_list_create();
		draftlist = ds_list_create();
		hirelist = ds_list_create();
		storelist = ds_list_create();
		tradelist = ds_list_create();
		freeagentlist = ds_list_create();
		roster = ds_list_create();
		stafflist = ds_list_create();
		hoflist = ds_list_create();
		rbhistorylist = ds_list_create();
		shoppinglist = ds_list_create();
		list_teams_rejected = ds_list_create();
		face_grid_L = ds_grid_create(8, 3);
		face_grid_M = ds_grid_create(8, 1);
		face_grid_D = ds_grid_create(8, 8);
		face_grid_C = ds_grid_create(9, 4);
		ds_grid_clear(face_grid_L, 0);
		ds_grid_clear(face_grid_M, 0);
		ds_grid_clear(face_grid_D, 0);
		ds_grid_clear(face_grid_C, 0);
		ds_list_read(newslist, ini_read_string("savegame", "news", "0"));
		ds_list_read(dilemma_tags, ini_read_string("savegame", "dilemma_tags", "0"));
		ds_list_read(news_tags, ini_read_string("savegame", "news_tags", "0"));
		var size, map, pmap, str;
		size = ini_read_real("savegame", "news_dyn", 0);
		slog("news_dyn list size=" + string(size));
		for (var r = 0; r < size; r++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "news_dyn_" + string(r), ""));
			ds_list_add(list_news_dyn, map);
		}
		size = ini_read_real("savegame", "teamlist", 0);
		slog("teamlist size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "teamlist_" + string(m), ""));
			ds_list_add(teamlist, map);
		}
		s_set_teams_min_max_ids();
		size = ini_read_real("savegame", "achievements", 0);
		slog("achievements size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "achievements_" + string(m), ""));
			ds_list_add(achievements, map);
		}
		s_update_maplist_from_file(achievements, "Achievements.txt");
		size = ini_read_real("savegame", "records", 0);
		slog("records size=" + string(size));
		if (size == 0) {
			records = s_load_map_file("PlayerRecords.txt");
			size = ds_list_size(records);
			slog("new records size=" + string(size));
		} else {
			for (var m = 0; m < size; m++) {
				map = ds_map_create();
				ds_map_read(map, ini_read_string("savegame", "records_" + string(m), ""));
				if (ds_map_find_value(map, "tag") == "ui_MostSacksGame" || ds_map_find_value(map, "tag") == "ui_MostSacksSeason" || ds_map_find_value(map, "tag") == "ui_MostSacksCareer" || ds_map_find_value(map, "tag") == "ui_MostTacklesGame" || ds_map_find_value(map, "tag") == "ui_MostTacklesSeason" || ds_map_find_value(map, "tag") == "ui_MostTacklesCareer") {
					if (string_count(s_get_string_position(5) + " ", ds_map_find_value(map, "playername")) > 0) {
						continue;
					}
				}
				ds_list_add(records, map);
			}
			s_update_maplist_from_file(records, "PlayerRecords.txt");
		}
		size = ini_read_real("savegame", "history", 0);
		slog("history size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "history_" + string(m), ""));
			ds_list_add(history, map);
		}
		size = ini_read_real("savegame", "schedule", 0);
		slog("schedule size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "schedule_" + string(m), ""));
			ds_list_add(schedule, map);
		}
		size = ini_read_real("savegame", "fixturelist", 0);
		slog("fixture size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "fixture_" + string(m), ""));
			ds_list_add(fixturelist, map);
		}
		slogf("my fix list size: %1", ds_list_size(fixturelist));
		size = ini_read_real("savegame", "playoffs", 0);
		slog("play-off size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "playoff_" + string(m), ""));
			ds_list_add(playoffs, map);
		}
		size = ini_read_real("savegame", "draftlist", 0);
		slog("draft size=" + string(size));
		for (var d = 0; d < size; d++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "draftlist_" + string(d), ""));
			s_check_for_return_stats(map);
			ds_list_add(draftlist, map);
		}
		size = ini_read_real("savegame", "hirelist", 0);
		slog("hire list size=" + string(size));
		for (var d = 0; d < size; d++) {
			var map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "hirelist_" + string(d), ""));
			ds_list_add(hirelist, map);
		}
		size = ini_read_real("savegame", "storelist", 0);
		slog("storelist size=" + string(size));
		for (var d = 0; d < size; d++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "storelist_" + string(d), ""));
			if (s_is_player_pmap_corrupt(map)) {
				ds_map_destroy(map);
				map = -1;
				continue;
			}
			s_check_for_return_stats(map);
			ds_list_add(storelist, map);
		}
		size = ini_read_real("savegame", "tradelist", 0);
		slog("tradelist size=" + string(size));
		for (var r = 0; r < size; r++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "tradelist_" + string(r), ""));
			if (s_is_player_pmap_corrupt(map)) {
				ds_map_destroy(map);
				map = -1;
				continue;
			}
			s_check_for_return_stats(map);
			ds_list_add(tradelist, map);
		}
		size = ini_read_real("savegame", "freeagentlist", 0);
		slog("freeagentlist size=" + string(size));
		for (var r = 0; r < size; r++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "freeagentlist_" + string(r), ""));
			if (s_is_player_pmap_corrupt(map)) {
				ds_map_destroy(map);
				map = -1;
				continue;
			}
			s_check_for_return_stats(map);
			ds_list_add(freeagentlist, map);
		}
		size = ini_read_real("savegame", "roster", 0);
		slog("roster size=" + string(size));
		for (var r = 0; r < size; r++) {
			pmap = ds_map_create();
			ds_map_read(pmap, ini_read_string("savegame", "roster_" + string(r), ""));
			if (s_is_player_pmap_corrupt(pmap)) {
				ds_map_destroy(pmap);
				pmap = -1;
				continue;
			}
			s_check_longest_records(pmap);
			if (s_is_co_mode() && global.browser) {
				s_fix_poki_browser_max_percent_grade(pmap);
			}
			if (ds_map_exists(pmap, "saved_percent_grade")) {
				ds_map_delete(pmap, "saved_percent_grade");
			}
			ds_list_add(roster, pmap);
		}
		size = ini_read_real("savegame", "stafflist", 0);
		slog("stafflist size=" + string(size));
		for (var r = 0; r < size; r++) {
			pmap = ds_map_create();
			ds_map_read(pmap, ini_read_string("savegame", "stafflist_" + string(r), ""));
			ds_map_set(pmap, "flash_time", -9999);
			if (!ds_map_exists(pmap, "randnum")) {
				ds_map_set(pmap, "randnum", irandom(999));
			}
			if (!ds_map_exists(pmap, "xp_level")) {
				ds_map_set(pmap, "xp_level", ds_map_find_value(pmap, "rating"));
				ds_map_set(pmap, "xp", 0);
				ds_map_set(pmap, "xp_gain", 0);
			}
			ds_list_add(stafflist, pmap);
		}
		size = ini_read_real("savegame", "hoflist", 0);
		slog("hoflist size=" + string(size));
		for (var r = 0; r < size; r++) {
			pmap = ds_map_create();
			ds_map_read(pmap, ini_read_string("savegame", "hoflist_" + string(r), ""));
			if (s_is_player_pmap_corrupt(pmap)) {
				ds_map_destroy(pmap);
				pmap = -1;
				continue;
			}
			ds_list_add(hoflist, pmap);
		}
		size = ini_read_real("savegame", "rbhistorylist", 0);
		slog("rbhistorylist size=" + string(size));
		for (var r = 0; r < size; r++) {
			map = ds_map_create();
			str = ini_read_string("savegame", "rbhistorylist_" + string(r), "");
			slog(str);
			ds_map_read(map, str);
			ds_list_add(rbhistorylist, map);
		}
		ds_grid_read(face_grid_L, ini_read_string("savegame", "face_grid_L", "0"));
		ds_grid_read(face_grid_M, ini_read_string("savegame", "face_grid_M", "0"));
		ds_grid_read(face_grid_D, ini_read_string("savegame", "face_grid_D", "0"));
		ds_grid_read(face_grid_C, ini_read_string("savegame", "face_grid_C", "0"));
		size = ini_read_real("savegame", "shoppinglist", 0);
		slog("shoppinglist size=" + string(size));
		for (var m = 0; m < size; m++) {
			map = ds_map_create();
			ds_map_read(map, ini_read_string("savegame", "shoppinglist_" + string(m), ""));
			ds_list_add(shoppinglist, map);
		}
		s_update_maplist_from_file(shoppinglist, "Shopping.txt");
		size = ini_read_real("savegame", "list_teams_rejected", 0);
		for (var m = 0; m < size; m++) {
			ds_list_add(list_teams_rejected, ini_read_real("savegame", "list_teams_rejected_" + string(m), -1));
		}
		if (s_is_co_mode()) {
			recruitment_credits = ini_read_real("savegame", "recruitment_credits", 0);
			recruitment_credits_cap = ini_read_real("savegame", "recruitment_credits_cap", 50);
			rc_season_earned = ini_read_real("savegame", "rc_season_earned", 0);
			rc_lifetime_earned = ini_read_real("savegame", "rc_lifetime_earned", 0);
			rc_season_spent = ini_read_real("savegame", "rc_season_spent", 0);
			rc_lifetime_spent = ini_read_real("savegame", "rc_lifetime_spent", 0);
			boost_recruitment_credits_cap = abs(ini_read_real("savegame", "boost_recruitment_credits_cap", 0));
			college_admissions_draft_round = ini_read_real("savegame", "college_admissions_draft_round", 0);
			college_admissions_warn_once = ini_read_real("savegame", "college_admissions_warn_once", 1);
			college_awards_done = ini_read_real("savegame", "college_awards_done", 0);
			pro_drafted_players = ini_read_real("savegame", "pro_drafted_players", 0);
			rec_conf_champ_wins = ini_read_real("savegame", "rec_conf_champ_wins", 0);
			rec_bowl_wins = ini_read_real("savegame", "rec_bowl_wins", 0);
			rec_champ_wins = ini_read_real("savegame", "rec_champ_wins", 0);
			rec_highest_rank_major = ini_read_real("savegame", "rec_highest_rank_major", 999999);
			rec_highest_rank_minor = ini_read_real("savegame", "rec_highest_rank_minor", 999999);
			non_champ_conferences_resolved = ini_read_real("savegame", "non_champ_conferences_resolved", 0);
		}
		cap_breach_flag = ini_read_real("savegame", "cap_breach_flag", -2);
		s_cap_breach_refresh();
		ini_close();
		stage = 1;
	}
	s_update_human_playoff_fixtures();
	s_check_staff_exist();
	s_update_ui_colours();
	s_refresh_strings();
	if (s_is_co_mode()) {
		s_reset_competitions_and_subdivisions_pools_and_rankings();
		s_load_co_mode_files();
		s_co_conference_stats();
		s_competitions_status_update();
	}
}

function s_cap_breach_refresh() {
	slog("s_cap_breach_refresh[" + string(obj_master.cap_breach_flag) + "]");
	if (obj_master.cap_breach_flag == -2) {
		obj_master.cap_breach_flag = 0;
	}
	if (s_get_salary_total() > salary_cap + boost_salary_cap) {
		obj_master.cap_breach_flag = 1;
	}
	for (var i = 0; i < ds_list_size(roster); i++) {
		var pmap = ds_list_find_value(roster, i);
		var pos = ds_map_find_value(pmap, "position");
		var count = s_count_players_by_position(pos);
		var maxpos = 1;
		switch (pos) {
			case 1:
				maxpos = 2;
				break;
			case 2:
				maxpos = 2;
				break;
			case 3:
				maxpos = 3;
				break;
			case 4:
				maxpos = 3;
				break;
			case 5:
				maxpos = 5;
				break;
			case 6:
				maxpos = 4;
				break;
			case 7:
				maxpos = 3;
				break;
			case 9:
			case 8:
				maxpos = 4;
				break;
			case 10:
				maxpos = 2;
				break;
		}
		if (count > maxpos) {
			obj_master.cap_breach_flag = 1;
		}
	}
	for (var i = 0; i < ds_list_size(roster); i++) {
		var pmap = ds_list_find_value(roster, i);
		if (ds_map_find_value(pmap, "age") > s_get_max_age(pmap)) {
			slog("BREACH in roster: name[" + string(ds_map_find_value(pmap, "lname")) + "] age[" + string(ds_map_find_value(pmap, "age")) + "] maxage[" + string(s_get_max_age(pmap)) + "]");
			obj_master.cap_breach_flag = 1;
		}
	}
	for (var i = 0; i < ds_list_size(hoflist); i++) {
		var pmap = ds_list_find_value(hoflist, i);
		if (ds_map_find_value(pmap, "age") > s_get_max_age(pmap) + 1) {
			slog("BREACH in hoflist: name[" + string(ds_map_find_value(pmap, "lname")) + "] age[" + string(ds_map_find_value(pmap, "age")) + "] maxage[" + string(s_get_max_age(pmap) + 1) + "]");
			obj_master.cap_breach_flag = 1;
		}
	}
	slog("s_cap_breach_refresh... set to: [" + string(obj_master.cap_breach_flag) + "]");
}

function s_cap_breach_str() {
	switch (obj_master.cap_breach_flag) {
		case -1:
			return " CB:NV";
		case 0:
			return " CB:NO";
		case 1:
			return " CB:YES";
	}
	return "?[" + string(obj_master.cap_breach_flag) + "]";
}

function s_is_player_pmap_corrupt(_arg0) {
	if (!ds_map_exists(_arg0, "position")) {
		return true;
	}
	if (!ds_map_exists(_arg0, "lname")) {
		return true;
	}
	if (!ds_map_exists(_arg0, "condition")) {
		return true;
	}
	if (!is_real(ds_map_find_value(_arg0, "position"))) {
		ds_map_set(_arg0, "position", real(ds_map_find_value(_arg0, "position")));
	}
	if (!is_string(ds_map_find_value(_arg0, "lname"))) {
		ds_map_set(_arg0, "lname", string(ds_map_find_value(_arg0, "lname")));
	}
	if (!is_real(ds_map_find_value(_arg0, "condition"))) {
		ds_map_set(_arg0, "condition", real(ds_map_find_value(_arg0, "condition")));
	}
	if (ds_map_exists(_arg0, "strength") && ds_map_find_value(_arg0, "strength") > 10) {
		ds_map_set(_arg0, "strength", 10);
	}
	if (ds_map_exists(_arg0, "stamina") && ds_map_find_value(_arg0, "stamina") > 10) {
		ds_map_set(_arg0, "stamina", 10);
	}
	if (ds_map_exists(_arg0, "speed") && ds_map_find_value(_arg0, "speed") > 10) {
		ds_map_set(_arg0, "speed", 10);
	}
	if (ds_map_exists(_arg0, "skill") && ds_map_find_value(_arg0, "skill") > 10) {
		ds_map_set(_arg0, "skill", 10);
	}
	ds_map_set(_arg0, "flash_time", -9999);
	if (!ds_map_exists(_arg0, "randnum")) {
		ds_map_set(_arg0, "randnum", irandom(999));
	}
	s_check_for_return_stats(_arg0);
	return false;
}

function s_check_for_return_stats(_arg0) {
	if (!ds_map_exists(_arg0, "stat_return_attempts")) {
		ds_map_set(_arg0, "stat_return_attempts", 0);
	}
	if (!ds_map_exists(_arg0, "stat_return_yards")) {
		ds_map_set(_arg0, "stat_return_yards", 0);
	}
	if (!ds_map_exists(_arg0, "stat_return_tds")) {
		ds_map_set(_arg0, "stat_return_tds", 0);
	}
	if (!ds_map_exists(_arg0, "stat_return_longest")) {
		ds_map_set(_arg0, "stat_return_longest", 0);
	}
	if (!ds_map_exists(_arg0, "season_return_attempts")) {
		ds_map_set(_arg0, "season_return_attempts", 0);
	}
	if (!ds_map_exists(_arg0, "season_return_yards")) {
		ds_map_set(_arg0, "season_return_yards", 0);
	}
	if (!ds_map_exists(_arg0, "season_return_tds")) {
		ds_map_set(_arg0, "season_return_tds", 0);
	}
	if (!ds_map_exists(_arg0, "season_return_longest")) {
		ds_map_set(_arg0, "season_return_longest", 0);
	}
	if (!ds_map_exists(_arg0, "career_return_attempts")) {
		ds_map_set(_arg0, "career_return_attempts", 0);
	}
	if (!ds_map_exists(_arg0, "career_return_yards")) {
		ds_map_set(_arg0, "career_return_yards", 0);
	}
	if (!ds_map_exists(_arg0, "career_return_tds")) {
		ds_map_set(_arg0, "career_return_tds", 0);
	}
	if (!ds_map_exists(_arg0, "career_return_longest")) {
		ds_map_set(_arg0, "career_return_longest", 0);
	}
	if (ds_map_find_value(_arg0, "position") == 10) {
		if (!ds_map_exists(_arg0, "stat_attempts_XP")) {
			ds_map_set(_arg0, "stat_attempts_XP", 0);
		}
		if (!ds_map_exists(_arg0, "season_attempts_XP")) {
			ds_map_set(_arg0, "season_attempts_XP", 0);
		}
		if (!ds_map_exists(_arg0, "career_attempts_XP")) {
			ds_map_set(_arg0, "career_attempts_XP", 0);
		}
		if (!ds_map_exists(_arg0, "stat_complete_XP")) {
			ds_map_set(_arg0, "stat_complete_XP", 0);
		}
		if (!ds_map_exists(_arg0, "season_complete_XP")) {
			ds_map_set(_arg0, "season_complete_XP", 0);
		}
		if (!ds_map_exists(_arg0, "career_complete_XP")) {
			ds_map_set(_arg0, "career_complete_XP", 0);
		}
	}
}

function s_check_longest_records(_arg0) {
	var lmax = 100;
	if (ds_map_find_value(_arg0, "position") == 10) {
		lmax = 65;
	}
	if (ds_map_exists(_arg0, "stat_longest") && real(ds_map_find_value(_arg0, "stat_longest")) > lmax) {
		ds_map_set(_arg0, "stat_longest", 0);
	}
	if (ds_map_exists(_arg0, "stat_rush_longest") && real(ds_map_find_value(_arg0, "stat_rush_longest")) > lmax) {
		ds_map_set(_arg0, "stat_rush_longest", 0);
	}
	if (ds_map_exists(_arg0, "season_longest") && real(ds_map_find_value(_arg0, "season_longest")) > lmax) {
		ds_map_set(_arg0, "season_longest", 0);
	}
	if (ds_map_exists(_arg0, "season_rush_longest") && real(ds_map_find_value(_arg0, "season_rush_longest")) > lmax) {
		ds_map_set(_arg0, "season_rush_longest", 0);
	}
	if (ds_map_exists(_arg0, "career_longest") && real(ds_map_find_value(_arg0, "career_longest")) > lmax) {
		ds_map_set(_arg0, "career_longest", 0);
	}
	if (ds_map_exists(_arg0, "career_rush_longest") && real(ds_map_find_value(_arg0, "career_rush_longest")) > lmax) {
		ds_map_set(_arg0, "career_rush_longest", 0);
	}
}

function s_fix_poki_browser_max_percent_grade(_arg0) {
	var maxPR = ds_map_find_value(_arg0, "max_percent_grade");
	if (is_undefined(maxPR)) {
		slog("s_fix_poki_browser_max_percent_grade: max_percent_grade is [" + string(maxPR) + "]");
		ds_map_set(_arg0, "max_percent_grade", 83);
	}
}

function s_update_ui_colours() {
	if (obj_master.fr_mode) {
		global.c_background = make_color_rgb(44, 104, 255);
		global.c_primary = make_color_rgb(210, 210, 10);
	}
	if (obj_master.qb_mode) {
		global.c_background = make_color_rgb(128, 150, 208);
		global.c_buttons = make_color_rgb(170, 200, 255);
	}
	if (s_is_co_mode()) {
		global.c_background = make_color_rgb(5, 50, 110);
		global.c_primary = s_get_college_primary_col();
	}
	if (!obj_master.fr_mode && !obj_master.qb_mode && !s_is_co_mode()) {
		obj_master.fr_mode = 1;
	}
	slog("fr_mode=" + string(obj_master.fr_mode));
	slog("qb_mode=" + string(obj_master.qb_mode));
	slog("co_mode=" + string(obj_master.co_mode));
	s_update_game_title();
}

function s_get_college_primary_col() {
	return make_color_rgb(181, 158, 101);
}

function s_update_game_title() {
	var hash = variable_get_hash("game_Title");
	if (obj_master.fr_mode) {
		struct_set_from_hash(global.g_m.langdata, hash, "Retro Bowl");
	} else if (obj_master.qb_mode) {
		struct_set_from_hash(global.g_m.langdata, hash, "Retro Bowl MVP");
	} else if (s_is_co_mode()) {
		struct_set_from_hash(global.g_m.langdata, hash, "Retro Bowl College");
	}
}

