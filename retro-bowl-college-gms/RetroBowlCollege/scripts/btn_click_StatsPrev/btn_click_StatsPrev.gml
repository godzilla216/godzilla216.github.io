function btn_click_StatsPrev() {
	with (obj_master) {
		pos = ds_list_find_index(roster, player_profile) - 1;
		if (pos < 0) {
			pos = ds_list_size(roster) - 1;
		}
		player_profile = ds_list_find_value(roster, pos);
		if (ds_map_find_value(player_profile, "position") == 1) {
			stat_view = 1;
		}
		if (ds_map_find_value(player_profile, "position") == 2) {
			stat_view = 2;
		}
		if (s_is_co_mode()) {
			obj_master.co_stats_tab = 0;
		}
	}
	room_goto(rm_stats_player);
}

