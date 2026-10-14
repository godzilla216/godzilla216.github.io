function s_obj_player_draw_begin() {
	if (obj_controller.state == 3) {
		return;
	}
	var ball = global.master_ball;
	switch (ball.state) {
		case 0:
		case 1:
		case 2:
		case 18:
		case 19:
			if (path_exists(my_route)) {
				s_draw_my_route();
			}
			break;
	}
	if (obj_controller.state == 10) {
		return;
	}
	var f = (sin(current_time / 60) + 1) / 2;
	if (dead) {
		f = (sin(current_time / 120) + 1) / 2;
	}
	if (ball.holder == id) {
		if (obj_master.gamepractice == 2 && obj_controller.practice_success == 0) {
			f = 0;
		}
		draw_sprite_ext(spr_highlight, 0, x, y, 2, 2, 0, 16777215, f);
	} else if (position == 2 && ball.state == 0) {
		if (obj_master.gamepractice != 2) {
			f = 1;
		}
		var s = 2.5 + sin(current_time / 100) * 0.5;
		draw_sprite_ext(spr_highlight, 0, x, y, s, s, 0, global.c_routes_rb, f);
	}
}

