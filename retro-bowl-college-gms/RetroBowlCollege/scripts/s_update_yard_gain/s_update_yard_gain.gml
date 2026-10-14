function s_update_yard_gain() {
	s_update_xdead();
	var gain = 0;
	var bx = clamp(xdead, 300, 2300);
	var ball = global.master_ball;
	if (ball.holder && !ball.holder.offense) {
		return;
	}
	switch (obj_controller.drivedir) {
		case -1:
			gain = (obj_controller.x_scrim - bx) / 20;
			break;
		case 1:
			gain = (bx - obj_controller.x_scrim) / 20;
			break;
	}
	if (!obj_master.gamepractice && ball.holder && ball.holder.pmap && s_is_kickoff(true)) {
		slog("Check return record gain = " + string(gain));
		ds_map_set(ball.holder.pmap, "stat_return_attempts", ds_map_find_value(ball.holder.pmap, "stat_return_attempts") + 1);
		if (gain > 0) {
			ds_map_set(ball.holder.pmap, "stat_return_yards", ds_map_find_value(ball.holder.pmap, "stat_return_yards") + gain);
			if (gain > ds_map_find_value(ball.holder.pmap, "stat_return_longest")) {
				ds_map_set(holder.pmap, "stat_return_longest", gain);
			}
			s_check_record("ui_LongKickReturn", gain, "", s_get_holder_name(), s_get_opponent_team_tla());
			if (!s_simming_action()) {
				if (gain >= 25) {
					s_complete_achievement("ACH_RETURN_25");
				}
				if (gain >= 50) {
					s_complete_achievement("ACH_RETURN_50");
				}
				if (gain >= 75) {
					s_complete_achievement("ACH_RETURN_75");
				}
			}
			if (ball.state == 6) {
				ds_map_set(ball.holder.pmap, "stat_return_tds", ds_map_find_value(ball.holder.pmap, "stat_return_tds") + 1);
				if (!s_simming_action()) {
					s_complete_achievement("ACH_RETURN_TD");
				}
			}
			if (gain > 25) {
				global.replay_do = true;
			}
		}
		return;
	}
	var qb = s_get_quarterback();
	if (!obj_master.gamepractice && holder && obj_controller.down < 5) {
		switch (holder.position) {
			case 1:
			case 3:
			case 2:
			case 4:
				if (obj_controller.running_play) {
					slog(">>> RUNNING_PLAY");
					if (holder.pmap) {
						if (state != 11) {
							ds_map_set(holder.pmap, "stat_rush_attempts", ds_map_find_value(holder.pmap, "stat_rush_attempts") + 1);
						}
						if (gain > 0 || holder.position != 1) {
							ds_map_set(holder.pmap, "stat_rush_yards", ds_map_find_value(holder.pmap, "stat_rush_yards") + gain);
						}
						if (gain > ds_map_find_value(holder.pmap, "stat_rush_longest")) {
							ds_map_set(holder.pmap, "stat_rush_longest", gain);
						}
						if (ball.state == 6) {
							ds_map_set(holder.pmap, "stat_rush_touchdowns", ds_map_find_value(holder.pmap, "stat_rush_touchdowns") + 1);
							if (ds_map_find_value(holder.pmap, "position") == 1 && !s_simming_action()) {
								s_complete_achievement("ACH_TD_QB");
							}
						}
					} else if (ball.state == 6 && holder.position == 1 && !s_simming_action()) {
						s_complete_achievement("ACH_TD_QB");
					}
					if (!s_simming_action()) {
						if (gain > 15) {
							s_complete_achievement("ACH_RUN15");
						} else if (gain > 10) {
							s_complete_achievement("ACH_RUN10");
						} else if (gain > 5) {
							s_complete_achievement("ACH_RUN5");
						}
					}
					if (gain > 15) {
						global.replay_do = true;
					}
					s_check_record("ui_LongRushingPlay", gain, s_get_qb_name(), s_get_holder_name(), s_get_opponent_team_tla());
					if (ball.state == 6 && obj_controller.down < 6) {
						s_check_record("ui_LongRushTD", gain, s_get_qb_name(), s_get_holder_name(), s_get_opponent_team_tla());
						obj_controller.dist_td = round(gain);
					}
				} else {
					if (holder.pmap) {
						ds_map_set(holder.pmap, "stat_attempts", ds_map_find_value(holder.pmap, "stat_attempts") + 1);
						ds_map_set(holder.pmap, "stat_yards", ds_map_find_value(holder.pmap, "stat_yards") + gain);
						if (gain > ds_map_find_value(holder.pmap, "stat_longest")) {
							ds_map_set(holder.pmap, "stat_longest", gain);
						}
						if (ball.state == 6 && obj_controller.down < 6) {
							ds_map_set(holder.pmap, "stat_touchdowns", ds_map_find_value(holder.pmap, "stat_touchdowns") + 1);
						}
					}
					if (qb && qb.pmap) {
						ds_map_set(qb.pmap, "stat_yards", ds_map_find_value(qb.pmap, "stat_yards") + gain);
						if (gain > ds_map_find_value(qb.pmap, "stat_longest")) {
							ds_map_set(qb.pmap, "stat_longest", gain);
						}
						if (ball.state == 6 && obj_controller.down < 6) {
							ds_map_set(qb.pmap, "stat_touchdowns", ds_map_find_value(qb.pmap, "stat_touchdowns") + 1);
						}
					}
					if (!s_is_kickoff(true) && !s_simming_action()) {
						if (gain > 50) {
							s_complete_achievement("ACH_PASS50");
						} else if (gain > 25) {
							s_complete_achievement("ACH_PASS25");
						} else if (gain > 10) {
							s_complete_achievement("ACH_PASS10");
						}
					}
					if (gain > 25) {
						global.replay_do = true;
					}
					s_check_record("ui_LongPassingPlay", gain, s_get_qb_name(), s_get_holder_name(), s_get_opponent_team_tla());
					if (ball.state == 6 && obj_controller.down < 6) {
						s_check_record("ui_LongPassTD", gain, s_get_qb_name(), s_get_holder_name(), s_get_opponent_team_tla());
						obj_controller.dist_td = round(gain);
					}
				}
				break;
			case 5:
			case 6:
			case 7:
			case 9:
			case 8:
			case 10:
				break;
		}
	}
	s_fieldtxt_yards(gain);
}

