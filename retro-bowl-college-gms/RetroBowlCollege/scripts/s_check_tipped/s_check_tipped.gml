function s_check_tipped() {
	if (obj_master.gamepractice) {
		return false;
	}
	if (s_is_kickoff(true)) {
		return false;
	}
	switch (anim) {
		case 10:
			break;
		case 5:
			return false;
			break;
		default:
			var low_catch = lerp(0.5, 0.4, skill * 0.1);
			if (obj_master.op_difficulty >= 3) {
				low_catch = lerp(0.55, 0.45, skill * 0.1);
			}
			with (obj_weather) {
				if (type != 0) {
					low_catch += 0.05;
				}
			}
			var ch = 30;
			if (global.master_ball.bullet_throw) {
				ch += 5;
			}
			if (global.master_ball.height < ch * low_catch) {
				slog(">>> Tipped: low");
				s_sound_bounce();
				s_drop_ball(false);
				return true;
			}
			break;
	}
	if (offense && intheclear) {
		return false;
	}
	if (!nearest_opp) {
		return false;
	}
	var oppballdist = nearest_opp.balldist;
	if (offense) {
		if (!pmap) {
			oppballdist -= 2;
		}
		if (global.master_ball.dropped_time > 0) {
			oppballdist += 5;
		}
	} else {
		oppballdist -= 5;
	}
	if (oppballdist < balldist || obj_controller.kicking) {
		slog(">>> Tipped: pressure");
		s_sound_bounce();
		s_drop_ball(false);
		return true;
	}
	return false;
}

