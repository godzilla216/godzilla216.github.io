function s_set_up_globals() {
	slog("s_set_up_globals 1");
	global.url_apple = "https://apps.apple.com/us/app/retro-bowl/id1478902583";
	global.url_google = "https://play.google.com/store/apps/details?id=com.newstargames.retrobowl";
	global.url_twitter = "https://twitter.com/retro_bowl";
	global.url_discord = "https://t.co/39hMkwwqet";
	global.url_reddit = "https://www.reddit.com/r/RetroBowl";
	global.url_record_book = "https://www.reddit.com/r/RetroBowl/comments/qiinp5/retro_bowl_record_book_volume_v";
	global.url_leagues = "https://retrobitcoach.com/?page_id=16";
	global.url_apple_retrogoal = "https://apple.co/3CtmZdv";
	global.url_google_retrogoal = "https://bit.ly/3Ey2KgC";
	global.url_switch_us = "https://bit.ly/3B1aqqb";
	global.url_apple_nss = "https://apple.co/3pHBbMP";
	global.url_google_nss = "https://bit.ly/3bfcQW9";
	global.url_apple_nsm = "https://apple.co/3bgpRyI";
	global.url_google_nsm = "https://bit.ly/3vQAAcL";
	global.url_apple_nsb = "https://apple.co/3nyyUSs";
	global.url_google_nsb = "https://bit.ly/3qXwsHD";
	global.url_apple_retrobowl = "https://apps.apple.com/app/retro-bowl/id1478902583";
	global.url_google_retrobowl = "https://play.google.com/store/apps/details?id=com.newstargames.retrobowl";
	global.url_apple_gp = "https://store.steampowered.com/app/2217580/New_Star_GP/";
	global.url_google_gp = "https://store.steampowered.com/app/2217580/New_Star_GP/";
	global.url_merch_tshirts = "https://pixelpigskin.threadless.com";
	global.url_heatley_bros = "https://www.youtube.com/watch?v=orQOPJMy9Ww";
	global.url_jefe_zhai = "https://www.youtube.com/playlist?list=PLvoVcbkHypzIj1_9aIh6w_B2sIPnS3t6A";
	global.IAP_Enabled = false;
	global.mobile_device = os_type == 4 || os_type == 3;
	global.console_build = os_type == 21;
	global.master_ball = -4;
	global.browser = true;
	if (os_browser == -1) {
		global.browser = false;
	} else {
		global.mobile_device = false;
	}
	global.poki = true;
	if (!global.browser) {
		global.poki = false;
	}
	global.poki_gameplay = false;
	global.poki_done_post_match_reward = false;
	global.debug = false;
	if (!global.browser && (os_type == 0 || os_type == 1)) {
		global.debug = true;
	}
	global.jefebuild = false;
	if (os_type != 3) {
		global.jefebuild = false;
	}
	if (!variable_global_exists("show_title")) {
		global.show_title = true;
	}
	global.debug_co_overtime = 0;
	global.debug_force_skip_result = 0;
	global.debug_aa_hide_ui = false;
	global.last_opt_music_change_time = 0;
	slog("s_set_up_globals 2");
	global.g_version = 43;
	global.g_savedelay = 0;
	global.g_optionsave = "optiondata.dat";
	global.g_savename1 = "savedata.ini";
	global.g_savename2 = "savedata2.ini";
	global.g_savename3 = "savedata3.ini";
	global.g_savename4 = "savedata4.ini";
	global.g_savename5 = "savedata5.ini";
	global.g_savename_exh = "savedata_exh.ini";
	global.c_background = make_color_rgb(44, 104, 255);
	global.c_shadow = make_color_rgb(96, 96, 96);
	slog("s_set_up_globals 3");
	global.c_primary = make_color_rgb(210, 210, 10);
	global.c_highlight = make_color_rgb(230, 230, 130);
	global.c_buttons = make_color_rgb(210, 210, 10);
	global.c_backfill = make_color_rgb(0, 0, 0);
	global.c_routes = make_color_rgb(86, 216, 86);
	global.c_routes_rb = make_color_rgb(116, 164, 255);
	global.c_headcoach = make_color_rgb(57, 180, 74);
	global.c_offense = make_color_rgb(92, 200, 255);
	global.c_defense = make_color_rgb(255, 64, 64);
	global.c_specialteams = make_color_rgb(228, 92, 16);
	global.c_toxic = make_color_rgb(60, 200, 120);
	global.ui_skin = 0;
	slog("s_set_up_globals 3.1");
	if (global.poki) {
		switch (poki_get_team()) {
			case "0":
				global.ui_skin = 0;
				break;
			case 0:
				global.ui_skin = 0;
				break;
			case "1":
				global.ui_skin = 1;
				break;
			case 1:
				global.ui_skin = 1;
				break;
			case "2":
				global.ui_skin = 2;
				break;
			case 2:
				global.ui_skin = 2;
				break;
		}
	}
	slog("s_set_up_globals 3.2");
	name_conf1 = "AFC";
	name_conf2 = "NFC";
	name_div1 = "EAST";
	name_div2 = "WEST";
	name_div3 = "NORTH";
	name_div4 = "SOUTH";
	name_div1b = "EAST";
	name_div2b = "WEST";
	name_div3b = "NORTH";
	name_div4b = "SOUTH";
	global.gamepad = false;
	global.gp = s_reset_gamepad(1);
	global.gp_select = 32769;
	global.gp_back = 32770;
	slog("s_set_up_globals 4");
	if (os_type == 21) {
		global.gp_select = 32770;
		global.gp_back = 32769;
	}
	global.gp_handoff = global.gp_back;
	global.gp_timeout = 32771;
	global.colorHelmet = shader_get_uniform(sh_ColorReplaceBlend, "colorHelmet");
	global.colorLogo = shader_get_uniform(sh_ColorReplaceBlend, "colorLogo");
	global.colorShirt = shader_get_uniform(sh_ColorReplaceBlend, "colorShirt");
	global.colorSleeve = shader_get_uniform(sh_ColorReplaceBlend, "colorSleeve");
	global.colorPants = shader_get_uniform(sh_ColorReplaceBlend, "colorPants");
	global.colorPants_b = shader_get_uniform(sh_ColorReplaceBlend, "colorPants_b");
	global.colorStripe = shader_get_uniform(sh_ColorReplaceBlend, "colorStripe");
	global.colorSocks = shader_get_uniform(sh_ColorReplaceBlend, "colorSocks");
	global.colorSocks_b = shader_get_uniform(sh_ColorReplaceBlend, "colorSocks_b");
	global.colorSkin = shader_get_uniform(sh_ColorReplaceBlend, "colorSkin");
	global.colorCleats = shader_get_uniform(sh_ColorReplaceBlend, "colorCleats");
	global.replaceHelmet = shader_get_uniform(sh_ColorReplaceBlend, "replaceHelmet");
	global.replaceLogo = shader_get_uniform(sh_ColorReplaceBlend, "replaceLogo");
	global.replaceShirt = shader_get_uniform(sh_ColorReplaceBlend, "replaceShirt");
	global.replaceSleeve = shader_get_uniform(sh_ColorReplaceBlend, "replaceSleeve");
	global.replacePants = shader_get_uniform(sh_ColorReplaceBlend, "replacePants");
	global.replacePants_b = shader_get_uniform(sh_ColorReplaceBlend, "replacePants_b");
	global.replaceStripe = shader_get_uniform(sh_ColorReplaceBlend, "replaceStripe");
	global.replaceSocks = shader_get_uniform(sh_ColorReplaceBlend, "replaceSocks");
	global.replaceSocks_b = shader_get_uniform(sh_ColorReplaceBlend, "replaceSocks_b");
	global.replaceSkin = shader_get_uniform(sh_ColorReplaceBlend, "replaceSkin");
	global.replaceCleats = shader_get_uniform(sh_ColorReplaceBlend, "replaceCleats");
	slog("s_set_up_globals 5");
	random_set_seed(current_time);
	global.exhibition = false;
	global.exhibition_html_1save = global.browser == true;
	global.exh_fix = s_create_exhibition_fixture(irandom(15), 16 + irandom(15));
	global.exh_choosing = 0;
	global.debug_track_str = "";
	slog("s_set_up_globals 6");
}

