slog("obj_controller_Alarm0: " + s_get_string_ball_state());
var ball = global.master_ball;
switch (obj_master.gamepractice) {
	case 2:
	case 3:
	case 4:
		s_set_up_practice();
		exit;
		break;
}
if (s_is_kickoff(false)) {
	if (ball.state == 8) {
		yards = 10;
		down = 1;
		scrimmage = -15;
		s_start_replay(0);
		exit;
	} else if (ball.state == 20) {
		slog("KO Touchback");
		yards = 10;
		down = 1;
		scrimmage = -25;
		s_start_replay(0);
		exit;
	}
}
switch (ball.state) {
	case 0:
	case 2:
	case 3:
	case 5:
	case 6:
		if (obj_controller.down < 6 || obj_controller.down == 99) {
			global.replay_do = true;
		}
		if (ball.holder && ball.holder.offense || ball.last_touched_by && ball.last_touched_by.offense) {
			s_start_replay(1);
		} else {
			s_action_result(2);
		}
		break;
	case 20:
		yards = 10;
		down = 1;
		scrimmage = -25;
		s_start_replay(0);
		break;
	case 21:
		yards = 10;
		down = 1;
		scrimmage = 25;
	case 9:
		defense_success[defensive_cover] += 1;
		global.replay_do = true;
		s_start_replay(3);
		break;
	case 10:
		defense_success[defensive_cover] += 1;
		s_start_replay(4);
		break;
	case 4:
	case 8:
		if (s_is_kickoff(true)) {
			yards = 10;
			down = 1;
			scrimmage = drivedir * ((ball.xdead - 1300) / 20);
			s_start_replay(0);
			exit;
		}
		if (ball.holder && !ball.holder.offense) {
			if (drivedir == 1) {
				scrimmage += (ball.xdead - x_scrim) / 20;
			} else {
				scrimmage += (x_scrim - ball.xdead) / 20;
			}
			defense_success[defensive_cover] += 1;
			global.replay_do = true;
			s_start_replay(3);
			exit;
		}
		if (drivedir == 1 && ball.xdead > x_yards) {
			yards = 10;
			down = 1;
			scrimmage += (ball.xdead - x_scrim) / 20;
		} else if (drivedir == -1 && ball.xdead < x_yards) {
			yards = 10;
			down = 1;
			scrimmage += (x_scrim - ball.xdead) / 20;
		} else if (drivedir == 1 && ball.xdead > x_scrim) {
			var gain = (ball.xdead - x_scrim) / 20;
			yards -= gain;
			down += 1;
			scrimmage += gain;
			defense_success[defensive_cover] += 1;
		} else if (drivedir == -1 && ball.xdead < x_scrim) {
			var gain = (x_scrim - ball.xdead) / 20;
			yards -= gain;
			down += 1;
			scrimmage += gain;
			defense_success[defensive_cover] += 1;
		} else if (drivedir == 1) {
			var loss = (x_scrim - ball.xdead) / 20;
			yards += loss;
			down += 1;
			scrimmage -= loss;
			defense_success[defensive_cover] += 1;
		} else {
			var loss = (ball.xdead - x_scrim) / 20;
			yards += loss;
			down += 1;
			scrimmage -= loss;
			defense_success[defensive_cover] += 1;
		}
		slog("Alarm[0]=BALL_DOWN");
		s_start_replay(0);
		break;
	case 7:
		down += 1;
		slog("Alarm[0]=BALL_INCOMPLETE");
		s_start_replay(0);
		break;
	case 11:
		if (drivedir == 1) {
			var loss = (x_scrim - ball.xdead) / 20;
			yards += loss;
			down += 1;
			scrimmage -= loss;
		} else {
			var loss = (ball.xdead - x_scrim) / 20;
			yards += loss;
			down += 1;
			scrimmage -= loss;
		}
		slog("Alarm[0]=BALL_SACKED");
		s_start_replay(0);
		break;
	case 12:
		s_start_replay(8);
		break;
	case 13:
		s_start_replay(3);
		break;
	case 14:
		s_start_replay(6);
		break;
	case 15:
		s_start_replay(7);
		break;
	case 16:
		slog("BALL_PRACTICE_SUCCESS");
		s_end_match(true);
		break;
	case 17:
		break;
	case 18:
	case 19:
		break;
}
