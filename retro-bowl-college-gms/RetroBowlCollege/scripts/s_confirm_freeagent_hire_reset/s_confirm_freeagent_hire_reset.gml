function s_confirm_freeagent_hire_reset() {
	with (obj_master) {
		s_msg_clear();
		freeagent_reset_week = week;
		coach_credit -= 5;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - 5, 0));
		obj_master.fa_page = 1;
		s_clear_storelist();
		room_goto(rm_freeagents2);
	}
}

