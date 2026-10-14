function s_draw_kick_cone() {
	if (s_is_kickoff(false)) {
		return;
	}
	with (obj_weather) {
		if (type == 2) {
			draw_set_color(0);
		} else {
			draw_set_color(16777215);
		}
	}
	draw_set_alpha(0.075);
	var gl = 90;
	if (obj_controller.drivedir == 1) {
		gl = 2510;
	}
	with (global.master_ball) {
		switch (state) {
			case 0:
			case 2:
			case 1:
				with (holder) {
					draw_triangle(gl, 270, gl, 332, x, y, false);
				}
				break;
		}
	}
	draw_set_color(16777215);
	draw_set_alpha(1);
}

