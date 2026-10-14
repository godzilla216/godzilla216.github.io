function btn_click_Boost_Morale() {
	if (obj_master.boost_morale_done) {
		s_create_message("", s_str("msg_BoostMoraleAlreadyDone"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else if (25 > obj_master.coach_credit) {
		var msg = s_str("msg_BoostMoraleNoCredit");
		msg = string_replace(msg, "$num", string(25));
		s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else {
		var msg = s_str("msg_BoostMorale");
		msg = string_replace(msg, "$num", string(25));
		s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_boost_morale, global.c_background, 1);
	}
}

