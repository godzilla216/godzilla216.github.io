function s_received_AI_kickoff() {
	var ball = global.master_ball;
	jforce = 1;
	if (facing == -1) {
		jdir = 180;
	} else {
		jdir = 0;
	}
	if (ball.holder == id) {
		if (global.gamepad) {
			if (!s_get_op_autorun()) {
				jforce = 0;
			}
		}
		return;
	}
	if (offense == ball.holder.offense) {
		if (nearest_opp_dist < 100) {
			s_aim_for_nearest_opponent();
			jforce = 1;
		} else {
			var f = facing;
			if (ball.holder.goaldist < 1200) {
				f = real(!facing) * 0.35;
			}
			switch (inum) {
				case 1:
					jdir = point_direction(x, y, ball.holder.x + 280 * f, ball.holder.y - 80);
					break;
				case 2:
					jdir = point_direction(x, y, ball.holder.x + 320 * f, ball.holder.y - 50);
					break;
				case 3:
					jdir = point_direction(x, y, ball.holder.x + 320 * f, ball.holder.y);
					break;
				case 4:
					jdir = point_direction(x, y, ball.holder.x + 320 * f, ball.holder.y + 50);
					break;
				case 5:
					jdir = point_direction(x, y, ball.holder.x + 280 * f, ball.holder.y + 80);
					break;
				case 6:
					jdir = point_direction(x, y, ball.holder.x + 220 * f, ball.holder.y - 35);
					break;
				case 7:
					jdir = point_direction(x, y, ball.holder.x + 260 * f, ball.holder.y);
					break;
				case 8:
					jdir = point_direction(x, y, ball.holder.x + 220 * f, ball.holder.y + 35);
					break;
				case 9:
					jdir = point_direction(x, y, ball.holder.x + 140 * f, ball.holder.y - 10);
					break;
				case 10:
					jdir = point_direction(x, y, ball.holder.x + 140 * f, ball.holder.y);
					break;
				case 11:
					jdir = point_direction(x, y, ball.holder.x + 140 * f, ball.holder.y + 10);
					break;
			}
		}
	} else {
		if (balldist > 400) {
			return;
		}
		s_intercept_object(ball.holder);
	}
}

