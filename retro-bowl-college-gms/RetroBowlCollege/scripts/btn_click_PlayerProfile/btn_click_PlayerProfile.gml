function btn_click_PlayerProfile() {
	slog("btn_click_PlayerProfile");
	if (obj_master.profile_back_to == -1) {
		if (room == rm_profile_player) {
			return;
		}
	}
	obj_master.player_profile = pmap;
	if (room == rm_halloffame_players) {
		btn_click_Profile_Stats();
	} else {
		room_goto(rm_profile_player);
	}
}

