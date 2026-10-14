function s_confirm_upgrade_rehab() {
	with (obj_master) {
		s_msg_clear();
		facility_upgraded_rehab = week;
		facility_rehab = clamp(facility_rehab + 1, 1, 10);
		coach_credit -= facility_rehab;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - facility_rehab, 0));
		s_complete_achievement("ACH_UPGRADE_REHAB");
		if (facility_rehab == 10) {
			s_complete_achievement("ACH_MAX_REHAB");
		}
		var cond = s_get_condition_squad();
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "condition") > 0) {
				var amt = (100 - ds_map_find_value(pmap, "condition")) * 0.1;
				ds_map_set(pmap, "condition", clamp(round(ds_map_find_value(pmap, "condition") + amt), 1, 100));
			}
		}
		if (s_get_condition_squad() > cond + 2) {
			s_meter_change(2, cond, rm_frontoffice, "");
		} else {
			room_goto(rm_frontoffice);
		}
	}
}

