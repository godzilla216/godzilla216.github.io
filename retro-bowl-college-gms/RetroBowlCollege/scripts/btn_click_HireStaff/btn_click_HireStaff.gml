function btn_click_HireStaff() {
	var pmap = obj_master.player_profile;
	var msg = s_str("msg_HireStaff");
	var contract = 2;
	var cost = s_get_coach_cost(pmap);
	if (ds_list_find_index(obj_master.stafflist, pmap) < 0) {
		if (cost > obj_master.coach_credit) {
			msg = s_str("msg_HireStaffNoCost");
			msg = string_replace(msg, "$hirename", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
			msg = string_replace(msg, "$num", cost);
			s_create_message(s_str("ui_HireStaff"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		msg = string_replace(msg, "$hirename", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
		msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
		msg = string_replace(msg, "$year", string(contract));
		msg = string_replace(msg, "$num", cost);
		obj_master.staff_hire = pmap;
		s_create_message(s_str("ui_HireStaff"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_hirestaff, global.c_background, 1);
	} else {
		cost = round(cost * 0.5);
		if (cost < 1) {
			cost = 1;
		}
		if (ds_map_find_value(pmap, "age") >= s_get_max_age(pmap)) {
			msg = s_str("msg_StaffExtendNoAge");
			s_create_message(s_str("ui_HireStaff"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		} else if (cost > obj_master.coach_credit) {
			msg = s_str("msg_StaffExtendNoCost");
			if (cost < 2) {
				msg = s_str("msg_StaffExtendNoCost1");
			}
			msg = string_replace(msg, "$hirename", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
			msg = string_replace(msg, "$num", cost);
			s_create_message(s_str("ui_HireStaff"), msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		obj_master.staff_hire = pmap;
		msg = s_str("msg_StaffExtend");
		if (cost < 2) {
			msg = s_str("msg_StaffExtend1");
		}
		if (ds_map_find_value(pmap, "contract") < 2) {
			msg = s_str("msg_StaffExpiring") + " " + msg;
		}
		msg = string_replace_all(msg, "$hirename", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
		msg = string_replace_all(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
		msg = string_replace_all(msg, "$num", cost);
		s_create_message(s_str("ui_HireStaff"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_hirestaff, global.c_background, 1);
	}
}

