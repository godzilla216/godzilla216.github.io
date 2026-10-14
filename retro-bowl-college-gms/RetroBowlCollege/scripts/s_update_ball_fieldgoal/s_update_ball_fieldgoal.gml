function s_update_ball_fieldgoal() {
	var cont = obj_controller;
	switch (state) {
		case 0:
			if (obj_master.gamepractice == 1) {
				cont.tap_msg = s_str("training_Kick1");
				if (os_type == 0 || os_type == 1) {
					cont.tap_msg = s_str("training_Kick1b");
				}
			}
			x = cont.x_scrim;
			y = cont.y_scrim;
			var sp = 1.4 - holder.my_kick_skill * 0.05;
			switch (kickflip) {
				case -1:
					kickpow -= 5;
					break;
				case 1:
					kickpow += sp;
					break;
			}
			if (kickpow >= 55) {
				kickpow = 55;
				kickflip = -kickflip;
			}
			if (kickpow <= 0) {
				kickpow = 0;
				kickflip = -kickflip;
			}
			s_update_ball_offset();
			if (s_cpu_is_kicking_off()) {
				if (obj_master.tag_kr_message_done == 3) {
					cpu_kickpow = 55;
					obj_master.tag_kr_message_done = 4;
				}
				if (round(kickpow) == round(cpu_kickpow)) {
					state = 1;
				}
				break;
			}
			if (global.gamepad && gamepad_button_check(global.gp.slot, global.gp_select)) {
				state = 1;
			} else if (mouse_check_button(1) && s_is_touch_allowed()) {
				with (obj_btn_goforit) {
					if (device_mouse_y_to_gui(0) > y + sprite_height) {
						other.state = 1;
					}
					return;
				}
				state = 1;
			}
			break;
		case 1:
			instance_destroy(obj_btn_goforit);
			if (s_cpu_is_kicking_off() || !mouse_check_button(1) && (!global.gamepad || !gamepad_button_check(global.gp.slot, global.gp_select))) {
				state = 2;
				with (holder) {
					s_set_anim(14);
				}
			} else {
				direc = s_get_kick_direction();
			}
			break;
		case 2:
			if (obj_master.gamepractice == 1) {
				cont.tap_msg = s_str("training_Kick2");
				if (os_type == 0 || os_type == 1) {
					cont.tap_msg = s_str("training_Kick2b");
				}
			}
			if (holder) {
				s_update_ball_offset();
				var d = point_distance(x, y, holder.x, holder.y);
				if (d < 30) {
					with (obj_playerOF) {
						if (position == 11) {
							image_index = 1;
						}
					}
				}
				if (d > 25) {
					break;
				}
			}
			if (kickpow < 15) {
				direc = random_range(-5, 5);
				if (holder.facing == -1) {
					direc = 180 + irandom_range(-5, 5);
				}
				velocity = (50 + kickpow) * holder.my_kick_power;
				zvel = velocity * 0.4;
				s_kick_ball();
				break;
			}
			direc = s_get_kick_direction();
			velocity = (50 + kickpow) * holder.my_kick_power;
			zvel = velocity * 0.4;
			if (s_cpu_is_kicking_off()) {
				s_kick_ball();
			} else if (mouse_check_button(1) && s_is_touch_allowed()) {
				s_kick_ball();
			} else if (global.gamepad && gamepad_button_check(global.gp.slot, global.gp_select)) {
				s_kick_ball();
			}
			break;
		case 3:
			s_update_ball_movement(false);
			break;
		case 4:
		case 6:
		case 7:
		case 8:
		case 11:
		case 12:
		case 13:
		case 5:
			if (holder) {
				s_update_ball_offset();
			} else {
				s_update_ball_movement(false);
			}
			break;
		case 9:
		case 21:
		case 10:
		case 14:
		case 15:
		case 16:
		case 17:
		case 20:
			s_update_ball_movement(false);
			break;
	}
}

