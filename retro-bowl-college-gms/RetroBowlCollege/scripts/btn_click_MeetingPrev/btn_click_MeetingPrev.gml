function btn_click_MeetingPrev() {
	with (obj_master) {
		var pos = ds_list_find_index(roster, player_profile);
		if (pos >= 0) {
			pos--;
			if (pos < 0) {
				pos = ds_list_size(roster) - 1;
			}
			player_profile = ds_list_find_value(roster, pos);
		}
	}
	room_goto(rm_meeting_player);
}

