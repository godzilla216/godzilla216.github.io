function s_change_wind() {
	with (obj_weather) {
		if (obj_master.gamepractice == 1) {
			return;
		}
		if (type == 2) {
			return;
		}
		switch (irandom(4)) {
			case 0:
				wind = clamp(wind + 1, 0, 9);
				break;
			case 1:
				wind = clamp(wind - 1, 0, 9);
				break;
			case 2:
				wind_dir += 1;
				break;
			case 3:
				wind_dir -= 1;
				break;
			default:
				break;
		}
		wind = clamp(wind, 0, 9);
		if (wind_dir > 7) {
			wind_dir = 0;
		}
		if (wind_dir < 0) {
			wind_dir = 7;
		}
	}
}

