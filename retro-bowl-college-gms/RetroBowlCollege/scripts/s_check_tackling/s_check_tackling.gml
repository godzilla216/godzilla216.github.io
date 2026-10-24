function s_check_tackling() {
	if (dead) {
		return;
	}
	if (anim == 4) {
		return;
	}
	if (anim == 8) {
		return;
	}
	if (anim == 10) {
		return;
	}
	var ball = global.master_ball;
	var cont = obj_controller;
	if (!tackling && ball.holder != id) {
		with (nearest_opp) {
			if (ball.holder != id && ball.state != 5 && (is_defensiveback(id) || is_defensiveback(other.id))) {
				if (current_time < tackle_time + 2000) {
					continue;
				}
				if (!path_exists(my_route) && !path_exists(other.my_route)) {
					continue;
				}
			}
			if (offense == other.offense) {
				continue;
			}
			var odist = point_distance(x, y, other.x, other.y);
			if (odist > 40) {
				continue;
			}
			if (anim != 4 && anim != 5 && anim != 8 && anim != 10 && (!tackling || ball.holder == id)) {
				if (ball.holder == id && other.anim == 5 && other.speed > 0.1 && place_meeting(x, y, other) && abs(y - other.y) < 10) {
					if (cont.kicking == 1 || cont.kicking == 2) {
						ball.state = 15;
						ball.velocity = 0;
						ball.zvel = 0;
						return;
					} else if (jumps > 0) {
						s_sound_tackle();
						hspeed = other.hspeed * 0.5;
						vspeed = other.vspeed * 0.5;
						s_set_anim(8);
						other.dead = current_time;
						other.speed *= 0.9;
						return;
					} else {
						s_sound_tackle();
						s_set_anim(4);
						other.speed *= 0.75;
						hspeed = other.hspeed;
						vspeed = other.vspeed;
						return;
					}
				} else if (odist < collsize) {
					if (!s_opponent_goalside(other)) {
						other.hspeed += hspeed * (strength / 5);
						other.vspeed += vspeed * (strength / 5);
					} else {
						speed *= 0.5;
						other.speed *= 0.5;
					}
					x = xprevious;
					y = yprevious;
					other.x = other.xprevious;
					other.y = other.yprevious;
					tackling = other.id;
					tackle_time = current_time;
					s_set_anim(3);
					other.tackling = id;
					other.tackle_time = current_time;
					method(other, s_set_anim)(3);
					s_sound_tackle();
				}
			}
		}
	} else if (!dead && ball.holder && ball.holder != id && !ball.holder.tackling) {
		if (point_distance(x, y, ball.holder.x, ball.holder.y) < 5) {
			ball.holder.hspeed *= s_is_kickoff(true) ? 0.5 : 0.9;
			if (y < ball.holder.y) {
				ball.holder.vspeed += 0.06;
			} else {
				ball.holder.vspeed -= 0.06;
			}
		}
	}
	if (anim == 5) {
		return;
	}
	if (tackling) {
		last_tackled = tackling;
		var dist_tack = point_distance(x, y, tackling.x, tackling.y);
		var dist_break = 12;
		if (s_is_kickoff(true)) {
			dist_break = 20;
		}
		if (tackling.dead) {
			tackling.tackling = -4;
			s_set_anim(0);
		} else if (dist_tack > dist_break || current_time > tackle_time + 100 && path_exists(my_route)) {
			with (tackling) {
				s_set_anim(2);
			}
			s_set_anim(2);
		} else if (ball.holder == id && stiff_arm > 0) {
			s_fieldtxt(s_str("match_StiffArm"));
			s_sound_audience_catch();
			if (y < tackling.y) {
				tackling.vspeed = 1;
			} else {
				tackling.vspeed = -1;
			}
			with (tackling) {
				s_set_anim(4);
			}
			s_set_anim(9);
		} else {
			if (id != ball.holder) {
				tackling.tacklecount += strength;
			}
			if (position == 12 || position == 13) {
				tackling.speed *= 0.9;
				if (x < tackling.x) {
					tackling.x += 0.05;
				} else {
					tackling.x += -0.05;
				}
			} else if (position != 6 && position != 5) {
				if (y < tackling.y) {
					tackling.vspeed = 0.1;
				} else {
					tackling.vspeed = -0.1;
				}
			} else if (x < tackling.x) {
				tackling.x += 0.025 * strength;
			} else {
				tackling.x += -0.025 * strength;
			}
			if (tackling.position == 4 && ball.holder != tackling) {
				return;
			}
			if (tackling.position == 1 && !s_is_kickoff(true) || tackling.tacklecount > tackling.strength * tackling.my_tackle_limit) {
				with (tackling) {
					var d = jdir + 180;
					hspeed = dcos(d) * 1.5;
					vspeed = dsin(d) * 1.5;
					s_set_anim(4);
				}
				if (pmap && !done_tackle) {
					var dotacklestat = false;
					switch (ds_map_find_value(pmap, "position")) {
						case 5:
						case 3:
							switch (cont.drivedir) {
								case -1:
									if (ball.x > cont.x_scrim - 5) {
										dotacklestat = true;
									}
									break;
								case 1:
									if (ball.x < cont.x_scrim + 5) {
										dotacklestat = true;
									}
									break;
							}
							break;
						case 4:
							if (ball.state == 5) {
								switch (cont.drivedir) {
									case -1:
										if (ball.x < cont.x_scrim) {
											dotacklestat = true;
										}
										break;
									case 1:
										if (ball.x > cont.x_scrim) {
											dotacklestat = true;
										}
										break;
								}
							}
							break;
						case 10:
						case 1:
							break;
						default:
							dotacklestat = true;
							break;
					}
					if (dotacklestat) {
						ds_map_set_post(pmap, "stat_tackles", ds_map_find_value(pmap, "stat_tackles") + 1);
						done_tackle = true;
					}
				}
				s_set_anim(2);
			}
		}
	}
}

