function btn_response_in_trade_player_yes() {
	s_msg_clear();
	with (obj_master) {
		var pick = ds_map_find_value(player_profile, "intrade_pick");
		var from_team_id = ds_map_find_value(player_profile, "teamid");
		draft_picks[pick - 1]--;
		ds_map_set(player_profile, "signed_year", obj_master.year);
		ds_map_set(player_profile, "teamid", obj_master.myteam_id);
		ds_map_set(player_profile, "intrade_pick", 0);
		ds_map_set(player_profile, "flash_time", current_time);
		var msg = s_str("news_SignTrade");
		msg = s_parse_player_message(msg, player_profile);
		msg = string_replace(msg, "$otherteamname", s_get_team_name_by_id(from_team_id));
		s_add_news(msg);
		s_complete_achievement("ACH_TRADEIN");
		ds_list_add(roster, player_profile);
		ds_list_delete(tradelist, ds_list_find_index(tradelist, player_profile));
		s_savegame();
		room_goto(rm_roster);
	}
}

