function s_set_position_defense() {
	x = obj_controller.x_scrim - 20 * facing;
	switch (inum) {
		case 1:
			position = 6;
			y = obj_controller.y_scrim - 18;
			break;
		case 2:
			position = 6;
			y = obj_controller.y_scrim + 18;
			break;
		case 3:
			position = 6;
			y = obj_controller.y_scrim - 36;
			break;
		case 4:
			position = 6;
			y = obj_controller.y_scrim + 36;
			break;
		case 5:
			position = 7;
			x = obj_controller.x_scrim - random_range(40, 60) * facing;
			y = obj_controller.y_scrim - random_range(40, 50);
			if (obj_controller.defensive_cover == 3) {
				position = 9;
			}
			if (obj_controller.defensive_cover == 0) {
				x = obj_controller.x_scrim - 40 * facing;
			}
			break;
		case 6:
			position = 7;
			x = obj_controller.x_scrim - random_range(40, 60) * facing;
			y = obj_controller.y_scrim + random_range(40, 50);
			if (obj_controller.defensive_cover == 3) {
				position = 9;
			}
			if (obj_controller.defensive_cover == 0) {
				x = obj_controller.x_scrim - 40 * facing;
			}
			break;
		case 7:
			position = 9;
			x = obj_controller.x_scrim - 140 * facing;
			y = obj_controller.y_scrim + 60;
			if (obj_controller.defensive_cover == 1 || obj_controller.defensive_cover == 3) {
				x = obj_controller.x_scrim - 180 * facing;
				y = obj_controller.y_scrim;
			}
			if (obj_controller.defensive_cover == 0) {
				position = 7;
				x = obj_controller.x_scrim - 20 * facing;
				y = obj_controller.y_scrim + 70;
			}
			break;
		case 8:
			position = 8;
			x = obj_controller.x_scrim - 40 * facing;
			y = obj_controller.y_scrim - 100;
			if (obj_controller.y_scrim > 300) {
				y = obj_controller.y_scrim - 140;
			}
			if (obj_controller.defensive_cover == 3 && obj_controller.yards > 3) {
				position = 9;
				x = obj_controller.x_scrim - 100 * facing;
			}
			if (obj_controller.down >= 6) {
				x = obj_controller.x_scrim - 20 * facing;
			}
			break;
		case 9:
			position = 8;
			x = obj_controller.x_scrim - 40 * facing;
			y = obj_controller.y_scrim + 100;
			if (obj_controller.y_scrim < 300) {
				y = obj_controller.y_scrim + 140;
			}
			if (obj_controller.defensive_cover == 3 && obj_controller.yards > 3) {
				position = 9;
				x = obj_controller.x_scrim - 100 * facing;
			}
			if (obj_controller.down >= 6) {
				x = obj_controller.x_scrim - 20 * facing;
			}
			break;
		case 10:
			position = 7;
			x = obj_controller.x_scrim - 80 * facing;
			y = obj_controller.y_scrim;
			if (obj_controller.defensive_cover == 0) {
				position = 9;
				x = obj_controller.x_scrim - 80 * facing;
			}
			break;
		case 11:
			position = 9;
			x = obj_controller.x_scrim - 160 * facing;
			y = obj_controller.y_scrim - 20;
			if (obj_controller.defensive_cover == 1) {
				position = 7;
				x = obj_controller.x_scrim - 120 * facing;
				y = obj_controller.y_scrim + random_range(-1, 1) * 20;
			}
			if (obj_controller.defensive_cover == 3) {
				position = 7;
				x = obj_controller.x_scrim - 140 * facing;
				y = obj_controller.y_scrim + random_range(-1, 1) * 20;
			}
			if (obj_controller.defensive_cover == 0) {
				position = 7;
				x = obj_controller.x_scrim - 20 * facing;
				y = obj_controller.y_scrim - 70;
			}
			break;
	}
	if (position != 6) {
		y += randyards;
	}
	if (x < 280) {
		var yds_back = 280 - x;
		x = 300 - yds_back / 2;
	} else if (x > 2320) {
		var yds_back = x - 2320;
		x = 2300 + yds_back / 2;
	}
}

