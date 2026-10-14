function s_set_up_play(_arg0) {
	show_debug_message("s_set_up_play: difficulty = " + string(5 + obj_controller.difficulty));
	if (global.exhibition) {
		s_force_kick_direction();
	}
	_poki_gameplay_start();
	with (obj_controller) {
		slog_roster("setup_play", 0);
		slog_roster("setup_play", 1);
		team_roster[0] = s_sort_players(team_roster[0], 4);
		team_roster[1] = s_sort_players(team_roster[1], 4);
	}
	global.replay_do = false;
	playstart_time = current_time;
	timeout_called = false;
	kicking = 0;
	running_play = false;
	scorer = "";
	scored_by = -1;
	drop_happened = false;
	cheer_frame = 0;
	dist_td = 0;
	if (quarter == 5) {
		had_ot_possession[possession] = 1;
		slog("had_ot_possession[" + string(possession) + "] = 1");
	}
	switch (down) {
		case 99:
			s_set_up_kickoff();
			if (!global.exhibition) {
				if (obj_master.tag_kr_message_done > 0 && obj_master.tag_kr_message_done < 3) {
					obj_master.tag_kr_message_done = 3;
					s_create_message("", s_str("msg_TouchBack"), s_str("ui_Continue"), "", s_msg_clear, "", 16777215, 0.7);
				}
			}
			return;
		case 4:
			if (obj_controller.minutes <= 0 && obj_controller.seconds <= 0) {
				s_action_result(9);
				return;
			} else if (!_arg0) {
				if (scrimmage < -2) {
					if (obj_controller.quarter == 5 && s_both_teams_had_possession() && obj_controller.team_score[0] != obj_controller.team_score[1]) {
						break;
					} else {
						s_create_message("", s_str("matchmsg_PlayPunt"), s_str("down_4"), s_str("Punt"), btn_response_kick_no, btn_response_punt_yes, 16777215, 0.7);
					}
				} else {
					var str_down = s_str("down_" + string(down));
					var msg = string_replace(s_str("matchmsg_PlayFG"), "$down", str_down);
					s_create_message("", msg, str_down, s_str("Field Goal"), btn_response_kick_no, btn_response_fg_yes, 16777215, 0.7);
				}
			}
			break;
		case 5:
			s_action_result(4);
			return;
			break;
		case 6:
			yards = 3;
			scrimmage = 47;
			break;
		case 7:
			s_action_result(4);
			return;
			break;
		default:
			if (s_college_overtime_offer_kick()) {
				slog("Offer C.OT Field Goal");
				var str_down = s_str("down_" + string(down));
				var msg = string_replace(s_str("matchmsg_PlayFG"), "$down", s_str("down_" + string(down)));
				s_create_message("", msg, str_down, s_str("Field Goal"), btn_response_kick_no, btn_response_fg_yes, 16777215, 0.7);
			} else if (obj_controller.minutes <= 0 && obj_controller.seconds <= 0) {
				s_action_result(9);
				return;
			} else if (!_arg0 && scrimmage >= -2 && s_last_secs_of_half(20)) {
				var str_down = s_str("down_" + string(down));
				var msg = s_str("matchmsg_PlayFG");
				msg = string_replace(msg, "$down", str_down);
				slog("Offer Field Goal");
				s_create_message("", msg, str_down, s_str("Field Goal"), btn_response_kick_no, btn_response_fg_yes, 16777215, 0.7);
			} else if (!global.exhibition && obj_master.year > 1 && !obj_master.gamepractice && !obj_master.timeout_message_done) {
				var msg = "msg_Audibles";
				if (global.browser) {
					msg = "msg_AudiblesHtml";
				}
				if (obj_master.qb_mode) {
					msg = "msg_AudiblesQB";
				}
				s_create_message("", s_str(msg), s_str("ui_Continue"), "", s_msg_timeouts, "", 16777215, 0.7);
			} else if (!global.exhibition && obj_master.year > 1 && obj_master.week > 1 && !obj_master.gamepractice && !obj_master.bullet_throw_message_done) {
				var msg = "msg_BulletThrow";
				if (global.gamepad) {
					msg = "msg_BulletThrowGamepad";
				} else if (!global.mobile_device) {
					msg = "msg_BulletThrowHtml";
				}
				obj_master.bullet_throw_message_done = 1;
				s_create_message("", s_str(msg), s_str("ui_Continue"), "", s_msg_clear, "", 16777215, 0.7);
			}
			break;
	}
	show_debug_message("Down = " + string(down));
	show_debug_message("Scrimmage = " + string(scrimmage));
	x_scrim = 1300 + scrimmage * 20 * drivedir;
	x_yards = x_scrim + yards * 20 * drivedir;
	y_scrim = 276;
	if (y_down > 300) {
		y_scrim = 332;
	}
	if (down == 6) {
		y_scrim = 300;
	}
	s_choose_defensive_formation();
	snaps++;
	s_destroy_match_objects();
	slog("Create players");
	for (var o = 0; o < 11; o++) {
		instance_create_layer(0, 0, "Players", obj_playerOF);
	}
	for (var d = 0; d < 11; d++) {
		instance_create_layer(0, 0, "Players", obj_playerDF);
	}
	with (obj_player) {
		s_set_skills_and_skin();
	}
	if (obj_master.qb_mode && obj_controller.down < 5) {
		s_set_rewarded_route();
	}
	slog("Create ball");
	global.master_ball = instance_create_layer(0, 0, "Ball", obj_ball);
	instance_create_layer(0, 0, "Ball", obj_metaball);
	slog("instance_number(obj_ball) == " + string(instance_number(obj_ball)));
	obj_controller.control_alpha = 5;
	var auds = s_count_audibles();
	if (auds) {
		var bx = 32;
		var by = 48;
		if (drivedir == -1) {
			bx = display_get_gui_width() - 32 - sprite_get_width(spr_audible);
		}
		slog("Create audible button: " + string(auds));
		var btn_aud = instance_create_layer(bx, by, "Text", obj_btn_audible);
		btn_aud.gp_mapped_button = global.gp_timeout;
	}
	if ((down == 4 || down == 6) && s_count_timeouts()) {
		var bx = display_get_gui_width() - 32 - sprite_get_width(spr_audible);
		var by = 48;
		if (drivedir == -1) {
			bx = 32;
		}
		var obj_btn_fg = instance_create_layer(bx, by, "Text", obj_btn_fieldgoal);
		obj_btn_fg.gp_mapped_button = 32772;
		obj_btn_fg.gp_mapped_hidden = 32774;
		if (down == 6) {
			obj_btn_fg.txt = s_str("btn_GoFor1");
			obj_btn_fg.onClickAction = btn_match_gofor1pt;
		}
		slog("Kick button offer: [" + obj_btn_fg.txt + "]");
	}
}

function s_btn_audible_reposition() {
	if (obj_controller.drivedir == -1) {
		x = display_get_gui_width() - 32 - sprite_get_width(spr_audible);
	} else {
		x = 32;
	}
}

function s_btn_fieldgoal_reposition() {
	if (obj_controller.drivedir == -1) {
		x = 32;
	} else {
		x = display_get_gui_width() - 32 - sprite_get_width(spr_audible);
	}
}

