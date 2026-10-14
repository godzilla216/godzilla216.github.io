function s_get_destination() {
	var ball = global.master_ball;
	switch (ball.state) {
		case 0:
			jforce = 0;
			break;
		case 18:
			if (offense) {
				s_aim_AI_offense();
			} else if (position == 7) {
				s_received_AI_new();
			} else {
				s_aim_AI_defense();
			}
			break;
		case 19:
		case 2:
			if (s_is_kickoff(false)) {
				return;
			}
		case 3:
			if (offense) {
				s_aim_AI_offense();
			} else {
				s_aim_AI_defense();
			}
			break;
		case 5:
		case 9:
			if (offense && global.gamepad && global.master_ball.holder == id && global.gp.axisl_force > 0.2) {
				jdir = point_direction(0, 0, global.gp.axisl_h, global.gp.axisl_v);
				jforce = global.gp.axisl_force;
			} else {
				s_received_AI_new();
			}
			break;
		case 13:
			jdir = point_direction(x, y, ball.x, ball.y);
			jforce = clamp(balldist / 40, 0.25, 0.75);
			break;
		default:
			break;
	}
}

