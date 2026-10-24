function s_update_ball() {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	var cont = obj_controller;
	if (!mouse_check_button(1)) {
		touch_starty = -1;
	} else if (touch_starty == -1) {
		touch_starty = my;
	}
	if (touch_starty >= 250 && state == 0) {
		return;
	}
	var gp_axis = 0;
	if (global.gamepad) {
		gp_axis = global.gp.axisl_force;
		if (s_get_op_invert_throw() == 3) {
			gp_axis = global.gp.axisr_force;
		}
	}
	switch (state) {
		case 18:
			if (s_can_throw() && s_is_touch_allowed() && mouse_check_button(1) && point_distance(x, y, mouse_x, mouse_y) < 40) {
				xtouch = mx;
				ytouch = my;
				state = 1;
			}
			if (holder) {
				s_update_ball_offset();
			}
			break;
		case 0:
			x = cont.x_scrim;
			y = cont.y_scrim;
			switch (obj_master.gamepractice) {
				case 3:
					cont.tap_msg = s_str("training_Throw1");
					break;
				case 2:
					cont.tap_msg = s_str("training_Throw3");
					if (obj_controller.practice_success == 0) {
						cont.tap_msg = s_str("training_Running1");
						if (os_type == 0 || os_type == 1) {
							cont.tap_msg = s_str("training_Running1b");
						}
					}
					break;
			}
			if (s_is_touch_allowed() && mouse_check_button(1) || global.gamepad && (gamepad_button_check_released(global.gp.slot, global.gp_handoff) || gp_axis) && !s_is_paused_or_just_unpaused()) {
				with (obj_playerOF) {
					if (position == 2 && (global.gamepad && gamepad_button_check_released(global.gp.slot, global.gp_handoff) && !s_is_paused_or_just_unpaused() || !global.gamepad && point_distance(x, y, mouse_x, mouse_y) < 20)) {
						slog("global.master_ball.state = BALL_HANDOFF;");
						global.master_ball.state = 19;
						obj_controller.play_start = current_time;
						obj_controller.running_play = true;
						s_sound_throw();
						instance_destroy(obj_btn_audible);
						instance_destroy(obj_btn_fieldgoal);
						break;
					}
				}
				if (obj_master.gamepractice != 2 || obj_controller.practice_success > 0) {
					if (state != 19) {
						xtouch = mx;
						ytouch = my;
						state = 1;
						slog("state = BALL_AIM_DEADZONE");
					}
				}
			}
			break;
		case 1:
			if (global.gamepad && gp_axis > 0.2) {
				state = 2;
				s_sound_throw();
			} else if (mouse_check_button(1) && s_is_touch_allowed()) {
				dragdist = point_distance(xtouch, ytouch, mx, my);
				if (dragdist > 20) {
					state = 2;
					s_sound_throw();
				}
			} else {
				state = 0;
				return;
			}
			break;
		case 2:
			instance_destroy(obj_btn_audible);
			instance_destroy(obj_btn_fieldgoal);
			if (obj_master.gamepractice == 3) {
				cont.tap_msg = s_str("training_Throw2");
			}
			if (obj_master.gamepractice == 2 && obj_controller.practice_success > 0) {
				cont.tap_msg = s_str("training_Throw3");
			}
			with (holder) {
				if (!path_exists(my_route) && !s_is_falling() && balldist < 10) {
					s_set_anim(11);
				}
				method(other, s_update_ball_offset)();
			}
			switch (global.gamepad) {
				case true:
					switch (s_get_op_invert_throw()) {
						case 0:
							if (gp_axis > 0.2) {
								dragx = clamp(dragx + global.gp.axisl_h * 2, -100, 100);
								dragy = clamp(dragy + global.gp.axisl_v * 2, -100, 100);
								dragdist = point_distance(0, 0, dragx, -dragy);
								direc = point_direction(0, 0, dragx, -dragy);
							}
							break;
						case 1:
							if (gp_axis > 0.2) {
								dragx = clamp(dragx - global.gp.axisl_h * 2, -100, 100);
								dragy = clamp(dragy - global.gp.axisl_v * 2, -100, 100);
								dragdist = point_distance(0, 0, dragx, -dragy);
								direc = point_direction(0, 0, dragx, -dragy);
							}
							break;
						case 2:
							des_drag = gp_axis * 100;
							dragdist = lerp(dragdist, des_drag, 0.25);
							dragdist = clamp(dragdist, 20, 100);
							des_direc = point_direction(0, 0, global.gp.axisl_h, -global.gp.axisl_v) + 180;
							direc -= angle_difference(direc, des_direc) * 0.1;
							break;
						case 3:
							des_drag = gp_axis * 100;
							dragdist = lerp(dragdist, des_drag, 0.25);
							dragdist = clamp(dragdist, 20, 100);
							des_direc = point_direction(0, 0, global.gp.axisr_h, -global.gp.axisr_v) + 180;
							direc -= angle_difference(direc, des_direc) * 0.1;
							break;
					}
					if ((!obj_master.gamepractice || obj_master.gamepractice == 2) && gamepad_button_check_released(global.gp.slot, 32771) || gamepad_button_check_released(global.gp.slot, 32777)) {
						with (holder) {
							if (path_exists(my_route)) {
								path_delete(my_route);
							}
						}
						s_qb_run(true);
					} else if (gamepad_button_check_released(global.gp.slot, global.gp_back) && !s_is_paused_or_just_unpaused()) {
						bullet_throw_hold = false;
						bullet_throw = !bullet_throw;
					}
					if (global.gp.triggerl) {
						bullet_throw_hold = true;
						bullet_throw = true;
					} else if (bullet_throw_hold) {
						bullet_throw_hold = false;
						bullet_throw = false;
					}
					if (bullet_throw && !obj_master.gamepractice) {
						velocity = dragdist * holder.my_throw_power * 1.2;
						zvel = velocity * 0.35 * 0.5;
					} else {
						velocity = dragdist * holder.my_throw_power;
						zvel = velocity * 0.35;
					}
					if (gamepad_button_check_released(global.gp.slot, global.gp_select)) {
						s_throw_ball();
					}
					break;
				case false:
					dragdist = min(point_distance(xtouch, ytouch, mx, my), 100);
					var finger_down = false;
					if (global.mobile_device || global.console_build) {
						if (device_mouse_check_button(0, 1) && s_is_touch_allowed()) {
							finger_down = true;
							if (device_mouse_check_button_released(1, 1)) {
								bullet_throw = !bullet_throw;
							}
						}
					} else if (mouse_check_button(1) && s_is_touch_allowed()) {
						finger_down = true;
						if (mouse_check_button_released(2)) {
							bullet_throw = !bullet_throw;
						}
					}
					if (finger_down) {
						direc = -point_direction(xtouch, ytouch, mx, my) + 180;
						if (bullet_throw) {
							velocity = dragdist * holder.my_throw_power * 1.2;
							zvel = velocity * 0.35 * 0.5;
						} else {
							velocity = dragdist * holder.my_throw_power;
							zvel = velocity * 0.35;
						}
					} else if (dragdist < 20 || s_opposite_aim(direc)) {
						with (holder) {
							if (path_exists(my_route)) {
								path_delete(my_route);
							}
						}
						s_qb_run(false);
					} else {
						s_throw_ball();
					}
					break;
			}
			break;
		case 3:
			cont.tap_msg = "";
			s_update_ball_movement(false);
			break;
		case 4:
		case 11:
			if (!obj_master.gamepractice && !instance_exists(obj_btn_timeout) && cont.minutes + cont.seconds > 0 && obj_controller.down < 5) {
				if (holder && holder.offense && s_count_timeouts() && !cont.timeout_called) {
					var bx = 32;
					var by = 48;
					if (cont.drivedir == -1) {
						bx = display_get_gui_width() - 32 - sprite_get_width(spr_audible);
					}
					var btn_to = instance_create_layer(bx, by, "Text", obj_btn_timeout);
					btn_to.gp_mapped_button = global.gp_timeout;
				}
			}
		case 6:
		case 7:
		case 8:
		case 13:
			if (holder) {
				s_update_ball_offset();
			} else {
				s_update_ball_movement(false);
			}
			break;
		case 19:
		case 9:
		case 21:
		case 20:
		case 10:
		case 5:
			if (obj_master.gamepractice == 2) {
				if (obj_controller.practice_success == 0) {
					cont.tap_msg = s_str("training_Running2");
					if (os_type == 0 || os_type == 1) {
						cont.tap_msg = s_str("training_Running2b");
					}
				} else {
					cont.tap_msg = s_str("training_Running3");
					if (os_type == 0 || os_type == 1) {
						if (obj_controller.drivedir == 1) {
							cont.tap_msg = s_str("training_Running3D");
						} else {
							cont.tap_msg = s_str("training_Running3A");
						}
					}
				}
			} else if (obj_master.gamepractice == 3) {
				cont.tap_msg = "";
				state = 16;
			} else {
			}
			s_update_ball_offset();
			break;
		case 14:
		case 15:
		case 16:
			if (holder) {
				s_update_ball_offset();
				return;
			}
		case 17:
			s_update_ball_movement(false);
			break;
	}
}

