function s_edit_confirm_profile() {
	with (obj_master) {
		var txt1 = edit_box1.text;
		var txt2 = edit_box2.text;
		if (player_profile) {
			if (string_length(txt1) > 0) {
				ds_map_set(player_profile, "fname", txt1);
			}
			if (string_length(txt1) > 0) {
				ds_map_set(player_profile, "lname", txt2);
			}
			s_msg_clear();
			switch (ds_map_find_value(player_profile, "position")) {
				case 100:
					s_update_boss_profile();
					room_goto(rm_profile_boss);
					break;
				case 102:
				case 101:
					room_goto(rm_profile_staff);
					break;
				default:
					room_goto(rm_profile_player);
					break;
			}
		}
	}
}

function s_update_boss_profile() {
	with (obj_master) {
		fname = ds_map_find_value(boss_profile, "fname");
		lname = ds_map_find_value(boss_profile, "lname");
	}
}

