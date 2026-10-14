function btn_response_rest_player_yes() {
	with (obj_master) {
		ds_map_set(player_profile, "resting", true);
		if (ds_map_find_value(player_profile, "condition") < 40) {
			ds_map_set(player_profile, "attitude", clamp(ds_map_find_value(player_profile, "attitude") + 15, 1, 100));
		}
	}
	room_goto(rm_profile_player);
}

