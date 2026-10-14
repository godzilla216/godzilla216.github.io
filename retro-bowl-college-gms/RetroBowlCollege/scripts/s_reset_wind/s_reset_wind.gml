function s_reset_wind() {
	with (obj_weather) {
		wind_force = 0;
		if (type == 2) {
			wind = 0;
			return;
		}
		if (obj_master.gamepractice == 1) {
			wind = 5;
			if (obj_controller.practice_success == 0) {
				wind = 0;
			}
		}
	}
}

