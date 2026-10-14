function s_start_replay(_arg0) {
	slog("s_start_replay");
	obj_controller.state = 3;
	global.replay_frame = 0;
	global.replay_end = _arg0;
	with (obj_btn_timeout) {
		instance_destroy();
	}
	with (obj_matchob) {
		s_replay_frame();
	}
	if (obj_master.gamepractice || global.browser) {
		s_end_replay();
		return;
	}
	switch (ds_map_find_value(obj_master.map_options, "op_replays")) {
		case 0:
			s_end_replay();
			break;
		case 1:
			if (!global.replay_do) {
				s_end_replay();
			}
			break;
		case 2:
			break;
	}
}

