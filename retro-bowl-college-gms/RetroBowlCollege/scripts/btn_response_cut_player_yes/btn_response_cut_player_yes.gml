function btn_response_cut_player_yes() {
	s_msg_clear();
	with (obj_master) {
		var patt = ds_map_find_value(player_profile, "attitude");
		if (room == rm_profile_player) {
			var del = s_remove_player(player_profile, "cut", s_pick_epilogue_story("epi_cut"));
			if (del) {
				player_profile = -1;
			}
		} else {
			ds_list_delete(roster, ds_list_find_index(roster, player_profile));
			ds_map_destroy(player_profile);
			player_profile = -1;
		}
		s_complete_achievement("ACH_CUT");
		if (patt > 15) {
			s_meter_change(4, s_get_morale(), rm_roster, "");
			var i = -s_get_attitude_icon(patt);
			s_adjust_team_morale(i * 2, i);
			if (room == rm_profile_player) {
				return;
			}
		}
	}
	room_goto(rm_roster);
}

