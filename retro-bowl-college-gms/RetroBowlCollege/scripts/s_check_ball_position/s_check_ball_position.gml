function s_check_ball_position() {
	if (!s_is_ball_dead()) {
		var cont = obj_controller;
		var by = y;
		if (instance_exists(holder)) {
			by = holder.y;
		}
		if (cont.kicking == 1 || cont.kicking == 2) {
			if (bouncecount > 0 || y < 132 || y > 468) {
				state = 15;
			} else if (x < 100 || x > 2500) {
				var glx = 100;
				if (x > 1300) {
					glx = 2500;
				}
				var ipoint = s_lines_intersect(last_x, last_y, x, y, glx, 270, glx, 336);
				slog("intercept = " + string(ipoint.intercept));
				var tempx = x;
				var txtx = x - 80;
				if (cont.drivedir == -1) {
					txtx = x + 80;
				}
				if (ipoint.intercept) {
					if (height < 60) {
						x = txtx;
						s_fieldtxt(s_str("match_TooLow") + "!");
						x = tempx;
						if (!obj_master.gamepractice) {
							s_sound_audience_dis();
						}
						state = 15;
						return;
					} else if (height < 140) {
						if (ipoint.intercept_CD < 0.1 || ipoint.intercept_CD > 0.9) {
							global.replay_do = true;
							x = txtx;
							s_fieldtxt(s_str("match_Doink") + "!");
							x = tempx;
							s_sound_post();
							if (!obj_master.gamepractice) {
								s_sound_audience_dis();
							}
							state = 15;
							direc += 180 + irandom_range(-35, 35);
							velocity *= 0.1;
							roll *= 2;
							x = last_x;
							y = last_y;
							return;
						} else if (ipoint.intercept_CD < 0.2 || ipoint.intercept_CD > 0.8) {
							global.replay_do = true;
							x = txtx;
							s_fieldtxt(s_str("match_Doink") + "!");
							x = tempx;
							s_complete_achievement("ACH_DOINK");
							s_sound_post();
							with (obj_weather) {
								wind_force = 0;
							}
							var ay = 468;
							if (y < 300) {
								ay = 132;
							}
							slog(string(direc));
							switch (cont.drivedir) {
								case -1:
									direc = point_direction(x, y, glx - 210, ay);
									break;
								case 1:
									direc = point_direction(x, y, glx + 210, ay);
									break;
							}
							slog(string(direc));
							direc += irandom_range(-5, 5);
							velocity *= 0.25;
							roll *= 2;
							x = last_x;
							y = last_y;
						}
					}
					if (!obj_master.gamepractice) {
						s_sound_audience_fg();
						var kicker = s_get_kicker();
						switch (cont.kicking) {
							case 1:
								if (kicker && kicker.pmap) {
									ds_map_set(kicker.pmap, "stat_complete", ds_map_find_value(kicker.pmap, "stat_complete") + 1);
									ds_map_set(kicker.pmap, "stat_yards", ds_map_find_value(kicker.pmap, "stat_yards") + cont.kick_dist);
									if (cont.kick_dist > ds_map_find_value(kicker.pmap, "stat_longest")) {
										ds_map_set(kicker.pmap, "stat_longest", cont.kick_dist);
									}
								}
								s_complete_achievement("ACH_FIELDGOAL");
								if (cont.kick_dist >= 25) {
									s_complete_achievement("ACH_FIELDGOAL25");
								}
								if (cont.kick_dist >= 50) {
									s_complete_achievement("ACH_FIELDGOAL50");
								}
								if (cont.kick_dist >= 60) {
									s_complete_achievement("ACH_FIELDGOAL60");
								}
								s_check_record("ui_LongFG", cont.kick_dist, s_get_kicker_name(), "", s_get_opponent_team_tla());
								if (!s_simming_action()) {
									s_sound_brass_loop(1);
								}
								break;
							case 2:
								if (kicker && kicker.pmap) {
									ds_map_set(kicker.pmap, "stat_complete_XP", ds_map_find_value(kicker.pmap, "stat_complete_XP") + 1);
								}
								s_complete_achievement("ACH_POINTAFTER1");
								if (!s_simming_action()) {
									s_sound_brass_loop(1);
								}
								break;
						}
					}
					if (cont.kick_dist >= 40) {
						global.replay_do = true;
					}
					obj_controller.scored_by = obj_controller.possession;
					state = 14;
					xdead = ipoint.px;
					ydead = ipoint.py;
					return;
				}
				if (!obj_master.gamepractice) {
					s_sound_audience_dis();
				}
				state = 15;
			}
		} else if (s_is_kickoff(false)) {
			if (by < 132 || by > 468) {
				if (x > 300 && x < 2300) {
					state = 8;
					ydead = round(y);
					xdead = round(x);
					cont.y_down = by;
				} else {
					slog("BALL_TOUCHBACK 1");
					state = 20;
					ydead = round(y);
					xdead = round(x);
					cont.y_down = by;
				}
			} else if (x < 100 || x > 2500) {
				slog("BALL_TOUCHBACK 2");
				state = 20;
				ydead = round(y);
				xdead = round(x);
				cont.y_down = by;
			}
		} else if ((x < 300 || x > 2300) && holder && holder.goaldist > 1000 && (by < 132 || by > 468 || x < 100 || x > 2500)) {
			if (s_can_touchback()) {
				slog("BALL_TOUCHBACK 3");
				state = 20;
			} else {
				state = 12;
			}
			ydead = round(y);
			xdead = round(x);
			cont.y_down = by;
		} else if (by < 132 || by > 468) {
			if ((cont.down < 5 || s_is_kickoff(true)) && (holder || state == 13)) {
				state = 8;
				cont.y_down = by;
				s_update_yard_gain();
			} else {
				state = 7;
				s_sound_audience_inc();
			}
		} else if (x < 100 || x > 2500) {
			state = 7;
			s_sound_audience_inc();
		} else if (holder) {
			if (cont.drivedir == -1 && x > 1300 && obj_master.gamepractice == 2) {
				state = 17;
			} else if (cont.drivedir == 1 && x < 1300 && obj_master.gamepractice == 2) {
				state = 17;
			} else if (x > 2300 && holder.facing == 1 || x < 300 && holder.facing == -1) {
				state = 6;
				cont.y_down = by;
				cont.td_time = current_time;
				if (obj_master.gamepractice == 2) {
					if (obj_controller.practice_success == 0) {
						cont.tap_msg = "";
						state = 16;
					} else {
						cont.tap_msg = "";
						state = 17;
					}
				} else if (holder.offense) {
					obj_controller.scored_by = obj_controller.possession;
					if (cont.down < 6 || cont.down == 99) {
						cont.scorer = holder.pos_name2;
						s_complete_achievement("ACH_TOUCHDOWN1");
						cont.touchdowns++;
						if (cont.touchdowns == 3) {
							s_complete_achievement("ACH_TOUCHDOWN3");
						}
						if (cont.touchdowns == 5) {
							s_complete_achievement("ACH_TOUCHDOWN5");
						}
						var count = s_count_achievement("ACH_TOUCHDOWN1");
						if (count >= 50) {
							s_complete_achievement("ACH_CAREER_TD50");
						}
						if (count >= 100) {
							s_complete_achievement("ACH_CAREER_TD100");
						}
						if (count >= 250) {
							s_complete_achievement("ACH_CAREER_TD250");
						}
						if (count >= 500) {
							s_complete_achievement("ACH_CAREER_TD500");
						}
					} else {
						cont.scorer = holder.pos_name2;
						s_complete_achievement("ACH_POINTAFTER2");
					}
					s_update_yard_gain();
					s_sound_audience_fg();
					if (!s_simming_action()) {
						s_sound_brass_loop(1);
					}
				} else {
					obj_controller.scored_by = !obj_controller.possession;
					s_sound_audience_fg();
				}
				if (holder) {
					with (obj_player) {
						if (other.holder.id != id && other.holder.offense == offense) {
							if (anim == 2 || anim == 0 || anim == 1) {
								s_set_anim(17);
							}
						}
					}
				}
			} else if (height < 1) {
				s_set_ball_down();
			}
		} else if (bouncecount > 0 && state == 3) {
			state = 7;
			s_sound_audience_inc();
			switch (obj_master.gamepractice) {
				case 1:
					break;
				case 2:
					break;
				case 3:
				case 4:
					state = 17;
					obj_controller.practice_chain_qb_mode = 0;
					s_sound(snd_error);
					break;
			}
		}
		if (s_is_ball_dead()) {
			s_update_xdead();
		}
	}
}

