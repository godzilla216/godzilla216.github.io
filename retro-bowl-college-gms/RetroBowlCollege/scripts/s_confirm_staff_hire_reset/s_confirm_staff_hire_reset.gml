function s_confirm_staff_hire_reset() {
	with (obj_master) {
		s_msg_clear();
		staff_reset_week = week;
		coach_credit -= 5;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - 5, 0));
		s_reset_staff_hire_list(true);
		room_goto(rm_viewhires);
		s_savegame();
	}
}

