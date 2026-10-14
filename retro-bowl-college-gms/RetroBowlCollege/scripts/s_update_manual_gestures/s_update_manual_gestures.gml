function s_update_manual_gestures() {
	global.flickVelX = 0;
	global.flickVelY = 0;
	with (global.master_ball) {
		if (state == 2) {
			obj_controller.mobbrow_start_time = 0;
			return;
		}
	}
	if (s_is_touch_allowed()) {
		switch (mobbrow_start_time) {
			case 0:
				if (mouse_check_button(1)) {
					mobbrow_start_time = current_time;
					mobbrow_start_x = mouse_x;
					mobbrow_start_y = mouse_y;
				}
				break;
			default:
				if (!mouse_check_button(1)) {
					mobbrow_start_time = 0;
					if (point_distance(mobbrow_start_x, mobbrow_start_y, mouse_x, mouse_y) > 20) {
						var dir = point_direction(mobbrow_start_x, mobbrow_start_y, mouse_x, mouse_y);
						global.flickVelX = dcos(dir) * 2;
						global.flickVelY = dsin(dir) * -2;
					}
				}
				break;
		}
	}
}

