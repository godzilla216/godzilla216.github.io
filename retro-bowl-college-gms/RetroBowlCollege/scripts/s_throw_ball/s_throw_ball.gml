function s_throw_ball() {
	var cont = obj_controller;
	with (holder) {
		other.x = x;
		other.y = y;
		s_set_anim(12);
		if (!obj_master.gamepractice && cont.down < 5) {
			if (pmap) {
				ds_map_set(pmap, "stat_attempts", ds_map_find_value(pmap, "stat_attempts") + 1);
			}
		}
	}
	if (cont.running_play) {
		slog(string(direc) + " RUNNING PLAY");
	} else {
		slog(string(direc) + " PASSING PLAY");
		with (obj_playerOF) {
			if (position == 2 && obj_controller.difficulty < 0) {
				stiff_arm = clamp(stiff_arm - 1, 0, 1);
				jumps = clamp(jumps - 1, 0, 1);
			}
		}
	}
	xthrow = x;
	ythrow = y;
	obj_controller.play_start = current_time;
	state = 3;
	holder = -4;
}

