function btn_response_cointoss_receive() {
	obj_controller.possession = !obj_controller.human_team;
	obj_controller.comm_stage = 0;
	s_msg_clear();
}

