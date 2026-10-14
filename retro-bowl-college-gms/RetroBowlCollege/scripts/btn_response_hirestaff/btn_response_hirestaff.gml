function btn_response_hirestaff() {
	s_msg_clear();
	with (obj_master) {
		if (ds_list_find_index(obj_master.stafflist, staff_hire) < 0) {
			var rating = 0;
			if (ds_map_find_value(staff_hire, "position") == 101) {
				rating = s_get_team_defense(myteam);
				s_fire_coach(s_get_staff(101));
				s_complete_achievement("ACH_HIRE_DF");
				if (ds_map_find_value(staff_hire, "rating") >= 10) {
					s_complete_achievement("ACH_HIRE_DF5");
				}
				if (rating >= 10) {
					s_complete_achievement("ACH_DEFENSE5");
				}
			} else {
				rating = s_get_team_offense(myteam);
				s_fire_coach(s_get_staff(102));
				s_complete_achievement("ACH_HIRE_OF");
				if (ds_map_find_value(staff_hire, "rating") >= 10) {
					s_complete_achievement("ACH_HIRE_OF5");
				}
				if (rating >= 10) {
					s_complete_achievement("ACH_OFFENSE5");
				}
			}
			ds_list_delete(hirelist, ds_list_find_index(hirelist, staff_hire));
			ds_list_add(stafflist, staff_hire);
			ds_map_set(staff_hire, "contract", 2);
			if (week > 8) {
				ds_map_set(staff_hire, "contract", 3);
			}
			var cost = s_get_coach_cost(staff_hire);
			coach_credit -= cost;
			ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - cost, 0));
			switch (ds_map_find_value(staff_hire, "trait")) {
				case 1:
					s_coach_trait_experience(staff_hire);
					break;
				case 3:
					s_coach_trait_motivator(staff_hire);
					break;
				case 2:
					s_coach_trait_talentspotter(staff_hire);
				default:
					if (ds_map_find_value(staff_hire, "position") == 101) {
						if (rating != s_get_team_defense(myteam)) {
							s_meter_change(7, rating, rm_frontoffice, "");
						} else {
							room_goto(rm_frontoffice);
						}
					} else if (rating != s_get_team_offense(myteam)) {
						s_meter_change(6, rating, rm_frontoffice, "");
					} else {
						room_goto(rm_frontoffice);
					}
					break;
			}
			var msg = s_str("news_HireStaff");
			msg = string_replace(msg, "$teamname", ds_map_find_value(myteam, "name"));
			msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(staff_hire, "position")));
			msg = string_replace(msg, "$hirename", ds_map_find_value(staff_hire, "fname") + " " + ds_map_find_value(staff_hire, "lname"));
			msg = string_replace(msg, "$num", string(ds_map_find_value(staff_hire, "contract")));
			s_add_news(msg);
		} else {
			var cost = round(s_get_coach_cost(staff_hire) * 0.5);
			if (cost < 1) {
				cost = 1;
			}
			coach_credit -= cost;
			ds_map_set(staff_hire, "contract", ds_map_find_value(staff_hire, "contract") + 1);
			ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - cost, 0));
			s_complete_achievement("ACH_COACHEXTEND");
			if (ds_map_find_value(staff_hire, "rating") >= 10) {
				if (ds_map_find_value(staff_hire, "position") == 101) {
					s_complete_achievement("ACH_HIRE_DF5");
				} else {
					s_complete_achievement("ACH_HIRE_OF5");
				}
			}
			room_goto(rm_frontoffice);
		}
	}
}

