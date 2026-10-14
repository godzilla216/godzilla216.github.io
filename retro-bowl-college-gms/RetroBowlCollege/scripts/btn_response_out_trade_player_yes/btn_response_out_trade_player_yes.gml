function btn_response_out_trade_player_yes() {
	s_msg_clear();
	with (obj_master) {
		array_set_post(draft_picks, ds_map_find_value(player_profile, "outtrade_pick") - 1, array_get(draft_picks, ds_map_find_value(player_profile, "outtrade_pick") - 1) + 1);
		ds_map_set(player_profile, "outtrade_pick", 0);
		var orig_fans = fans;
		if (ds_map_find_value(player_profile, "signed_year") == year) {
			s_adjust_team_morale(-15, -10);
			fans = clamp(fans * 0.85, 1, 100);
		}
		var del = s_remove_player(player_profile, "trade");
		if (del) {
			player_profile = -1;
		}
		s_complete_achievement("ACH_TRADEOUT");
		s_savegame();
		if (fans < orig_fans - 2) {
			s_meter_change(1, orig_fans, rm_roster, "");
		} else {
			room_goto(rm_roster);
		}
	}
}