function s_set_up_temp_variables() {
	myteam = ds_list_find_value(teamlist, clamp(myteam_id, obj_master.min_team_id, obj_master.max_team_id));
	myconference = ds_map_find_value(myteam, "conference");
	mydivision = ds_map_find_value(myteam, "division");
	list_notifications = ds_list_create();
	newteam = -4;
	jobofferdone = false;
	gamepractice = 0;
	playoff_proceed = false;
	playerteamindex = 0;
	team[0] = -4;
	team[1] = -4;
	tscore[0] = 0;
	tscore[1] = 0;
	qtr_scores0[4] = 0;
	qtr_scores1[4] = 0;
	for (var i = 0; i < 4; i++) {
		col_helmet_home[i] = 0;
		col_logo_home[i] = 0;
		col_shirt_home[i] = 0;
		col_sleeve_home[i] = 0;
		col_pants_home[i] = 0;
		col_pants_home_b[i] = 0;
		col_stripe_home[i] = 0;
		col_socks1_home[i] = 0;
		col_socks2_home[i] = 0;
		col_endzone_home[i] = 0;
		col_helmet_away[i] = 0;
		col_logo_away[i] = 0;
		col_shirt_away[i] = 0;
		col_sleeve_away[i] = 0;
		col_pants_away[i] = 0;
		col_pants_away_b[i] = 0;
		col_stripe_away[i] = 0;
		col_socks1_away[i] = 0;
		col_socks2_away[i] = 0;
		col_endzone_away[i] = 0;
	}
	boss_profile = -4;
	player_profile = -4;
	staff_hire = -4;
	stat_view = 1;
	face_page = 1;
	face_type_coach = false;
	draft_page = 1;
	hof_page = 1;
	fa_page = 1;
	dodraftbanner = false;
	fans_done_update = false;
	boost_morale_done = false;
	boost_condition_done = false;
	boost_gpa_done = false;
	roster_from_store = false;
	force_uniform_sel1 = 0;
	force_uniform_sel2 = 0;
	edit_box1 = -4;
	edit_box2 = -4;
	map_dilemma = ds_map_create();
	news_dilemma = "";
	store_to_dilemma = false;
	ticker_count = 0;
	staff_reset_week = 0;
	freeagent_reset_week = 0;
	fave_team_check = false;
	edit_team = -4;
	edit_conf = 0;
	nag = 0;
	ad_tick = 0;
	viewing_hof_players = false;
	player_record_msg_done = false;
	retrobowlwinner = 0;
	rm_winners_do_awards = 0;
	rm_winners_cid = -1;
	rm_winners_tier = "";
	rm_winners_custom = "";
	interviews = 10;
	done_season_review = false;
	prematch_team_morale_qb = 0;
	shopping_type = 0;
	shopping_page = 1;
	shopping_item = 0;
	qb_new_offer = -1;
	sim_action = false;
	profile_back_to = -1;
	s_college_set_up_globals();
	s_sound_brass_setup();
}

