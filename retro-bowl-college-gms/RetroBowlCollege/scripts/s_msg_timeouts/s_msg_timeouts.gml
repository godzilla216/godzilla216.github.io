function s_msg_timeouts() {
	s_msg_clear();
	obj_master.timeout_message_done = true;
	s_create_message("", s_str("msg_TimeOuts"), s_str("ui_Continue"), "", s_msg_clear, "", 16777215, 0.7);
}

