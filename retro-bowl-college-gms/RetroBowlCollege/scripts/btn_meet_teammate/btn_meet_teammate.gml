function btn_meet_teammate() {
	with (obj_master) {
		var pmap = s_get_qb_pmap();
		var teammate = player_profile;
		if (ds_map_find_value(teammate, "attitude") > 90) {
			s_create_message("", s_str("msg_TeammateMoraleTooHigh"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		if (ds_map_find_value(pmap, "condition") - 1 < 20) {
			s_create_message("", s_str("msg_NotEnoughCondition"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		var msg = s_str("msg_MeetTeammate");
		msg = string_replace(msg, "$teammate", ds_map_find_value(teammate, "fname") + " " + ds_map_find_value(teammate, "lname"));
		msg = string_replace(msg, "$num", ds_map_find_value(pmap, "condition") - 20);
		s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_confirm_teammate_meeting, global.c_background, 1);
	}
}

function s_confirm_teammate_meeting() {
	s_msg_clear();
	var pmap = s_get_qb_pmap();
	var teammate = obj_master.player_profile;
	ds_map_set(pmap, "condition", clamp(ds_map_find_value(pmap, "condition") - 20, 1, 100));
	ds_map_set(teammate, "attitude", clamp(ds_map_find_value(teammate, "attitude") + 15, 1, 100));
}

