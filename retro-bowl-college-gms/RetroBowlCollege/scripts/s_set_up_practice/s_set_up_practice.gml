function s_set_up_practice() {
	slog("s_set_up_practice");
	with (obj_controller) {
		alarm[0] = 0;
	}
	with (obj_match_msg) {
		instance_destroy();
	}
	practice_count++;
	if (practice_success == -1) {
		if (obj_master.intro < 99) {
			switch (obj_master.gamepractice) {
				case 3:
					obj_master.gamepractice = 2;
					practice_count = 1;
					practice_success = 0;
					break;
				case 2:
					obj_master.gamepractice = 1;
					practice_count = 1;
					practice_success = 0;
					break;
				case 1:
					room_goto(rm_home);
					return;
					break;
			}
		}
	}
	if (obj_master.gamepractice == 4 && practice_count > 1 && seconds < 1) {
		s_end_qb_mode_practice();
		return;
	}
	state = 2;
	var msg_ext = "";
	if (global.browser && os_type != 4 && os_type != 3) {
		msg_ext = "Browser";
	} else if (global.gamepad) {
		msg_ext = "Gamepad";
	}
	switch (obj_master.gamepractice) {
		case 1:
			var msg = s_str("msg_Intro_Kicking" + msg_ext);
			if (practice_count == 1) {
				s_create_message("", msg, "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else if (practice_success == practice_count - 1) {
				s_create_message("", s_str("msg_Intro_SuccessKick"), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else {
				s_create_message("", s_str("msg_Intro_KickingFail" + msg_ext), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			}
			scrimmage = 30;
			if (practice_success == 0) {
				scrimmage = 40;
			}
			drivedir = -1;
			if (ds_map_find_value(obj_master.map_options, "op_drivedir") != 0) {
				drivedir = ds_map_find_value(obj_master.map_options, "op_drivedir");
			}
			s_set_up_fieldgoal(1);
			break;
		case 2:
			var msg = s_str("msg_Intro_Running" + msg_ext);
			scrimmage = 0;
			drivedir = -1;
			if (ds_map_find_value(obj_master.map_options, "op_drivedir") != 0) {
				drivedir = ds_map_find_value(obj_master.map_options, "op_drivedir");
			}
			if (practice_count == 1) {
				s_create_message("", msg, "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else if (practice_success == practice_count - 1) {
				s_create_message("", s_str("msg_Intro_SuccessRun" + msg_ext), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else if (practice_success == 0) {
				s_create_message("", s_str("msg_Intro_RunningFail" + msg_ext), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else {
				s_create_message("", s_str("msg_Intro_ScrambleFail" + msg_ext), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			}
			if (practice_success > 0) {
				s_practice_running_qb();
			} else {
				s_practice_running();
			}
			break;
		case 3:
			if (practice_count == 1) {
				s_create_message("", s_str("msg_Intro_Passing" + msg_ext), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else if (practice_success == practice_count - 1) {
				s_create_message("", s_str("msg_Intro_SuccessPass"), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			} else {
				s_create_message("", s_str("msg_Intro_PassingFail" + msg_ext), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			}
			scrimmage = 0;
			drivedir = -1;
			if (ds_map_find_value(obj_master.map_options, "op_drivedir") != 0) {
				drivedir = ds_map_find_value(obj_master.map_options, "op_drivedir");
			}
			s_practice_passing();
			break;
		case 4:
			if (practice_count == 1) {
				s_create_message("", s_str("msg_QB_Training"), "", s_str("ui_Continue"), "", s_msg_clear, global.c_background, 0.7);
			}
			scrimmage = 0;
			drivedir = -1;
			minutes = 0;
			if (practice_count == 1) {
				seconds = 30;
			}
			if (ds_map_find_value(obj_master.map_options, "op_drivedir") != 0) {
				drivedir = ds_map_find_value(obj_master.map_options, "op_drivedir");
			}
			s_practice_qb_mode();
			break;
	}
}

