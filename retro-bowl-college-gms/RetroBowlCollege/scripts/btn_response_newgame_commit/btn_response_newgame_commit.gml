function btn_response_newgame_commit() {
	file_delete(s_get_savename());
	s_msg_clear();
	s_destroy_master();
	room_goto(rm_master);
}

