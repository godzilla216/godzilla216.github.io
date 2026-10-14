function s_obj_controller_step() {
	global.replay_tick++;
	if (current_time > fps_timer + 100) {
		fps_timer = current_time;
		myfps += g_pBuiltIn.fps_real;
		myfps = round(myfps / 2);
	}
	control_alpha -= 0.01;
	if (global.gamepad && gamepad_button_check(global.gp.slot, global.gp_select)) {
		control_alpha = 5;
	}
	if (scored_by == 1) {
		cheer_frame += 0.05;
	} else {
		cheer_frame = 0;
	}
	switch (state) {
		case 1:
			var inp = false;
			with (global.master_ball) {
				if (velocity) {
					inp = true;
				}
			}
			if (s_is_touch_allowed() && mouse_check_button_released(1) || keyboard_check_pressed(38) || keyboard_check_pressed(40)) {
				inp = true;
			}
			if (instance_exists(obj_btn_kickoff)) {
				inp = false;
			} else if (global.gamepad && gamepad_button_check_released(global.gp.slot, global.gp_select)) {
				inp = true;
			}
			if (inp || comm_proceed) {
				s_clear_clock();
				s_update_commentary();
			}
			s_update_game_clock();
			s_pause_step();
			return;
			break;
		case 2:
			if (instance_number(obj_ball) == 0) {
				slog("obj_controller:STATE_ACTION");
				slog_roster("controller step", 0);
				slog_roster("controller step", 1);
				s_set_up_play(false);
				s_create_head2head_message();
			}
			s_update_game_timer();
			if (os_type != 21) {
				s_update_manual_gestures();
			}
			if (global.debug) {
				s_check_ingame_control_change();
			}
			break;
		case 3:
			s_replay_controls();
			s_pause_step();
			return;
			break;
	}
	with (global.master_ball) {
		if (is_dead && other.alarm[0] <= 0) {
			other.alarm[0] = 100;
			if (state == 6 || state == 4) {
				other.alarm[0] = 200;
			}
		}
	}
	s_pause_step();
}

