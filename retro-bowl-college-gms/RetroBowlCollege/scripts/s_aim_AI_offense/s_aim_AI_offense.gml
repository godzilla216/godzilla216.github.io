function s_aim_AI_offense() {
	if (s_is_kickoff(true)) {
		return s_aim_AI_kickoff();
	}
	if (path_exists(my_route)) {
		jforce = 1;
		jdir = s_point_to_path();
	}
	if (position == 2 && pmap && s_aiming()) {
		jforce = 0.9;
		var slowdown = false;
		with (obj_playerDF) {
			if (position == 6 && point_distance(x, y, other.x, other.y) < 40) {
				slowdown = true;
				break;
			}
		}
		if (slowdown) {
			jforce = 0.5;
		}
	}
	var ball = global.master_ball;
	switch (position) {
		case 1:
			if (!path_exists(my_route)) {
				jforce = 0;
				if (ball.holder == id && ball.state == 19 && balldist < 5) {
					s_set_anim(12);
					with (obj_playerOF) {
						if (position == 2) {
							s_receive_ball();
							s_sound_bounce();
						}
					}
				}
			}
			break;
		case 5:
			if (tackling) {
				jforce = 1;
				jdir = point_direction(x, y, tackling.x, tackling.y);
				break;
			} else if (!last_tackled || nearest_opp && nearest_opp_dist < 20) {
				s_aim_for_nearest_opponent();
			} else {
				jforce = 0;
			}
			break;
		case 2:
			if (ball.state == 19 && balldist < 40) {
				with (obj_playerOF) {
					if (position == 1) {
						s_set_anim(12);
					}
				}
				s_receive_ball();
				s_sound_bounce();
				return;
			}
		case 3:
		case 4:
			if (tackling) {
				switch (strength mod 2) {
					case 0:
						jdir = 90;
						break;
					case 1:
						jdir = 270;
						break;
				}
			} else if (ball.state == 3 && bouncedist < 100) {
				jdir = point_direction(x, y, obj_metaball.bounce_x, obj_metaball.bounce_y);
				jforce = clamp(bouncedist / 40, 0.25, 1);
			} else if (!path_exists(my_route)) {
				jforce = 0;
				if (my_route_end_dir != 999 && !obj_master.gamepractice) {
					jdir = my_route_end_dir;
					jforce = 1;
				}
			}
			break;
	}
	if (!path_exists(my_route)) {
		var armstrength = 0;
		var qb = s_get_quarterback();
		if (qb && qb.pmap) {
			armstrength = s_get_attribute(qb.pmap, "strength");
		} else if (global.exhibition) {
			armstrength = obj_controller.team_offense[obj_controller.possession];
		}
		var dist = 260 + armstrength * 40;
		if (qb && (ball.state == 2 || ball.state == 1)) {
			if (balldist > dist) {
				jdir = balldir;
				jforce = 0.1;
			}
		}
	}
}

