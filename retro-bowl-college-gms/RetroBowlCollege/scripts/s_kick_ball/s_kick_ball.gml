function s_kick_ball() {
	if (!obj_master.gamepractice && !s_is_kickoff(false)) {
		with (holder) {
			if (pmap) {
				if (obj_controller.kicking == 1) {
					ds_map_set(pmap, "stat_attempts", ds_map_find_value(pmap, "stat_attempts") + 1);
				} else {
					ds_map_set(pmap, "stat_attempts_XP", ds_map_find_value(pmap, "stat_attempts_XP") + 1);
				}
			}
		}
	}
	with (holder) {
		s_set_anim(15);
	}
	if (s_is_kickoff(false)) {
		if (kickpow < 15) {
			velocity *= 1.5;
			zvel *= 0.5;
		} else {
			velocity *= 0.7;
			zvel += 2.2;
		}
	} else {
		var placing = false;
		with (obj_playerOF) {
			if (anim == 13) {
				placing = true;
			}
		}
		if (!placing) {
			velocity *= random_range(0.4, 0.7);
		}
	}
	xthrow = x;
	ythrow = y;
	state = 3;
	roll = 9 + irandom(9);
	holder = -4;
	s_sound_kick();
	if (s_is_kickoff(false) && obj_controller.quarter == 1 && obj_controller.minutes == 2 + obj_master.op_matchlength) {
		s_sound_audience_fg();
	}
	if (obj_controller.tap_msg != "") {
		slog("s_kick_ball");
	}
	obj_controller.tap_msg = "";
}

