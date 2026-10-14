function s_update_game_timer() {
	if (minutes <= 0 && seconds <= 0) {
		return;
	}
	if (kicking == 2) {
		return;
	}
	if (timeout_called) {
		return;
	}
	if (down > 4 && down < 99) {
		return;
	}
	if (s_is_kickoff(false)) {
		return;
	}
	if (college_overtime) {
		return;
	}
	with (global.master_ball) {
		switch (state) {
			case 0:
			case 1:
			case 6:
			case 7:
			case 8:
			case 12:
			case 14:
			case 15:
			case 16:
			case 17:
			case 20:
				return;
				break;
			default:
				if (state == 4 && holder) {
					if (!holder.offense || s_is_kickoff(true)) {
						return;
					} else if (obj_controller.down == 4 && holder.remaining_dist > 0) {
						return;
					}
				}
				if (s_is_kickoff(true) && (x < 300 || x > 2300)) {
					return;
				}
				var sec = 700;
				if (state == 4 && obj_master.op_matchlength == -1) {
					sec *= 1.5;
				}
				if (current_time > other.gametimer + sec) {
					other.gametimer = current_time;
					s_subtract_time(1, 1, "Tick");
					s_update_game_clock();
				}
				break;
		}
	}
}

