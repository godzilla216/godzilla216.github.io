function s_set_position_defense_fg() {
	x = obj_controller.x_scrim - 20 * facing;
	switch (inum) {
		case 1:
			position = 6;
			y = obj_controller.y_scrim - 6;
			break;
		case 2:
			position = 6;
			y = obj_controller.y_scrim + 6;
			break;
		case 3:
			x = obj_controller.x_scrim - 40 * facing;
			position = 6;
			y = obj_controller.y_scrim - 12;
			break;
		case 4:
			x = obj_controller.x_scrim - 40 * facing;
			position = 6;
			y = obj_controller.y_scrim + 12;
			break;
		case 5:
			position = 6;
			y = obj_controller.y_scrim - 18;
			break;
		case 6:
			position = 6;
			y = obj_controller.y_scrim + 18;
			break;
		case 7:
			position = 6;
			y = obj_controller.y_scrim - 30;
			break;
		case 8:
			position = 6;
			y = obj_controller.y_scrim + 30;
			break;
		case 9:
			position = 6;
			y = obj_controller.y_scrim - 48;
			break;
		case 10:
			position = 6;
			y = obj_controller.y_scrim + 48;
			break;
		case 11:
			x = obj_controller.x_scrim - 60 * facing;
			position = 6;
			y = obj_controller.y_scrim + 22;
			break;
	}
}

