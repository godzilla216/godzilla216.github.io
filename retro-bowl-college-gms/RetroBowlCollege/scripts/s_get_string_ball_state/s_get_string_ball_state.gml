function s_get_string_ball_state() {
	with (global.master_ball) {
		switch (state) {
			case 0:
				return "BALL_SET";
			case 2:
				return "BALL_AIM";
			case 1:
				return "BALL_AIM_DEADZONE";
			case 3:
				return "BALL_RELEASED";
			case 4:
				return "BALL_DOWN";
			case 5:
				return "BALL_RECEIVED";
			case 6:
				return "BALL_TOUCHDOWN";
			case 7:
				return "BALL_INCOMPLETE";
			case 8:
				return "BALL_OUTOFBOUNDS";
			case 9:
				return "BALL_INTERCEPTED";
			case 10:
				return "BALL_TURNOVER";
			case 11:
				return "BALL_SACKED";
			case 12:
				return "BALL_SAFETY";
			case 13:
				return "BALL_FUMBLED";
			case 14:
				return "BALL_FIELD_GOAL_GOOD";
			case 15:
				return "BALL_FIELD_GOAL_BAD";
			case 16:
				return "BALL_PRACTICE_SUCCESS";
			case 17:
				return "BALL_PRACTICE_FAIL";
			case 18:
				return "BALL_RUN_QB";
			case 19:
				return "BALL_HANDOFF";
			case 20:
				return "BALL_TOUCHBACK";
			case 21:
				return "BALL_INTERCEPTED_TB";
		}
	}
	return "ball.state == OTHER";
}

