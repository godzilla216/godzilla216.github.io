function btn_click_ViewHiresReset() {
	with (obj_master) {
		if (coach_credit < 5) {
			var msg = s_str("msg_ResetNoCredit");
			msg = string_replace(msg, "$num", 5);
			s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		if (staff_reset_week == week) {
			s_create_message("", s_str("msg_ResetTooSoon"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		var msg = s_str("msg_StaffReset");
		msg = string_replace(msg, "$num", 5);
		s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_confirm_staff_hire_reset, global.c_background, 1);
	}
}

