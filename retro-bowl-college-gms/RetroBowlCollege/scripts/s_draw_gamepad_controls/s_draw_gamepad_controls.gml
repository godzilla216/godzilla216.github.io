function s_draw_gamepad_controls() {
	with (obj_match_msg) {
		return;
	}
	with (obj_msgbg) {
		return;
	}
	var dw = display_get_gui_width();
	var sx = drivedir == -1 ? dw - 78 : 78;
	var sy = drivedir == -1 ? 232 : 220;
	if (obj_controller.state == 3) {
		if (ds_map_find_value(obj_master.map_options, "op_gamepad_guides")) {
			draw_sprite_ext(os_type == 21 ? spr_controls_replay : spr_controls_replay_xbox, 0, sx, 236, 1, 1, 0, 16777215, 1);
		}
		return;
	}
	switch (obj_master.gamepractice) {
		case 4:
			break;
		case 3:
			with (global.master_ball) {
				if (state > 2) {
					return;
				}
			}
			draw_sprite_ext(os_type == 21 ? spr_controls_tut_1 : spr_controls_tut_1_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
			break;
		case 2:
			if (practice_success == 0) {
				with (global.master_ball) {
					switch (os_type) {
						case 21:
							draw_sprite_ext(state == 0 ? spr_controls_tut_2 : spr_controls_tut_2b, 0, sx, sy, 1, 1, 0, 16777215, 1);
							break;
						default:
							draw_sprite_ext(state == 0 ? spr_controls_tut_2_xbox : spr_controls_tut_2b_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
							break;
					}
				}
			} else {
				with (global.master_ball) {
					switch (state) {
						case 0:
							draw_sprite_ext(os_type == 21 ? spr_controls_tut_3 : spr_controls_tut_3_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
							break;
						case 2:
						case 1:
							draw_sprite_ext(os_type == 21 ? spr_controls_tut_3b : spr_controls_tut_3b_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
							break;
						default:
							draw_sprite_ext(os_type == 21 ? spr_controls_tut_3c : spr_controls_tut_3c_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
							break;
					}
				}
			}
			break;
		case 1:
			with (global.master_ball) {
				switch (os_type) {
					case 21:
						if (state <= 2) {
							draw_sprite_ext(state == 0 ? spr_controls_tut_4 : spr_controls_tut_4b, 0, sx, sy, 1, 1, 0, 16777215, 1);
						}
						break;
					default:
						if (state <= 2) {
							draw_sprite_ext(state == 0 ? spr_controls_tut_4_xbox : spr_controls_tut_4b_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
						}
						break;
				}
			}
			break;
		default:
			if (kicking) {
				return;
			}
			if (!ds_map_find_value(obj_master.map_options, "op_gamepad_guides")) {
				return;
			}
			with (global.master_ball) {
				switch (state) {
					case 0:
						draw_sprite_ext(os_type == 21 ? spr_controls_presnap : spr_controls_presnap_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
						break;
					case 2:
					case 1:
						draw_sprite_ext(os_type == 21 ? spr_controls_aim : spr_controls_aim_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
						break;
					case 5:
						if (s_is_kickoff(true) && s_can_touchback()) {
							draw_sprite_ext(spr_controls_touchback, 0, sx, sy, 1, 1, 0, 16777215, 1);
						} else {
							draw_sprite_ext(os_type == 21 ? spr_controls_run : spr_controls_run_xbox, 0, sx, sy, 1, 1, 0, 16777215, 1);
						}
						break;
				}
			}
			break;
	}
}

