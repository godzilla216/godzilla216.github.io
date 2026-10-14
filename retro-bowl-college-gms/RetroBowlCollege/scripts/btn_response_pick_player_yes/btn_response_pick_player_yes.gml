function btn_response_pick_player_yes() {
	s_msg_clear();
	with (obj_master) {
		var from_team_id = ds_map_find_value(player_profile, "teamid");
		slog("Pick player yes. TeamId = " + string(from_team_id));
		ds_map_set(player_profile, "signed_year", obj_master.year);
		ds_map_set(player_profile, "teamid", obj_master.myteam_id);
		ds_map_set(player_profile, "flash_time", current_time);
		ds_list_add(roster, player_profile);
		var pos = ds_list_find_index(freeagentlist, player_profile);
		if (pos > -1) {
			var msg = s_str("news_SignFreeAgent");
			if (from_team_id == myteam_id) {
				msg = s_str("news_ResignedPlayer");
				if (s_is_co_mode()) {
					msg += " ||" + global.debug_track_str;
					msg += "|PTI:" + string(from_team_id);
					msg += "|TI:" + string(myteam_id) + s_get_team_name_by_id(myteam_id);
					msg += "|PC:" + string(s_get_map(player_profile, "contract", -404));
					msg += "|PA:" + string(s_get_map(player_profile, "age", -404));
					msg += "|PLR:" + string(s_get_map(player_profile, "team_leave_reason", -404));
					msg += "|PSY:" + string(s_get_map(player_profile, "signed_year", -404));
				}
			}
			msg = s_parse_player_message(msg, player_profile);
			s_add_news(msg);
			s_complete_achievement("ACH_FREEAGENT");
			if (s_get_player_rating(player_profile) >= 10) {
				s_complete_achievement("ACH_FREEAGENT5");
			}
			ds_list_delete(freeagentlist, pos);
			room_goto(rm_roster);
			return;
		}
		pos = ds_list_find_index(tradelist, player_profile);
		if (pos > -1) {
			var msg = s_str("news_SignTrade");
			msg = s_parse_player_message(msg, player_profile);
			msg = string_replace(msg, "$otherteamname", s_get_team_name_by_id(from_team_id));
			s_add_news(msg);
			s_complete_achievement("ACH_TRADEIN");
			ds_list_delete(tradelist, pos);
			room_goto(rm_roster);
			return;
		}
		pos = ds_list_find_index(draftlist, player_profile);
		if (pos > -1) {
			if (s_is_co_mode()) {
				s_college_admissions_pick_player(pos);
			} else {
				draft_picks[draft_round - 1]--;
				ds_list_delete(draftlist, pos);
			}
			room_goto(rm_roster);
			s_complete_achievement("ACH_DRAFT");
			s_complete_achievement("ACH_NEW_FRESHMAN");
			return;
		}
		pos = ds_list_find_index(storelist, player_profile);
		if (pos > -1) {
			var msg = s_str("news_SignTrade2");
			msg = s_parse_player_message(msg, player_profile);
			s_add_news(msg);
			coach_credit -= ds_map_find_value(player_profile, "creditcost");
			ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - ds_map_find_value(player_profile, "creditcost"), 0));
			ds_list_delete(storelist, pos);
			roster_from_store = false;
			s_savegame();
			room_goto(rm_roster);
			s_complete_achievement("ACH_FREEAGENT");
			if (s_get_player_rating(player_profile) >= 10) {
				s_complete_achievement("ACH_FREEAGENT5");
			}
			return;
		}
		pos = ds_list_find_index(hoflist, player_profile);
		if (pos > -1) {
			ds_list_delete(hoflist, pos);
			room_goto(rm_roster);
			return;
		}
	}
	room_goto(rm_roster);
}

