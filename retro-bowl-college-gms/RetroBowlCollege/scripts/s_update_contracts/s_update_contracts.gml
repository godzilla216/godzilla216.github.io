function s_update_contracts() {
	slog("s_update_contracts");
	with (obj_master) {
		s_clear_freeagents();
		var retirements = ds_list_create();
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "age", ds_map_find_value(pmap, "age") + 1);
			ds_map_set(pmap, "contract", ds_map_find_value(pmap, "contract") - 1);
			ds_map_set(pmap, "condition", irandom_range(90, 100));
			ds_map_set(pmap, "meetingdone", 0);
			var qb_is_me = false;
			if (qb_mode && ds_map_find_value(pmap, "position") == 1) {
				qb_is_me = true;
			}
			if (ds_map_find_value(pmap, "age") > 30) {
				ds_map_set(pmap, "stamina", clamp(ds_map_find_value(pmap, "stamina") - 1, 1, 10));
			}
			if (ds_map_find_value(pmap, "age") > 30) {
				var sp_st = irandom(1);
				if ((ds_map_find_value(pmap, "position") == 1 || ds_map_find_value(pmap, "position") == 10) && ds_map_find_value(pmap, "age") < 35) {
					sp_st = 0;
				}
				switch (sp_st) {
					case 0:
						ds_map_set(pmap, "speed", clamp(ds_map_find_value(pmap, "speed") - 1, 1, 10));
						break;
					case 1:
						ds_map_set(pmap, "strength", clamp(ds_map_find_value(pmap, "strength") - 1, 1, 10));
						break;
				}
			}
			if (qb_is_me && ds_map_find_value(pmap, "age") > 30) {
				s_add_news(s_str("msg_QB_aging"));
			}
			var max_age = s_get_max_age(pmap);
			if (!qb_is_me) {
				if (ds_map_find_value(pmap, "age") > max_age) {
					ds_list_add(retirements, pmap);
					slog("Retired: " + string(ds_map_find_value(pmap, "lname")) + " at age[" + string(ds_map_find_value(pmap, "age")) + "]");
					if (s_is_co_mode() == false) {
						var msg = s_str("news_PlayerRetired");
						msg = string_replace(msg, "$teamname", s_get_team_name_by_id(myteam_id));
						msg = s_parse_player_message(msg, pmap);
						s_add_news(msg);
					}
				} else if (ds_map_find_value(pmap, "contract") < 1) {
					ds_map_set(pmap, "salary", s_get_new_salary(pmap));
					ds_map_set(pmap, "contract", irandom_range(2, 3));
					var max_age = s_get_max_age(pmap);
					if (ds_map_find_value(pmap, "age") > max_age - 3) {
						ds_map_set(pmap, "contract", 1);
					}
					if (ds_map_find_value(pmap, "age") < max_age) {
						ds_list_add(freeagentlist, pmap);
					}
				}
			}
		}
		for (var i = 0; i < ds_list_size(freeagentlist); i++) {
			ds_list_delete(roster, ds_list_find_index(roster, ds_list_find_value(freeagentlist, i)));
		}
		for (var i = 0; i < ds_list_size(retirements); i++) {
			var pmap = ds_list_find_value(retirements, i);
			var del = s_remove_player(pmap, "retired");
			if (del) {
				ds_list_set(retirements, i, -1);
			}
		}
		ds_list_destroy(retirements);
		retirements = -1;
		expiredcontract_msg_done = false;
		if (!qb_mode) {
			var staff_retirements = ds_list_create();
			for (var i = 0; i < ds_list_size(stafflist); i++) {
				var pmap = ds_list_find_value(stafflist, i);
				ds_map_set(pmap, "age", ds_map_find_value(pmap, "age") + 1);
				ds_map_set(pmap, "contract", ds_map_find_value(pmap, "contract") - 1);
				if (ds_map_find_value(pmap, "age") > s_get_max_age(pmap) && ds_map_find_value(pmap, "contract") < 1) {
					var msg = s_str("msg_StaffRetired");
					msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
					msg = string_replace(msg, "$hirename", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
					s_add_news(msg);
					ds_list_add(staff_retirements, pmap);
				} else if (ds_map_find_value(pmap, "contract") < 1) {
					var msg = s_str("msg_StaffExpired");
					msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
					msg = string_replace(msg, "$hirename", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
					s_add_news(msg);
					ds_list_add(staff_retirements, pmap);
				}
			}
			for (var i = 0; i < ds_list_size(staff_retirements); i++) {
				var pos = ds_list_find_index(stafflist, ds_list_find_value(staff_retirements, i));
				ds_list_delete(stafflist, pos);
				ds_map_destroy(ds_list_find_value(staff_retirements, i));
				ds_list_set(staff_retirements, i, -1);
			}
			ds_list_destroy(staff_retirements);
			staff_retirements = -1;
		}
		s_check_staff_exist();
	}
}

function s_check_staff_exist() {
	with (obj_master) {
		if (s_get_staff(101) == -4) {
			ds_list_add(stafflist, s_create_staff(101, 1));
		}
		if (s_get_staff(102) == -4) {
			ds_list_add(stafflist, s_create_staff(102, 1));
		}
	}
}

