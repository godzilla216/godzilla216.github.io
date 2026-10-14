function s_check_intro() {
	if (s_is_co_mode()) {
		return s_check_intro_college();
	}
	with (obj_master) {
		slog("s_check_intro: " + string(intro));
		switch (intro) {
			case 1:
				s_check_intro_case1();
				break;
			case 2:
				s_check_intro_case2();
				break;
			case 3:
				s_check_intro_case3();
				break;
			case 4:
				s_check_intro_case4();
				break;
			case 5:
				s_check_intro_case5();
				break;
			case 6:
				s_check_intro_case6();
				break;
			case 7:
				s_check_intro_case7();
				break;
			case 8:
				s_check_intro_case8();
				break;
		}
	}
}

function s_check_intro_college() {
	with (obj_master) {
		slog("s_check_intro_college: " + string(intro));
		switch (intro) {
			case 1:
				s_check_intro_case1();
				break;
			case 2:
				s_check_intro_case2_b();
				break;
			case 3:
				s_check_intro_case2_c();
				break;
			case 4:
				s_check_intro_case2_d();
				break;
			case 5:
				s_check_intro_case2_e();
				break;
			case 6:
				s_check_intro_case2_f();
				break;
			case 7:
				s_check_intro_case2_g();
				break;
			case 8:
				s_check_intro_case3();
				break;
			case 9:
				s_check_intro_case4();
				break;
			case 10:
				s_check_intro_case5_b();
				break;
			case 11:
				s_check_intro_case6();
				break;
			case 12:
				s_check_intro_case7();
				break;
			case 13:
				s_check_intro_case8();
				break;
		}
	}
}

function s_check_intro_rm_home() {
	if (s_is_co_mode()) {
		s_check_intro_rm_home_college();
		return;
	}
	switch (obj_master.intro) {
		case 1:
		case 2:
			inst_100236.flash = true;
			inst_100242.active = false;
			inst_100238.active = false;
			inst_100243.active = false;
			break;
		case 3:
		case 4:
		case 5:
			inst_100242.flash = true;
			inst_100238.active = false;
			inst_100243.active = false;
			break;
		case 6:
		case 7:
			inst_100238.flash = true;
			break;
		default:
			break;
	}
}

function s_check_intro_rm_home_college() {
	switch (obj_master.intro) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			inst_100236.flash = true;
			inst_100242.active = false;
			inst_100238.active = false;
			inst_100243.active = false;
			break;
		case 8:
		case 9:
		case 10:
			inst_100242.flash = true;
			inst_100238.active = false;
			inst_100243.active = false;
			break;
		case 11:
		case 12:
		case 13:
			inst_100238.flash = true;
			break;
		default:
			break;
	}
}

function s_check_intro_rm_roster() {
	if (s_is_co_mode()) {
		s_check_intro_rm_roster_college();
		return;
	}
	switch (obj_master.intro) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
			roster_profile[0].flash = true;
			inst_100499.active = false;
			inst_100491.active = false;
			break;
		case 6:
			inst_100499.active = false;
			inst_100491.flash = true;
		case 7:
			break;
		default:
			return;
			break;
	}
}

function s_check_intro_rm_roster_college() {
	switch (obj_master.intro) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
			roster_profile[0].flash = true;
			inst_100499.active = false;
			inst_100491.active = false;
			break;
		case 11:
			inst_100499.active = false;
			inst_100491.flash = true;
		case 12:
		case 13:
			break;
		default:
			return;
			break;
	}
}

function s_check_intro_rm_frontoffice() {
	if (s_is_co_mode()) {
		s_check_intro_rm_frontoffice_college();
		return;
	}
}

function s_check_intro_rm_frontoffice_college() {
	if (obj_master.intro > 0) {
		inst_100164.active = false;
		inst_100165.active = false;
		inst_100166.active = false;
	}
	switch (obj_master.intro) {
		case 3:
			inst_100174.flash = true;
			inst_100160.active = false;
			break;
		case 5:
			inst_100187.flash = true;
			inst_100160.active = false;
			break;
		case 8:
			inst_100187.flash = false;
			inst_100160.active = true;
			inst_100160.flash = true;
			break;
	}
}

function s_check_intro_rm_profile_staff() {
	if (s_is_co_mode()) {
		s_check_intro_rm_profile_staff_college();
		return;
	}
}

