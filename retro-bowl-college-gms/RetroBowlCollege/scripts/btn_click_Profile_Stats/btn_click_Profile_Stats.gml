function btn_click_Profile_Stats() {
	with (obj_master) {
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

