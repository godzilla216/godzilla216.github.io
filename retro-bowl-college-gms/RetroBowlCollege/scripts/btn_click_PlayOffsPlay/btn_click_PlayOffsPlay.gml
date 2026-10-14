function btn_click_PlayOffsPlay() {
	if (!s_do_schedule(false)) {
		return;
	}
	obj_master.playoff_proceed = false;
	obj_master.stage = 7;
	s_play(1);
}

