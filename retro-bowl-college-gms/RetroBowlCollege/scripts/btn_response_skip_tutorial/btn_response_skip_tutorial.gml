function btn_response_skip_tutorial() {
	slog("btn_skip_tutorial");
	s_msg_clear();
	obj_master.intro = 0;
	room_goto(rm_home);
}

