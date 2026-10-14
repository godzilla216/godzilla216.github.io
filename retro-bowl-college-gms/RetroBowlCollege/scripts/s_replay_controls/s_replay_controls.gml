function s_replay_controls() {
	if (global.gamepad && gamepad_button_check_released(global.gp.slot, global.gp_select) && !gamepad_button_check(global.gp.slot, global.gp_back)) {
		s_end_replay();
	} else {
		var sz = 0;
		with (global.master_ball) {
			sz = ds_list_size(my_replay);
		}
		if (sz < 1) {
			return;
		}
		if (global.gamepad) {
			var spd = 1;
			if (gamepad_button_check(global.gp.slot, global.gp_back)) {
				spd = 0.5;
			}
			if (global.gp.axisl_h > 0.2) {
				global.replay_frame += spd * 2 / 4;
				global.replay_frame = min(global.replay_frame, sz - 1);
			} else if (global.gp.axisl_h < -0.2) {
				global.replay_frame -= spd * 2 / 4;
			} else {
				global.replay_frame += spd / 4;
			}
		} else if (global.replay_drag_x > 15) {
			global.replay_frame += 0.5;
			global.replay_frame = min(global.replay_frame, sz - 1);
		} else if (global.replay_drag_x < -15) {
			global.replay_frame -= 0.5;
		} else if (mouse_check_button(1) && s_is_touch_allowed()) {
			global.replay_frame += 0.125;
		} else {
			global.replay_frame += 0.25;
		}
		with (obj_matchob) {
			s_replay_frame();
		}
	}
}

