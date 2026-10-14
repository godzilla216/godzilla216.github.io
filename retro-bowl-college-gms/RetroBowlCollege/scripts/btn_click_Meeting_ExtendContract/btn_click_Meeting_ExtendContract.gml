function btn_click_Meeting_ExtendContract() {
	var name = ds_map_find_value(obj_master.player_profile, "fname") + " " + ds_map_find_value(obj_master.player_profile, "lname");
	var meetcost = s_get_meeting_cost_extend_contract(obj_master.player_profile);
	if (obj_meeting_player.retirement) {
		meetcost = max(s_get_meeting_cost_extend_contract(obj_master.player_profile), s_get_meeting_cost_delay_retirement(obj_master.player_profile));
	}
	if (s_is_co_mode()) {
		meetcost = s_get_meeting_cost_extend_contract(obj_master.player_profile);
	}
	if (meetcost > obj_master.coach_credit) {
		var msg = s_str("msg_MeetingNoCredit");
		msg = string_replace(msg, "$playername", name);
		msg = string_replace(msg, "$num", string(meetcost));
		s_create_message(s_str("ui_Meeting"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		return;
	}
	if (s_is_co_mode()) {
		if (ds_map_find_value(obj_master.player_profile, "percent_grade") >= 95) {
			var msg = s_str("msg_MeetingGPANotNeeded");
			msg = string_replace(msg, "$playername", name);
			s_create_message(s_str("ui_Meeting"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		} else {
			var msg = s_str("msg_MeetingExtendContract");
			msg = string_replace(msg, "$playername", name);
			msg = string_replace(msg, "$num", string(meetcost));
			s_create_message(s_str("ui_Meeting"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_player_meeting_academic_coaching, global.c_background, 1);
			return;
		}
	}
	if (ds_map_find_value(obj_master.player_profile, "attitude") <= 45) {
		var msg = s_str("msg_CannotSignMoraleLow");
		msg = string_replace(msg, "$playername", name);
		s_create_message(s_str("ui_Meeting"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		return;
	}
	switch (obj_meeting_player.retirement) {
		case false:
			var msg = s_str("msg_MeetingExtendContract");
			msg = string_replace(msg, "$playername", name);
			msg = string_replace(msg, "$num", string(meetcost));
			s_create_message(s_str("ui_Meeting"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_player_meeting_extend_contract, global.c_background, 1);
			break;
		case true:
			if (ds_map_find_value(obj_master.player_profile, "age") >= s_get_max_age(obj_master.player_profile) + 5) {
				var msg = s_str("msg_MeetingTooOld");
				msg = string_replace(msg, "$playername", name);
				s_create_message(s_str("ui_Meeting"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			} else {
				var msg = s_str("msg_MeetingDelayRetirement");
				msg = string_replace(msg, "$playername", name);
				msg = string_replace(msg, "$num", string(meetcost));
				s_create_message(s_str("ui_Meeting"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_player_meeting_extend_contract, global.c_background, 1);
			}
			break;
	}
}

