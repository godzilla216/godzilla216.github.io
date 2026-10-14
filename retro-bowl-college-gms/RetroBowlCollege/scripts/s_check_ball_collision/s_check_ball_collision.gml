function s_check_ball_collision() {
	if (balldist > 20) {
		return false;
	}
	if (dead) {
		return;
	}
	if (tackling) {
		return;
	}
	if (anim == 4) {
		return;
	}
	if (position == 5) {
		return;
	}
	if (y < 132 || y > 468) {
		return;
	}
	var ball = global.master_ball;
	var cont = obj_controller;
	if (position == 1 && ball.state == 3) {
		return;
	}
	if (current_time < ball.dropped_time + 750) {
		return;
	}
	if (ball.is_dead) {
		return;
	}
	if (ball.holder) {
		return;
	}
	var air_yards = point_distance(x, y, ball.xthrow, ball.ythrow) / 20;
	var throw_distance = 0;
	throw_distance = (x - cont.x_scrim) / 20;
	if (facing == -1) {
		throw_distance = (cont.x_scrim - x) / 20;
	}
	switch (anim) {
		case 10:
			if (ball.height > 60) {
				return false;
			}
			break;
		case 5:
			if (ball.height > 15) {
				return false;
			}
			break;
		default:
			if (ball.height > 30) {
				return false;
			}
			break;
	}
	switch (offense) {
		case true:
			if (distance_to_point(obj_metaball.bounce_x, obj_metaball.bounce_y) > 100) {
				return false;
			}
			if (s_is_kickoff(false)) {
				s_sound_bounce();
				s_receive_ball();
				obj_controller.kicking = 0;
				obj_controller.possession = !obj_controller.possession;
				obj_controller.x_scrim = clamp(ball.x, 300, 2300);
			} else if (ball.state == 13) {
				ball.holder = id;
				ball.state = 5;
				s_fieldtxt(s_str("match_Recovered") + "!");
				if (anim != 5) {
					s_set_anim(5);
				}
				s_sound_bounce();
			} else if (throw_distance <= 0 || !s_check_tipped()) {
				var catch_radius = (obj_controller.difficulty + 5) / 15;
				if (obj_master.op_difficulty >= 3 && pmap) {
					catch_radius = s_get_attribute(pmap, "skill") / 11;
				}
				var cdif = lerp(0.75, 1, catch_radius);
				if (balldist > 20 * cdif) {
					slog("catch radius fail");
					return false;
				}
				s_sound_bounce();
				s_receive_ball();
				if (!cont.running_play && !obj_master.gamepractice && obj_controller.down < 5 && !obj_controller.drop_happened) {
					with (obj_playerOF) {
						if (pmap && (position == 1 || position == 5)) {
							ds_map_set_post(pmap, "stat_complete", ds_map_find_value(pmap, "stat_complete") + 1);
						}
					}
				}
				if (!cont.running_play && global.master_ball.dropped_time == 0) {
					s_complete_achievement("ACH_PASS");
					if (throw_distance > 0) {
						s_fieldtxt(s_str("match_Caught") + "!");
						s_check_record("ui_LongPassAir", air_yards, s_get_qb_name(), s_get_holder_name(), s_get_opponent_team_tla());
					}
				}
			}
			break;
		case false:
			var catch_radius = (obj_controller.difficulty + 5) / 15;
			var cdif = lerp(0.9, 0.5, catch_radius);
			if (obj_master.op_difficulty >= 3) {
				cdif = lerp(0.95, 0.8, catch_radius);
			}
			if (balldist > 20 * cdif) {
				return false;
			}
			if (distance_to_point(ball.xthrow, ball.ythrow) < 100) {
				return false;
			}
			if (s_is_kickoff(false)) {
				s_sound_bounce();
				s_receive_ball();
				obj_controller.kicking = 0;
			} else if (ball.state == 13) {
				ball.holder = id;
				ball.state = 10;
				s_create_match_message(10);
				if (anim != 5) {
					s_set_anim(5);
				}
				s_sound_bounce();
				s_sound_audience_dis();
			} else if (!s_check_tipped()) {
				s_sound_bounce();
				s_receive_ball();
				if (global.master_ball.fumble_time == 0) {
					if ((ball.x < 300 || ball.x > 2300) && obj_controller.down != 6) {
						ball.state = 21;
						s_create_match_message(21);
					} else {
						ball.state = 9;
						if (!cont.running_play && cont.down < 5 && !obj_master.gamepractice) {
							var qb = s_get_quarterback();
							if (qb && qb.pmap) {
								ds_map_set_post(qb.pmap, "stat_int", ds_map_find_value(qb.pmap, "stat_int") + 1);
							}
						}
						s_create_match_message(9);
					}
				}
				s_sound_audience_dis();
			}
			break;
	}
}

