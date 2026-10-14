function btn_response_player_meeting_extend_contract() {
	s_msg_clear();
	with (obj_master) {
		ds_map_set(player_profile, "meetingdone", 1);
		switch (obj_meeting_player.retirement) {
			case false:
				var meetcost = s_get_meeting_cost_extend_contract(player_profile);
				ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - meetcost, 0));
				coach_credit -= meetcost;
				if (coach_credit < 0) {
					coach_credit = 0;
				}
				ds_map_set(player_profile, "contract", real(ds_map_find_value(player_profile, "contract")) + 1);
				break;
			case true:
				var meetcost = max(s_get_meeting_cost_extend_contract(player_profile), s_get_meeting_cost_delay_retirement(player_profile));
				ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - meetcost, 0));
				coach_credit -= meetcost;
				if (coach_credit < 0) {
					coach_credit = 0;
				}
				if (ds_map_exists(player_profile, "delay_retirement")) {
					ds_map_set(player_profile, "delay_retirement", real(ds_map_find_value(player_profile, "delay_retirement")) + 1);
				} else {
					ds_map_set(player_profile, "delay_retirement", 1);
				}
				if (real(ds_map_find_value(player_profile, "contract")) < 2) {
					ds_map_set(player_profile, "contract", 2);
				}
				break;
		}
		s_savegame();
		room_goto(rm_profile_player);
	}
}

