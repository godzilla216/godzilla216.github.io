function s_set_ball_down() {
	slog("s_set_ball_down");
	with (global.master_ball) {
		state = 4;
		obj_controller.y_down = y;
		if (holder) {
			obj_controller.y_down = holder.y;
		}
		if (obj_master.gamepractice == 2) {
			if (obj_controller.practice_success == 0) {
				state = 17;
			} else {
				state = 16;
			}
		} else if (holder) {
			if (holder.min_x == -1) {
				holder.min_x = global.master_ball.x;
			}
			if (holder.max_x == -1) {
				holder.max_x = global.master_ball.x;
			}
			var bx = global.master_ball.x;
			var is_qb = holder && holder.position == 1;
			if (is_qb && (bx > obj_controller.x_scrim && obj_controller.drivedir == -1 || bx < obj_controller.x_scrim && obj_controller.drivedir == 1)) {
				xdead = bx;
				state = 11;
				if (holder.pmap && obj_controller.down < 5) {
					ds_map_set_post(holder.pmap, "stat_sacks", ds_map_find_value(holder.pmap, "stat_sacks") + 1);
				}
				with (obj_playerOF) {
					if (position == 5 && pmap) {
						ds_map_set_post(pmap, "stat_sacks", ds_map_find_value(pmap, "stat_sacks") + 1);
					}
				}
				slog("SACKED! ball.xdead = " + string(global.master_ball.x));
				s_sound_audience_dis();
			}
			switch (obj_controller.drivedir) {
				case -1:
					if (x > 2300) {
						if (s_is_kickoff(true) && !holder.last_tackled) {
							if (holder.min_x >= 2300) {
								slog("BALL_TOUCHBACK 4");
								state = 20;
							}
							ydead = round(y);
							xdead = round(x);
						} else {
							state = 12;
						}
						s_sound_audience_dis();
						return;
					}
					break;
				case 1:
					if (x < 300) {
						if (s_is_kickoff(true) && !holder.last_tackled) {
							if (holder.max_x <= 300) {
								slog("BALL_TOUCHBACK 5");
								state = 20;
							}
							ydead = round(y);
							xdead = round(x);
						} else {
							state = 12;
						}
						s_sound_audience_dis();
						return;
					}
					break;
			}
			s_update_yard_gain();
		}
	}
}

