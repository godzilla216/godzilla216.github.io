function s_update_game_clock() {
	with (obj_controller) {
		if (time_subtract > 0) {
			time_subtract--;
			seconds--;
			if (state == 2) {
				if (obj_master.gamepractice) {
					if (minutes == 0) {
						if (seconds < 6) {
							s_sound(snd_beep2);
						} else {
							s_sound(snd_beep);
						}
					}
				} else if (quarter == 2 || quarter == 4) {
					if (minutes == 0 && seconds == 20) {
						s_sound(snd_beep2);
					}
					if (minutes == 0 && seconds < 11) {
						s_sound(snd_beep);
					}
				}
			}
			if (seconds < 0) {
				minutes--;
				seconds += 60;
				if (minutes < 0) {
					minutes = 0;
					seconds = 0;
				}
			}
		}
	}
}

