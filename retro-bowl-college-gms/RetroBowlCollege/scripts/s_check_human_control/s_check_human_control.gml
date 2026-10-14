function s_check_human_control() {
	if (!global.master_ball.holder) {
		return;
	}
	if (global.master_ball.holder != id) {
		return;
	}
	if (s_can_run()) {
		if (global.gamepad) {
			if (!global.gp.axisr_flick) {
				if (global.gp.axisr_v < -0.75) {
					global.flickVelY = -1;
					global.gp.axisr_flick = true;
				}
				if (global.gp.axisr_v > 0.75) {
					global.flickVelY = 1;
					global.gp.axisr_flick = true;
				}
				if (global.gp.axisr_h < -0.75) {
					global.flickVelX = -1;
					global.gp.axisr_flick = true;
				}
				if (global.gp.axisr_h > 0.75) {
					global.flickVelX = 1;
					global.gp.axisr_flick = true;
				}
				if (!global.gp.axisr_flick) {
					var _pressed = 0;
					if (s_can_touchback()) {
						_pressed = gamepad_button_check(global.gp.slot, global.gp_back);
					} else {
						_pressed = gamepad_button_check_released(global.gp.slot, global.gp_back);
					}
					if (_pressed && !s_is_paused_or_just_unpaused()) {
						global.gp.axisr_flick = true;
						if (abs(global.gp.axisl_v) < 0.2 && abs(global.gp.axisl_h) < 0.2) {
							if (facing == -1) {
								global.flickVelX = 1;
							} else {
								global.flickVelX = -1;
							}
						} else if (global.gp.axisl_v < 0) {
							global.flickVelY = -1;
						} else {
							global.flickVelY = 1;
						}
					}
					if (gamepad_button_check(global.gp.slot, global.gp_select)) {
						s_do_dive();
					}
				}
			}
		} else {
			if (keyboard_check_pressed(87)) {
				global.flickVelY = -2;
			}
			if (keyboard_check_pressed(83)) {
				global.flickVelY = 2;
			}
			if (keyboard_check_pressed(65)) {
				global.flickVelX = -2;
			}
			if (keyboard_check_pressed(68)) {
				global.flickVelX = 2;
			}
			if (keyboard_check_pressed(38)) {
				global.flickVelY = -2;
			}
			if (keyboard_check_pressed(40)) {
				global.flickVelY = 2;
			}
			if (keyboard_check_pressed(37)) {
				global.flickVelX = -2;
			}
			if (keyboard_check_pressed(39)) {
				global.flickVelX = 2;
			}
		}
		if (abs(global.flickVelY) > abs(global.flickVelX) * 0.85) {
			hspeed *= 0.1;
			if (global.gamepad) {
				if (vspeed < 0.2) {
					vspeed = sign(global.flickVelY) * my_sidestep * 0.8;
				} else if (vspeed > 0.2) {
					vspeed = sign(global.flickVelY) * my_sidestep * 0.8;
				} else {
					vspeed = sign(global.flickVelY) * my_sidestep;
				}
			} else {
				vspeed = sign(global.flickVelY) * my_sidestep;
			}
			global.flickVelX = 0;
			global.flickVelY = 0;
			jforce = 0;
			if (path_exists(my_route)) {
				path_delete(my_route);
			}
			if (!obj_master.gamepractice) {
				my_sidestep *= 0.925;
			}
		}
		if (abs(global.flickVelX)) {
			if (global.flickVelX > 0 && facing == -1 || global.flickVelX < 0 && facing == 1) {
				s_do_stutterstep();
			} else {
				s_do_dive();
			}
			jforce = 0;
			if (path_exists(my_route)) {
				path_delete(my_route);
			}
		}
		if (my_sidestep < 2.1) {
			my_sidestep += 0.003;
		}
	}
	global.flickVelX = 0;
	global.flickVelY = 0;
}

function s_do_dive() {
	if (!obj_master.gamepractice || obj_controller.practice_success > 0) {
		s_set_anim(5);
		jforce = 0;
		if (path_exists(my_route)) {
			path_delete(my_route);
		}
	}
}

function s_do_stutterstep() {
	s_set_anim(7);
	jforce = 0;
	if (path_exists(my_route)) {
		path_delete(my_route);
	}
}

