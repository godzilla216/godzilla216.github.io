function s_can_throw() {
	with (global.master_ball.holder) {
		if (position != 1) {
			return false;
		}
		switch (facing) {
			case -1:
				if (x < obj_controller.x_scrim) {
					return false;
				}
				break;
			case 1:
				if (x > obj_controller.x_scrim) {
					return false;
				}
				break;
		}
		return true;
	}
	return false;
}

