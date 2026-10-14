function btn_response_boost_condition() {
	s_msg_clear();
	with (obj_master) {
		boost_condition_done = true;
		coach_credit -= 25;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		var con = s_get_condition_squad();
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "condition") > 0) {
				ds_map_set(pmap, "condition", clamp(ds_map_find_value(pmap, "condition") + 20, 1, 100));
			}
		}
		s_team_halve_all_party_meters();
		s_meter_change(2, con, rm_xp, s_str("msg_BoostConditionEvent" + string(irandom(5))));
	}
}

