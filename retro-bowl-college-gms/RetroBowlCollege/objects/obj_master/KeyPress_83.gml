if (!global.debug) {
	exit;
}
with (obj_input_box) {
	exit;
}
if (current_room == rm_home && !instance_exists(obj_msgbg) && !instance_exists(obj_input_box)) {
	if (keyboard_check(17)) {
		if (s_is_co_mode()) {
			s_skip_to_week(s_get_skip_to_week());
		} else {
			s_skip_to_week(18);
		}
		s_competitions_status_update();
		s_update_human_fixtures();
	} else if (s_is_co_mode()) {
		obj_master.stage = -11;
		room_goto(rm_home);
	} else {
		s_start_new_season(false);
	}
	exit;
}
