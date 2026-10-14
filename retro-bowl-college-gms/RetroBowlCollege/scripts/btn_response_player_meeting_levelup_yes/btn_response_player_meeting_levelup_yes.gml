function btn_response_player_meeting_levelup_yes() {
	s_msg_clear();
	with (obj_master) {
		var meetcost = s_get_meeting_cost_levelup(player_profile);
		coach_credit -= meetcost;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - meetcost, 0));
		ds_map_set(player_profile, "meetingdone", 1);
		var xp = ds_map_find_value(player_profile, "xp");
		ds_map_set(player_profile, "xp", ds_map_find_value(player_profile, "xp_level") * 100);
		ds_map_set(player_profile, "xp_gain", round(real(ds_map_find_value(player_profile, "xp_gain")) + 10 + xp));
		s_clear_party_meter(player_profile);
		room_goto(rm_profile_player);
	}
}

