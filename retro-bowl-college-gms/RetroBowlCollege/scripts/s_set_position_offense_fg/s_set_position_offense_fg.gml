function s_set_position_offense_fg() {
	x = obj_controller.x_scrim - 20 * facing;
	switch (inum) {
		case 1:
			position = 1;
			x = obj_controller.x_scrim - 120 * facing;
			y = obj_controller.y_scrim;
			break;
		case 2:
			position = 11;
			x = obj_controller.x_scrim - 80 * facing;
			y = obj_controller.y_scrim;
			break;
		case 3:
			position = 5;
			x = obj_controller.x_scrim - 10 * facing;
			y = obj_controller.y_scrim;
			break;
		case 4:
			position = 5;
			y = obj_controller.y_scrim - 8;
			break;
		case 5:
			position = 5;
			y = obj_controller.y_scrim + 8;
			break;
		case 6:
			position = 5;
			y = obj_controller.y_scrim - 18;
			break;
		case 7:
			position = 5;
			y = obj_controller.y_scrim + 18;
			break;
		case 8:
			position = 5;
			y = obj_controller.y_scrim - 28;
			break;
		case 9:
			position = 5;
			y = obj_controller.y_scrim + 28;
			break;
		case 10:
			position = 5;
			x = obj_controller.x_scrim - 30 * facing;
			y = obj_controller.y_scrim - 38;
			break;
		case 11:
			position = 5;
			x = obj_controller.x_scrim - 30 * facing;
			y = obj_controller.y_scrim + 38;
			break;
	}
}

