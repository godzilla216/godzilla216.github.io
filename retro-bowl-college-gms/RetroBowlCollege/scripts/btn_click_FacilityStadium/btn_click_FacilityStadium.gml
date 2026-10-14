function btn_click_FacilityStadium() {
	with (obj_master) {
		if (coach_credit < facility_stadium + 1) {
			s_create_message("", s_str("msg_NoCreditFacility"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		if (facility_upgraded_stadium == week) {
			s_create_message("", s_str("msg_FacilityTooSoon"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		var msg = s_str("msg_facility_Stadium");
		msg = string_replace(msg, "$num", facility_stadium + 1);
		s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_confirm_upgrade_stadium, global.c_background, 1);
	}
}

