function s_action_result(_arg0) {
	s_destroy_match_objects();
	slog("s_action_result: " + s_get_string_action_result(_arg0));
	with (obj_controller) {
		scorer = "";
		switch (_arg0) {
			case 1:
				slog("quarter=" + string(quarter));
				slog("drives=" + string(drives));
				var is2PointConv = down >= 6;
				if (college_overtime) {
					if (is2PointConv) {
						slog("ACTION_RESULT_TOUCHDOWN (college_overtime - 2pconv)");
						team_score[possession] += 2;
						s_college_overtime_handle_play_end();
						state = 1;
						comm_proceed = true;
						return;
					} else {
						slog("ACTION_RESULT_TOUCHDOWN (college_overtime - touchdown)");
						team_score[possession] += 6;
						s_college_overtime_trigger_point_conversion();
						state = 1;
						comm_proceed = true;
						return;
					}
					break;
				} else if (quarter == 5 && down < 6 && team_score[possession] + 6 > team_score[!possession ? 1 : 0] && s_both_teams_had_possession()) {
					team_score[possession] += 6;
					comm_stage = 17;
					break;
				} else if (down >= 6 && !s_is_kickoff(true)) {
					s_complete_achievement("ACH_POINTAFTER2");
					if (quarter == 5 && team_score[possession] + 2 > team_score[!possession ? 1 : 0] && s_both_teams_had_possession()) {
						team_score[possession] += 2;
						comm_stage = 17;
						break;
					} else {
						team_score[possession] += 2;
						comm_stage = 1;
						break;
					}
				} else {
					team_score[possession] += 6;
					down = 6;
					if (obj_master.qb_mode) {
						comm_stage = 10;
					} else {
						slog("Offer after touchdown [" + s_str("matchmsg_PATor2") + "]");
						s_create_message("", s_str("matchmsg_PATor2"), s_str("match_1pt"), s_str("match_2pt"), btn_response_1pt, btn_response_2pt, 16777215, 0.7);
						return;
					}
				}
				break;
			case 2:
				var is2PointConv = down >= 6;
				if (college_overtime) {
					if (is2PointConv) {
						team_score[!possession ? 1 : 0] += 2;
						s_college_overtime_handle_play_end();
						state = 1;
						comm_proceed = true;
						return;
					} else {
						s_change_possession();
						team_score[possession] += 6;
						s_college_overtime_trigger_point_conversion();
						state = 1;
						comm_proceed = true;
						return;
					}
					break;
				} else if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					s_change_possession();
					team_score[possession] += 6;
					comm_stage = 17;
				} else if (down >= 6) {
					team_score[!possession ? 1 : 0] += 2;
					comm_stage = 1;
				} else {
					s_change_possession();
					team_score[possession] += 6;
					down = 6;
					if (global.exhibition && obj_master.playerteamindex == -1) {
						s_create_message("", s_str("matchmsg_PATor2"), s_str("match_1pt"), s_str("match_2pt"), btn_response_1pt, btn_response_2pt, 16777215, 0.7);
						return;
					} else {
						comm_stage = 10;
					}
				}
				break;
			case 3:
			case 4:
				if (college_overtime) {
					s_college_overtime_handle_play_end();
				} else if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					comm_stage = 17;
				} else if (down >= 6) {
					slog("Missed 2pt attempt");
					if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
						comm_stage = 17;
					} else {
						comm_stage = 1;
					}
				} else {
					comm_stage = 22;
				}
				break;
			case 5:
				comm_stage = 5;
				break;
			case 6:
				if (obj_master.gamepractice == 1) {
					if (practice_success == 0) {
						practice_success = practice_count;
					} else {
						practice_success = -1;
					}
					s_set_up_practice();
					return;
				}
				s_change_wind();
				if (kicking == 2) {
					team_score[possession] += 1;
				} else {
					team_score[possession] += 3;
				}
				if (college_overtime) {
					s_college_overtime_handle_play_end();
					break;
				} else if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					if (drives > 1) {
						comm_stage = 17;
						slog("Overtime win 1");
					} else {
						comm_stage = 1;
					}
				} else {
					comm_stage = 1;
				}
				break;
			case 7:
				if (obj_master.gamepractice == 1) {
					s_set_up_practice();
					return;
				}
				if (college_overtime) {
					s_college_overtime_handle_play_end();
					break;
				} else if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					slog("Overtime win 4");
					comm_stage = 17;
				} else if (kicking == 2) {
					comm_stage = 1;
				} else {
					s_change_possession();
				}
				s_change_wind();
				break;
			case 8:
				if (college_overtime) {
					s_college_overtime_handle_play_end();
					break;
				} else if (quarter == 5 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
					comm_stage = 17;
					team_score[!possession ? 1 : 0] += 2;
				} else {
					comm_stage = 1;
					team_score[!possession ? 1 : 0] += 2;
				}
				break;
			case 9:
				comm_stage = 2;
				break;
			case 10:
				comm_stage = 6;
				break;
			case 11:
				comm_stage = 10;
				break;
		}
		state = 1;
		comm_proceed = true;
		if (_arg0 != 9) {
			down = 1;
		}
	}
}

