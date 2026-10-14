function btn_click_Meeting_Morale() {
	var name = ds_map_find_value(obj_master.player_profile, "fname") + " " + ds_map_find_value(obj_master.player_profile, "lname");
	var msg = s_str("msg_MeetingMorale");
	var meetcost = s_get_meeting_cost_morale(obj_master.player_profile);
	if (ds_map_find_value(obj_master.player_profile, "attitude") >= 100) {
		msg = s_str("msg_MeetingMoraleNotNeeded");
		msg = string_replace(msg, "$playername", name);
		s_create_message(s_str("ui_Meeting"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else if (meetcost > obj_master.coach_credit) {
		msg = s_str("msg_MeetingNoCredit");
		msg = string_replace(msg, "$playername", name);
		msg = string_replace(msg, "$num", string(meetcost));
		s_create_message(s_str("ui_Meeting"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else {
		msg = string_replace(msg, "$playername", name);
		msg = string_replace(msg, "$num", string(meetcost));
		s_create_message(s_str("ui_Meeting"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_player_meeting_morale_yes, global.c_background, 1);
	}
}

