function s_update_ball_movement(_arg0) {
	last_x = x;
	last_y = y;
	switch (obj_controller.kicking) {
		case 0:
			velocity *= 0.986;
			zvel -= 0.08;
			break;
		default:
			velocity *= 0.9995;
			zvel -= 0.03;
			break;
	}
	x += dcos(direc) * velocity;
	y += dsin(direc) * velocity;
	lastheight = height;
	height += zvel;
	rotation += roll;
	if (_arg0) {
		return;
	}
	if (height <= 1) {
		if (s_is_kickoff(false)) {
			if (x < 300 || x > 2300) {
				slog("BALL_TOUCHBACK 6");
				state = 20;
				ydead = round(y);
				xdead = round(x);
				obj_controller.y_down = y;
			}
		} else if (state != 6) {
			if (last_touched_by) {
				if (last_touched_by.offense) {
					if (!obj_master.gamepractice) {
						state = 13;
					}
				} else {
					s_set_ball_down();
				}
			}
		}
		if (zvel < -1) {
			s_sound_bounce();
		}
		bouncecount += 1;
		height = 1;
		zvel *= -0.5;
		velocity *= random_range(0.2, 0.5);
		direc += random_range(-40, 40);
		roll = irandom(15);
	}
	if (velocity < 0.1) {
		velocity = 0;
		roll = 0;
		rotation = 0;
	}
	if (bouncecount == 0 && obj_controller.kicking && !s_is_kickoff(true)) {
		with (obj_weather) {
			if (wind > 0) {
				wind_force = clamp(wind_force + 0.008, 0, wind);
				other.x += dcos(wind_dir * 45) * wind_force;
				other.y += dsin(-wind_dir * 45) * wind_force;
			}
		}
	}
	s_check_dummy_collision();
}

