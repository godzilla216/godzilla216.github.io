function s_received_AI_new() {
	if (obj_master.gamepractice == 3 || obj_master.gamepractice == 2 && position == 5) {
		jforce = 0;
		return;
	}
	if (path_exists(my_route)) {
		path_delete(my_route);
	}
	if (s_is_kickoff(true)) {
		return s_received_AI_kickoff();
	}
	var ball = global.master_ball;
	if (ball.holder != id) {
		if (position == 1) {
			jforce = 0;
			return;
		}
		var beyond_scrim = false;
		switch (ball.holder.facing) {
			case -1:
				if (ball.x < obj_controller.x_scrim) {
					beyond_scrim = true;
				}
				break;
			case 1:
				if (ball.x > obj_controller.x_scrim) {
					beyond_scrim = true;
				}
				break;
		}
		if (!beyond_scrim && balldist > 200) {
			jforce = 0.1;
		} else if (!beyond_scrim && current_time < obj_controller.play_start + 1000) {
			var t = current_time - obj_controller.play_start;
			jforce = t * 0.001;
		} else {
			s_intercept_object(ball.holder);
		}
	} else if (position != 1) {
		if (global.gamepad && !s_get_op_autorun() && offense) {
			jforce = 0;
		} else {
			jforce = 1;
		}
		return;
	}
	switch (position) {
		case 3:
		case 4:
			if (ball.holder == id) {
				break;
			}
		case 5:
			if (!ball.holder.offense) {
				break;
			}
		case 6:
			s_aim_for_nearest_opponent();
			break;
		default:
			break;
	}
	if (ball.holder != id && offense == ball.holder.offense) {
		if (nearest_opp_dist < balldist) {
			s_aim_for_nearest_opponent();
			jforce = clamp(nearest_opp_dist / 20, 0.5, 1);
		} else {
			jforce = 0.7;
		}
	}
}

