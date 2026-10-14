function s_end_replay() {
	slog("s_end_replay");
	s_stop_brass_loop();
	obj_controller.state = 2;
	switch (global.replay_end) {
		case 0:
			s_set_up_play(false);
			s_create_head2head_message();
			break;
		default:
			s_action_result(global.replay_end);
			break;
	}
}

