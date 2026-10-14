function s_news_clear() {
	s_msg_clear();
	if (obj_master.stage == 1) {
		s_savegame();
	}
	s_check_for_news();
}

