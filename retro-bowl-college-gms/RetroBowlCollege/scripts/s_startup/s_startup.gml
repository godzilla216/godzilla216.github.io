function s_startup() {
	// Palette replacement requires exact sprite colors before scaling.
	gpu_set_texfilter(false);
	slog("------ S_STARTUP ------");
	global.g_m = id;
	slog("s_startup: s_set_up_globals");
	s_set_up_globals();
	persistent = true;
	display_set_gui_size(480, 270);
	device_mouse_dbclick_enable(false);
	randomise();
	canvaswidth = room_width;
	canvasheight = room_height;
	do_welcome_msg = false;
	if (!instance_exists(obj_nx)) {
		global.nx = instance_create_layer(0, 0, id.layer, obj_nx);
	}
	slog("s_startup: s_load_options");
	if (file_exists(global.g_optionsave)) {
		s_load_options();
	} else {
		s_create_map_options();
	}
	fr_mode = 0;
	qb_mode = 0;
	co_mode = 0;
	s_refresh_strings();
	slog("ui_Version_Mode: " + s_str("ui_Version_Mode"));
	slog("s_startup: s_startup_welcome_msg");
	s_startup_welcome_msg();
	s_startup_set_master_variables();
	s_startup_handle_saved_game();
	s_set_up_temp_variables();
	slog("s_startup: hello");
	slog("obj_master: myteam_id = " + string(myteam_id));
	slog("obj_master: myteam.uid = " + string(ds_map_find_value(myteam, "uid")));
	s_update_music();
	s_fonts_init();
	if (global.browser) {
		slog("s_startup: global.browser");
		s_startup_college_mode();
		s_startup_browser();
	} else {
		slog("s_startup: not browser");
		global.lsh = ds_list_create();
		s_keyboard_custom_init();
		s_multiplayer_init();
		s_startup_college_mode();
		s_title_goto();
	}
}

function s_startup_welcome_msg() {
	if (!global.browser && real(ds_map_find_value(map_options, "my_version")) < global.g_version) {
		slog("Current version = " + string(global.g_version));
		slog("My version = " + string(ds_map_find_value(obj_master.map_options, "my_version")));
		s_create_message("", s_str("msg_Update"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	}
}

function s_startup_set_master_variables() {
	data_version = s_get_build_data_version(true);
	year_offset = s_get_build_year_offset(true);
	if (!variable_instance_exists(id, "data_upgraded")) {
		data_upgraded = false;
	}
	start_year = 2021 + year_offset;
	year_stagger = irandom(12);
	last_week_regular = 14;
	first_week_playoffs = 19;
	first_week_postseason = 15;
	extra_weeks_endofseason = 2;
	s_college_shorter_season();
	s_set_teams_min_max_ids();
	year = 1;
	week = 1;
	week_done = false;
	stage = 1;
	intro = 1;
	starrating = 50;
	relationship_boss = 50;
	qb_salary = 10;
	qb_tdbonus = 1;
	qb_training_hiscore = 0;
	qb_nrg = 1;
	fname = "";
	lname = "";
	myteam_id = -1;
	myface_x = -1;
	myface_y = -1;
	my_skin = -1;
	favourite_team_id = 0;
	suppress_difficulty = 10;
	salary_cap = 150;
	if (global.console_build) {
		salary_cap = 200;
	}
	boost_salary_cap = 0;
	prematch_dilemma_done = false;
	prematch_dilemma_shown_count = 0;
	prematch_dilemma_chosen_players = ds_list_create();
	tip_count = 1;
	matchcount = 0;
	gamestarts = 0;
	timeout_message_done = false;
	bullet_throw_message_done = false;
	tag_hof_message_done = 0;
	tag_kr_message_done = 0;
	season_credits_purchased = 0;
	op_ball = 0;
	coach_credit = 3;
	if (global.console_build) {
		coach_credit = 15;
	}
	purchased_credit = 0;
	coach_rating = 1;
	fans = 30;
	facility_stadium = 1;
	facility_training = 1;
	facility_rehab = 1;
	facility_upgraded_stadium = 0;
	facility_upgraded_training = 0;
	facility_upgraded_rehab = 0;
	training_reg_df = 2;
	training_reg_of = 2;
	cap_breach_flag = -2;
	slog("s_cap_breach_create[" + string(obj_master.cap_breach_flag) + "]");
	recruitment_credits_cap = 50;
	recruitment_credits = 1;
	rc_season_earned = 1;
	rc_lifetime_earned = 1;
	rc_season_spent = 0;
	rc_lifetime_spent = 0;
	if (global.console_build) {
		recruitment_credits_cap = 60;
	}
	boost_recruitment_credits_cap = 0;
	college_draft_stage = -1;
	college_admissions_draft_round = 0;
	college_admissions_warn_once = 1;
	college_admissions_doing_player_draft_sign = false;
	college_profile_page_num = 1;
	curriculum_tags = ds_list_create();
	player_cv = ds_list_create();
	college_awards_done = false;
	non_champ_conferences_resolved = false;
	pro_drafted_players = false;
	rec_conf_champ_wins = 0;
	rec_bowl_wins = 0;
	rec_champ_wins = 0;
	rec_highest_rank_major = 999999;
	rec_highest_rank_minor = 999999;
	byeweek_gpaup = false;
	repeat (3) {
		switch (irandom(3)) {
			case 0:
				facility_stadium++;
				break;
			case 1:
				facility_training++;
				break;
			case 2:
				facility_rehab++;
				break;
			case 3:
				fans += 10;
				break;
		}
	}
	draft_round = 1;
	draft_picks[0] = 1;
	draft_picks[1] = 1;
	draft_picks[2] = 1;
	draft_info_done = 0;
	draft_entered = false;
	expiredcontract_msg_done = false;
	offers_done = false;
	op_difficulty = 0;
	op_matchlength = 0;
	op_autorun = 1;
	op_autorun_p2 = 1;
}

function s_startup_handle_saved_game() {
	first_load = false;
	var savename = s_get_savename();
	if (file_exists(savename)) {
		slog("obj_master: s_loadgame(" + savename + ")");
		s_loadgame(savename);
		first_load = true;
		if (1 && qb_mode == 1) {
			file_delete(savename);
			s_create_new_save();
		}
	} else {
		slog("obj_master: s_create_new_save");
		s_create_new_save();
	}
	slog("obj_master: myteam_id=" + string(myteam_id));
	if (!ds_exists(teamlist, 2)) {
		slog("obj_master: no teamlist!!!");
		s_create_new_save();
	} else if (ds_list_size(teamlist) < 32) {
		slog("obj_master: teamlist less than 32!!!");
		s_create_new_save();
	}
}

function s_startup_college_mode() {
	slog("INC_CO_MODE:[" + string(1) + "]");
	s_setup_for_mode_CO();
	if (data_upgraded) {
		slogf("*** DATA UPGRADED - START NEW SEASON");
		data_upgraded = false;
		s_start_new_season(false);
		room_goto(rm_home);
	}
}

function s_startup_browser() {
	slog(">>>>");
	slog("obj_master: This is a browser:" + url_get_domain() + " do_welcome_msg: " + string(do_welcome_msg));
	slog(">>>>");
	var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
	uniform.visible = false;
	s_load_uniform_file2(myteam_id, uniform, 0, "");
	if (do_welcome_msg) {
		slog("obj_master: go rm_details");
		room_goto(rm_details);
	} else {
		slog("obj_master: go rm_home");
		room_goto(rm_home);
	}
}