function s_check_intro_rm_profile_staff_college() {
	switch (obj_master.intro) {
		case 4:
			inst_100464.flash = true;
			break;
	}
	if (obj_master.intro > 0) {
		inst_100460.active = false;
	}
}

function s_check_intro_rm_profile_boss() {
	if (s_is_co_mode()) {
		s_check_intro_rm_profile_boss_college();
		return;
	}
}

function s_check_intro_rm_profile_boss_college() {
	switch (obj_master.intro) {
		case 6:
			inst_100783.flash = true;
			inst_100779.active = false;
			break;
		case 8:
			inst_100779.active = true;
			inst_100779.flash = true;
			break;
	}
}

function s_check_intro_case1() {
	if (current_room == rm_home) {
		var msg = s_parse_intro("msg_Intro_1");
		s_create_message("", msg, s_str("ui_SkipTutorial"), s_str("ui_Ok"), btn_response_skip_tutorial, s_msg_clear, global.c_background, 0.85);
		intro++;
	}
}

function s_check_intro_case2() {
	if (current_room == rm_frontoffice) {
		var msg = s_parse_intro("msg_Intro_2");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
		inst_100160.flash = true;
	}
}

function s_check_intro_case3() {
	if (current_room == rm_frontoffice) {
		inst_100160.flash = true;
	}
	if (current_room == rm_home) {
		var msg = s_parse_intro("msg_Intro_3");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
	}
}

function s_check_intro_case4() {
	if (current_room == rm_roster) {
		var msg = s_parse_intro("msg_Intro_4");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
	}
}

function s_check_intro_case5() {
	if (current_room == rm_profile_player) {
		var msg = s_parse_intro("msg_Intro_5");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
		inst_100430.flash = true;
	}
}

function s_check_intro_case6() {
	if (current_room == rm_home) {
		var msg = s_parse_intro("msg_Intro_6");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
	}
}

function s_check_intro_case7() {
	if (current_room == rm_pre_match) {
		btn_click_Passing();
		intro++;
	}
}

function s_check_intro_case8() {
	if (current_room == rm_home) {
		var msg = s_parse_intro("msg_Intro_8");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro = 0;
		stage = 1;
	}
}

function s_check_intro_case2_b() {
	if (current_room == rm_frontoffice) {
		var msg = s_parse_intro("msg_Intro_2_b");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
		inst_100174.flash = true;
		inst_100160.active = false;
	}
}

function s_check_intro_case2_c() {
	if (current_room == rm_profile_staff) {
		var msg = s_parse_intro("msg_Intro_2_c");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
		inst_100464.flash = true;
	}
}

function s_check_intro_case2_d() {
	if (current_room == rm_frontoffice) {
		var msg = s_parse_intro("msg_Intro_2_d");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
		inst_100187.flash = true;
		inst_100160.active = false;
	}
}

function s_check_intro_case2_e() {
	if (current_room == rm_profile_boss) {
		var msg = s_parse_intro("msg_Intro_2_e");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
		intro++;
		inst_100783.flash = true;
		inst_100779.active = false;
	}
}

function s_check_intro_case2_f() {
}

function s_check_intro_case2_g() {
	if (current_room == rm_frontoffice) {
		inst_100187.flash = false;
		inst_100160.active = false;
		inst_100160.flash = true;
	}
}

function s_info_gpa_explanation_open() {
	if (obj_master.intro == 6) {
		slog("s_check_intro_college: " + string(obj_master.intro));
		s_create_message("", s_str(info_msg), s_str("ui_Continue"), "", btn_info_gpa_explanation_intro_close, "", global.c_background, 1);
		obj_master.intro++;
	} else {
		s_create_message("", s_str(info_msg), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	}
}

function btn_info_gpa_explanation_intro_close() {
	s_msg_clear();
	if (current_room == rm_profile_boss) {
		inst_100783.flash = false;
		inst_100779.active = true;
		inst_100779.flash = true;
		obj_master.intro++;
	}
}

function s_check_intro_case5_b() {
	if (current_room == rm_profile_player) {
		var msg = s_parse_intro("msg_Intro_5");
		s_create_message("", msg, "", s_str("ui_Ok"), "", s_check_intro_case5_second_msg, global.c_background, 0.85);
		intro++;
		inst_100430.flash = true;
	}
}

function s_check_intro_case5_second_msg() {
	s_msg_clear();
	var msg = s_parse_intro("msg_Intro_5_b");
	s_create_message("", msg, "", s_str("ui_Ok"), "", s_msg_clear, global.c_background, 0.85);
}

