function s_confirm_upgrade_stadium() {
	with (obj_master) {
		s_msg_clear();
		facility_upgraded_stadium = week;
		facility_stadium = clamp(facility_stadium + 1, 1, 10);
		coach_credit -= facility_stadium;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - facility_stadium, 0));
		s_complete_achievement("ACH_UPGRADE_STADIUM");
		if (facility_stadium == 10) {
			s_complete_achievement("ACH_MAX_STADIUM");
		}
		var orig = fans;
		var amt = (100 - fans) * 0.1;
		fans = clamp(fans + amt, 1, 100);
		if (fans > orig + 2) {
			s_meter_change(1, orig, rm_frontoffice, "");
		} else {
			room_goto(rm_frontoffice);
		}
	}
}

