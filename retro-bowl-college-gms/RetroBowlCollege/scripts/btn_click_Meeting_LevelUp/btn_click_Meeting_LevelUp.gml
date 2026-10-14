function btn_click_Meeting_LevelUp() {
	var name = ds_map_find_value(obj_master.player_profile, "fname") + " " + ds_map_find_value(obj_master.player_profile, "lname");
	var i = string(1 + (obj_master.week + ds_map_find_value(obj_master.player_profile, "position")) mod 3);
	var msg = s_str("msg_MeetingLevelUp" + i);
	var meetcost = s_get_meeting_cost_levelup(obj_master.player_profile);
	if (s_player_at_max_potential(obj_master.player_profile)) {
		msg = s_str("msg_MeetingLevelUpNotNeeded");
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
		s_create_message(s_str("ui_Meeting"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_player_meeting_levelup_yes, global.c_background, 1);
	}
}

