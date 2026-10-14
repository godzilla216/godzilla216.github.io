function btn_click_Profile_Not_Interested() {
	with (obj_master) {
		stage = 1;
		var pos = ds_list_find_index(freeagentlist, player_profile);
		if (pos > -1) {
			if (ds_exists(player_profile, 1) && ds_map_exists(player_profile, "hof") && ds_map_find_value(player_profile, "hof") == true) {
				ds_map_set(player_profile, "team_leave_reason", "cut");
				ds_list_add(hoflist, player_profile);
			} else {
				ds_map_destroy(ds_list_find_value(freeagentlist, pos));
				ds_list_set(freeagentlist, pos, -1);
			}
			ds_list_delete(freeagentlist, pos);
			if (ds_list_size(freeagentlist) > 0) {
				room_goto(rm_freeagents);
				return;
			}
		}
		pos = ds_list_find_index(tradelist, player_profile);
		if (pos > -1) {
			ds_map_destroy(ds_list_find_value(tradelist, pos));
			ds_list_set(tradelist, pos, -1);
			ds_list_delete(tradelist, pos);
			if (ds_list_size(tradelist) > 0) {
				room_goto(rm_freeagents);
				return;
			}
		}
	}
	room_goto(rm_home);
}

