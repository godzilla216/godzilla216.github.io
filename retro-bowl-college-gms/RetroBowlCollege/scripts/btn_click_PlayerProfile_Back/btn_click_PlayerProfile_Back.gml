function btn_click_PlayerProfile_Back() {
	if (obj_master.viewing_hof_players) {
		room_goto(rm_halloffame_players);
	} else {
		room_goto(rm_profile_player);
	}
}

