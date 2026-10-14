function btn_click_Profile_Pick() {
	var list = obj_master.roster;
	global.debug_track_str = "PP|";
	if (ds_list_find_index(obj_master.storelist, obj_master.player_profile) >= 0) {
		global.debug_track_str += "LS|";
		list = obj_master.storelist;
	} else if (ds_list_find_index(obj_master.draftlist, obj_master.player_profile) >= 0) {
		global.debug_track_str += "DS|";
		list = obj_master.draftlist;
	} else if (ds_list_find_index(obj_master.freeagentlist, obj_master.player_profile) >= 0) {
		global.debug_track_str += "FS|";
		list = obj_master.freeagentlist;
	} else if (ds_list_find_index(obj_master.tradelist, obj_master.player_profile) >= 0) {
		global.debug_track_str += "TS|";
		list = obj_master.tradelist;
	} else if (ds_list_find_index(obj_master.hoflist, obj_master.player_profile) >= 0) {
		global.debug_track_str += "HS|";
		list = obj_master.hoflist;
	}
	var playername = ds_map_find_value(obj_master.player_profile, "fname") + " " + ds_map_find_value(obj_master.player_profile, "lname");
	var max_roster = s_get_roster_cap();
	if (ds_list_size(obj_master.roster) >= max_roster) {
		var limitMsg = "msg_RosterLimit";
		if (s_is_co_mode()) {
			var allAreFreshman = true;
			for (var r = 0; r < ds_list_size(obj_master.roster); r++) {
				var pmap = ds_list_find_value(obj_master.roster, r);
				if (pmap && ds_map_find_value(pmap, "age") != s_rookie_age_internal()) {
					allAreFreshman = false;
					break;
				}
			}
			if (allAreFreshman) {
				limitMsg = "msg_RosterLimitAllFreshman";
			}
		}
		s_create_message("", s_str(limitMsg), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		return;
	} else if (!s_is_co_mode() && ds_map_find_value(obj_master.player_profile, "salary") + s_get_salary_total() > obj_master.salary_cap + obj_master.boost_salary_cap) {
		var msg = s_str("ui_ExceedSalaryCap");
		msg = string_replace(msg, "$playername", playername);
		msg = string_replace(msg, "$num", string(obj_master.salary_cap + obj_master.boost_salary_cap - s_get_salary_total()));
		s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Roster"), s_msg_clear, btn_click_Roster, global.c_background, 1);
		return;
	} else if (s_is_co_mode() && ds_map_find_value(obj_master.player_profile, "rc_cost") > obj_master.recruitment_credits) {
		var msg = s_str("ui_ExceedRecruitmentCredits");
		msg = string_replace(msg, "$playername", playername);
		msg = string_replace(msg, "$num", string(obj_master.recruitment_credits));
		s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		return;
	} else if (list == obj_master.freeagentlist && ds_map_find_value(obj_master.player_profile, "teamid") == obj_master.myteam_id && ds_map_find_value(obj_master.player_profile, "attitude") <= 15) {
		var msg = s_str("msg_CannotSignMoraleLow");
		msg = string_replace(msg, "$playername", playername);
		s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		return;
	} else {
		var pos = ds_map_find_value(obj_master.player_profile, "position");
		var count = s_count_players_by_position(pos);
		var maxpos = 1;
		switch (pos) {
			case 1:
				maxpos = 2;
				break;
			case 2:
				maxpos = 2;
				break;
			case 3:
				maxpos = 3;
				break;
			case 4:
				maxpos = 3;
				break;
			case 5:
				maxpos = 5;
				break;
			case 6:
				maxpos = 4;
				break;
			case 7:
				maxpos = 3;
				break;
			case 9:
			case 8:
				maxpos = 4;
				break;
			case 10:
				maxpos = 2;
				break;
		}
		if (count >= maxpos) {
			var msg = s_str("msg_CannotSign1");
			if (maxpos > 1) {
				msg = s_str("msg_CannotSign2");
			}
			msg = string_replace(msg, "$num", count);
			msg = string_replace(msg, "$position", s_get_string_position_full(pos));
			msg = string_replace(msg, "$position", s_get_string_position_full(pos));
			msg = string_replace(msg, "$playername", playername);
			s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Roster"), s_msg_clear, btn_click_Roster, global.c_background, 1);
			return;
		}
	}
	if (list == obj_master.tradelist) {
		var team_id = ds_map_find_value(obj_master.player_profile, "teamid");
		var tmap = ds_list_find_value(obj_master.teamlist, team_id);
		var teamname = ds_map_find_value(tmap, "name");
		var pick = s_get_trade_value(obj_master.player_profile);
		if (ds_map_find_value(obj_master.player_profile, "intrade_pick") > 0) {
			pick = ds_map_find_value(obj_master.player_profile, "intrade_pick");
		}
		if (obj_master.draft_picks[pick - 1] < 1) {
			var msg = s_str("ui_NoMorePicksToTrade");
			msg = string_replace(msg, "$num", string(pick));
			s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			return;
		}
		ds_map_set(obj_master.player_profile, "intrade_pick", pick);
		var msg = s_str("msg_TradeOfferSign");
		msg = string_replace(msg, "$teamname", teamname);
		msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(obj_master.player_profile, "position")));
		msg = string_replace(msg, "$playername", playername);
		msg = string_replace(msg, "$num", string(pick));
		s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, btn_response_in_trade_player_yes, global.c_background, 1);
	} else if (list == obj_master.storelist) {
		var cost = ds_map_find_value(obj_master.player_profile, "creditcost");
		if (obj_master.coach_credit < cost) {
			var msg = s_str("msg_SignPlayerStoreNoCredit");
			msg = string_replace(msg, "$num", string(cost));
			s_create_message(s_str("ui_SignPlayer"), msg, s_str("ui_Continue"), "", s_store_cant_afford, "", global.c_background, 1);
			return;
		}
		var msg = s_str("msg_SignPlayerStore");
		msg = string_replace(msg, "$num", string(cost));
		msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(obj_master.player_profile, "position")));
		msg = string_replace(msg, "$playername", playername);
		global.debug_track_str += "Y1|";
		s_create_message(s_str("ui_SignPlayer"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_pick_player_yes, global.c_background, 1);
	} else if (list == obj_master.hoflist) {
		var msg = s_str("msg_ReinstatePlayer");
		msg = string_replace(msg, "$playername", string_upper(playername));
		msg = string_replace(msg, "$salary", string(ds_map_find_value(obj_master.player_profile, "salary")));
		global.debug_track_str += "Y2|";
		s_create_message(s_str("ui_SignPlayer"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_pick_player_yes, global.c_background, 1);
	} else {
		var msg = s_str("msg_SignPlayer");
		if (ds_map_find_value(obj_master.player_profile, "age") == s_rookie_age_internal()) {
			msg = s_str("msg_SignRookie");
		}
		msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(obj_master.player_profile, "position")));
		msg = string_replace(msg, "$playername", playername);
		global.debug_track_str += "Y3|";
		s_create_message(s_str("ui_SignPlayer"), msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_pick_player_yes, global.c_background, 1);
	}
}

