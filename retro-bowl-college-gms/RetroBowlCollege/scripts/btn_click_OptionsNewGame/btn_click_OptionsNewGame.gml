function btn_click_OptionsNewGame() {
	s_msg_clear();
	if (global.browser) {
		s_save_options();
		s_create_message("", s_str("msg_NewGame"), s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, btn_response_newgame_commit, global.c_background, 1);
	} else {
		s_savegame();
		s_destroy_master();
		room_goto(rm_master);
	}
}

