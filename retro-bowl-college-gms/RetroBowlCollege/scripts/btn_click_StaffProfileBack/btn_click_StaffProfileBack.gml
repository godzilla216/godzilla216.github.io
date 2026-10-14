function btn_click_StaffProfileBack() {
	with (obj_master) {
		if (ds_list_find_index(stafflist, player_profile) >= 0 || ds_map_find_value(player_profile, "position") == 100) {
			room_goto(rm_frontoffice);
		} else {
			btn_click_ViewHires();
		}
	}
}

