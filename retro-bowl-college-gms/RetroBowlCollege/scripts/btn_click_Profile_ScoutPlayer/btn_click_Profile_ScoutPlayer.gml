function btn_click_Profile_ScoutPlayer() {
	with (obj_master) {
		ds_map_set(player_profile, "scouted", true);
		interviews--;
	}
	room_goto(rm_profile_player);
}

