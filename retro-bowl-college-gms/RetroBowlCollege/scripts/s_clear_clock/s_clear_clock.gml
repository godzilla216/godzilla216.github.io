function s_clear_clock() {
	with (obj_controller) {
		while (time_subtract > 0) {
			time_subtract--;
			seconds--;
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

