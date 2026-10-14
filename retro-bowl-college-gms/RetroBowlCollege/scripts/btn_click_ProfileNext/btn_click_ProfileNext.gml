function btn_click_ProfileNext() {
	with (obj_master) {
		var list = -4;
		var pos = ds_list_find_index(roster, player_profile);
		if (pos >= 0) {
			list = roster;
		} else {
			pos = ds_list_find_index(draftlist, player_profile);
			if (pos >= 0) {
				list = draftlist;
			} else {
				pos = ds_list_find_index(freeagentlist, player_profile);
				if (pos >= 0) {
					list = freeagentlist;
				} else {
					pos = ds_list_find_index(tradelist, player_profile);
					if (pos >= 0) {
						list = tradelist;
					} else {
						pos = ds_list_find_index(storelist, player_profile);
						if (pos >= 0) {
							list = storelist;
						}
					}
				}
			}
		}
		if (list) {
			pos++;
			if (pos >= ds_list_size(list)) {
				pos = 0;
			}
			player_profile = ds_list_find_value(list, pos);
		}
	}
	room_goto(rm_profile_player);
}

