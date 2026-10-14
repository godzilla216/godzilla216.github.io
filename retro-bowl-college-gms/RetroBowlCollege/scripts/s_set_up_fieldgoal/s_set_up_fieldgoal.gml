function s_set_up_fieldgoal(_arg0) {
	show_debug_message("s_set_up_fieldgoal");
	if (obj_master.qb_mode) {
		if (_arg0 == 2) {
			s_action_result(11);
		} else {
			s_action_result(10);
		}
		return;
	}
	playstart_time = current_time;
	global.replay_do = false;
	with (obj_controller) {
		alarm[0] = 0;
		s_reset_wind();
		kicking = _arg0;
		scored_by = -1;
		if (kicking == 2) {
			scrimmage = 47;
		}
		x_scrim = 1300 + scrimmage * 20 * drivedir;
		x_yards = x_scrim + yards * 20 * drivedir;
		y_scrim = 300;
		kicks++;
		if (snaps > 0) {
			snaps--;
		}
		if (kicking != 2 && !obj_master.gamepractice) {
			y_scrim = 276;
			if (y_down > 300) {
				y_scrim = 332;
			}
		}
		kick_dist = x_scrim - 90;
		if (drivedir == 1) {
			kick_dist = 2510 - x_scrim;
		}
		kick_dist = 4 + floor(kick_dist / 20);
		s_destroy_match_objects();
		for (var o = 1; o < 12; o++) {
			instance_create_layer(0, 0, "Players", obj_playerOF);
			if (obj_master.gamepractice == 1 && o == 2) {
				break;
			}
		}
		if (obj_master.gamepractice != 1) {
			for (var d = 1; d < 12; d++) {
				instance_create_layer(0, 0, "Players", obj_playerDF);
			}
		}
		with (obj_player) {
			s_set_skills_and_skin();
		}
		global.master_ball = instance_create_layer(0, 0, "Ball", obj_ball);
		instance_create_layer(0, 0, "Ball", obj_metaball);
		if (obj_master.gamepractice == 1) {
			state = 1;
			comm_stage = 14;
			comm_txt = "";
			comm_proceed = false;
			tap_msg = s_str("training_Kick1");
			if (os_type == 0 || os_type == 1) {
				tap_msg = s_str("training_Kick1b");
			}
			if (global.gamepad) {
				comm_proceed = true;
			}
		}
	}
	var showChangeMind = (obj_controller.down == 4 || obj_controller.kicking == 2) && s_count_timeouts();
	if (obj_controller.college_overtime && obj_controller.college_overtime_round <= 2 && s_count_timeouts() && obj_controller.kicking == 1) {
		showChangeMind = true;
	}
	if (showChangeMind) {
		var bx = display_get_gui_width() - 8 - sprite_get_width(spr_audible);
		var by = 68;
		if (obj_controller.drivedir == -1) {
			bx = 8;
		}
		var obj_btn_g4i = instance_create_layer(bx, by, "Text", obj_btn_goforit);
		obj_btn_g4i.gp_mapped_button = 32772;
		obj_btn_g4i.gp_mapped_hidden = 32774;
		if (obj_controller.kicking == 2) {
			obj_btn_g4i.txt = s_str("btn_GoFor2");
		}
	}
}

