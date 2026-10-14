function btn_click_MeetingNext() {
	with (obj_master) {
		var pos = ds_list_find_index(roster, player_profile);
		if (pos >= 0) {
			pos++;
			if (pos >= ds_list_size(roster)) {
				pos = 0;
			}
			player_profile = ds_list_find_value(roster, pos);
		}
	}
	room_goto(rm_meeting_player);
}

