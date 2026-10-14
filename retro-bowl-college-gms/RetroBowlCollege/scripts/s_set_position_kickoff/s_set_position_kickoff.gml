function s_set_position_return_ko() {
	position = 13;
	x = 1300 - 20 * facing;
	switch (inum) {
		case 1:
			y = obj_controller.y_scrim - 120;
			break;
		case 2:
			y = obj_controller.y_scrim - 70;
			break;
		case 3:
			y = obj_controller.y_scrim - 20;
			break;
		case 4:
			y = obj_controller.y_scrim + 60;
			break;
		case 5:
			y = obj_controller.y_scrim + 120;
			break;
		case 6:
			x -= 200 * facing;
			y = obj_controller.y_scrim - 100;
			break;
		case 7:
			x -= 200 * facing;
			y = obj_controller.y_scrim + 20;
			break;
		case 8:
			x -= 200 * facing;
			y = obj_controller.y_scrim + 110;
			break;
		case 9:
			x -= 400 * facing;
			y = obj_controller.y_scrim - 100;
			break;
		case 10:
			position = 14;
			x -= 1000 * facing;
			y = obj_controller.y_scrim;
			break;
		case 11:
			x -= 400 * facing;
			y = obj_controller.y_scrim + 100;
			break;
	}
	x += random_range(-2, 2);
	y += random_range(-2, 2);
}

function s_set_position_take_ko() {
	x = obj_controller.x_scrim - irandom_range(8, 13) * facing;
	position = 12;
	switch (inum) {
		case 1:
			position = 1;
			x = obj_controller.x_scrim - 40 * facing;
			y = obj_controller.y_scrim;
			return;
			break;
		case 2:
			y = obj_controller.y_scrim - 160;
			break;
		case 3:
			y = obj_controller.y_scrim - 130;
			break;
		case 4:
			y = obj_controller.y_scrim - 100;
			break;
		case 5:
			y = obj_controller.y_scrim - 70;
			break;
		case 6:
			y = obj_controller.y_scrim - 40;
			break;
		case 7:
			y = obj_controller.y_scrim + 40;
			break;
		case 8:
			y = obj_controller.y_scrim + 70;
			break;
		case 9:
			y = obj_controller.y_scrim + 100;
			break;
		case 10:
			y = obj_controller.y_scrim + 130;
			break;
		case 11:
			y = obj_controller.y_scrim + 160;
			break;
	}
	y += irandom_range(-2, 2);
}

