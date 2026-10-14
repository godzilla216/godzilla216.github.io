function btn_response_player_meeting_condition_yes() {
	s_msg_clear();
	with (obj_master) {
		var meetcost = s_get_meeting_cost_condition(player_profile);
		var con = ds_map_find_value(player_profile, "condition");
		var old_amount = con;
		coach_credit -= meetcost;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - meetcost, 0));
		ds_map_set(player_profile, "condition", 100);
		ds_map_set(player_profile, "meetingdone", 1);
		var num = string(irandom_range(1, 3));
		var msg = s_str("msg_boost_condition" + num);
		msg = string_replace(msg, "$playername", ds_map_find_value(player_profile, "fname") + " " + ds_map_find_value(player_profile, "lname"));
		s_meter_change(3, old_amount, rm_profile_player, msg);
		s_clear_party_meter(player_profile);
	}
}

