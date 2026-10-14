function btn_click_DeleteSlot5() {
	var msg = s_str("msg_DeleteGame");
	msg = string_replace(msg, "$savedetails", s_get_string_save_details(5, false));
	msg = string_replace(msg, "$num", "5");
	if (global.mobile_device) {
		msg += s_str("msg_DeleteGame2");
	}
	s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Delete"), s_msg_clear, btn_response_deletegame5, global.c_background, 1);
}

