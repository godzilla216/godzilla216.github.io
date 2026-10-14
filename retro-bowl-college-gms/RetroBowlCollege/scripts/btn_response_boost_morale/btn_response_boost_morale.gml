function btn_response_boost_morale() {
	s_msg_clear();
	with (obj_master) {
		boost_morale_done = true;
		coach_credit -= 25;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		var mor = s_get_morale();
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + 10, 1, 100));
		}
		s_team_halve_all_party_meters();
		s_meter_change(4, mor, rm_xp, s_str("msg_BoostMoraleEvent" + string(irandom(9))));
	}
}

