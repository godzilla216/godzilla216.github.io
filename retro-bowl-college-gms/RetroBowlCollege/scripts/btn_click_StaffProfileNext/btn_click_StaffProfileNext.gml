function btn_click_StaffProfileNext() {
	with (obj_master) {
		if (ds_list_find_index(stafflist, player_profile) > -1) {
			var pos = ds_list_find_index(stafflist, player_profile) + 1;
			if (pos >= ds_list_size(stafflist)) {
				pos = 0;
			}
			player_profile = ds_list_find_value(stafflist, pos);
		} else if (ds_list_find_index(hirelist, player_profile) > -1) {
			var shortlist = s_get_hire_shortlist(ds_map_find_value(player_profile, "position"));
			var pos = ds_list_find_index(shortlist, player_profile) + 1;
			if (pos >= ds_list_size(shortlist)) {
				pos = 0;
			}
			player_profile = ds_list_find_value(shortlist, pos);
			ds_list_destroy(shortlist);
			shortlist = -1;
		}
	}
	room_goto(rm_profile_staff);
}

