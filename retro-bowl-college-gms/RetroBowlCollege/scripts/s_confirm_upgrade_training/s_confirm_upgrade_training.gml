function s_confirm_upgrade_training() {
	with (obj_master) {
		s_msg_clear();
		facility_upgraded_training = week;
		facility_training = clamp(facility_training + 1, 1, 10);
		coach_credit -= facility_training;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - facility_training, 0));
		s_complete_achievement("ACH_UPGRADE_TRAINING");
		if (facility_training == 10) {
			s_complete_achievement("ACH_MAX_TRAINING");
		}
		var mor = s_get_morale();
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			var amt = (100 - ds_map_find_value(pmap, "attitude")) * 0.1;
			ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + round(amt), 1, 100));
		}
		if (s_get_morale() > mor + 2) {
			s_meter_change(4, mor, rm_frontoffice, "");
		} else {
			room_goto(rm_frontoffice);
		}
	}
}

