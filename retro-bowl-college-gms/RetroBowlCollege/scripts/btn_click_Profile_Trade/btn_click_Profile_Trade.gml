function btn_click_Profile_Trade() {
	var pmap = obj_master.player_profile;
	var playername = ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
	var offer = ds_map_find_value(pmap, "outtrade_pick") > 0;
	if (!offer && obj_master.week > 8) {
		var msg = s_str("msg_CannotTradeWeek");
		msg = string_replace(msg, "$playername", playername);
		s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Cut"), s_msg_clear, btn_response_cut_player_yes, global.c_background, 1);
	} else if (!offer && ds_map_find_value(pmap, "condition") <= -1) {
		var msg = s_str("msg_CannotTradeInjured");
		msg = string_replace(msg, "$playername", playername);
		s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Cut"), s_msg_clear, btn_response_cut_player_yes, global.c_background, 1);
	} else if (!offer && ds_map_find_value(pmap, "attitude") <= 15) {
		var msg = s_str("msg_CannotTradeToxic");
		msg = string_replace(msg, "$playername", playername);
		s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Cut"), s_msg_clear, btn_response_cut_player_yes, global.c_background, 1);
	} else {
		var tmap = s_get_offer_team(pmap);
		var teamname = ds_map_find_value(tmap, "name");
		var playername = ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
		if (ds_map_find_value(pmap, "outtrade_pick") == 0) {
			ds_map_set(pmap, "outtrade_pick", s_get_trade_value(pmap));
		}
		var msg = s_str("msg_TradePlayerThis");
		if (ds_map_find_value(pmap, "outtrade_pick") < obj_master.draft_round) {
			msg = s_str("msg_TradePlayerNext");
		}
		msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
		msg = string_replace(msg, "$teamname", teamname);
		msg = string_replace(msg, "$playername", playername);
		msg = string_replace(msg, "$num", string(ds_map_find_value(pmap, "outtrade_pick")));
		if (ds_map_find_value(pmap, "signed_year") == obj_master.year) {
			msg = string_hash_to_newline(msg + "##" + s_str("msg_TradeAwayRookie"));
		}
		s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Trade"), btn_response_out_trade_player_no, btn_response_out_trade_player_yes, global.c_background, 1);
	}
}

