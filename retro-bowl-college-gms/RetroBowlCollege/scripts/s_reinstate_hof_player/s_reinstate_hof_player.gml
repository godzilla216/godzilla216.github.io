function s_reinstate_hof_player() {
	return;
	with (obj_master) {
		if (viewing_hof_players) {
			slog("s_reinstate_hof_player");
			if (ds_list_find_index(roster, player_profile)) {
				s_create_message("", s_str("msg_Reinstate_OnRoster"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 0.7);
			} else {
				ds_map_set(player_profile, "salary", s_get_new_salary(player_profile));
				ds_map_set(player_profile, "contract", 1);
				btn_click_Profile_Pick();
			}
		}
	}
}

