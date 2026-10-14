function s_meter_change_end() {
	if (s_get_morale() >= 100) {
		s_complete_achievement("ACH_MORALE100");
	}
	with (obj_msgbg) {
		if (new_room) {
			slog("s_meter_change_end 1 [new_room]");
			room_goto(new_room);
		} else if (obj_master.stage == 2) {
			slog("s_meter_change_end 2 [STAGE_DRAFT]");
			if (s_dilemma_college_check_chained() == false) {
				room_goto(rm_home);
				s_msg_clear();
			}
		} else {
			slog("s_meter_change_end 3 [Other]");
			if (s_dilemma_college_check_chained() == false) {
				s_play(1);
				s_msg_clear();
			}
		}
	}
}

