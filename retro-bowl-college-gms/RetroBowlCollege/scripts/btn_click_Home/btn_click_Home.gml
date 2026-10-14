function btn_click_Home() {
	slog("btn_click_Home");
	s_stop_brass_loop();
	obj_master.stage = 1;
	room_goto(rm_home);
	s_rm_winners_notice();
}

function btn_click_Play1() {
	slog("btn_click_Play1");
	s_stop_brass_loop();
	s_play(1);
}

function btn_click_Options_Exit() {
	_poki_gameplay_start();
	s_save_options();
	btn_click_Home();
}

function btn_click_Home_rm_winners() {
	if (s_is_co_mode() && variable_instance_exists(obj_master, "rm_winners_do_awards") && obj_master.rm_winners_do_awards == 0) {
		slog("btn_click_Home_rm_winners - s_play");
		s_play(1);
		s_rm_winners_notice();
		return;
	}
	slog("btn_click_Home_rm_winners - rm_home");
	btn_click_Home();
}

function s_rm_winners_notice() {
	if (!s_is_co_mode()) {
		return;
	}
	var conf = s_get_conference_data(obj_master.myconference);
	if (conf != -4 && conf.name == "Academic") {
		s_add_news(s_str("msg_AcademicSeasonEnd"));
	}
}

