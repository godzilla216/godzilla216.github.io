function s_check_draft() {
	with (obj_master) {
		if (qb_mode) {
			s_check_draft_QB();
			return;
		}
		if (s_is_co_mode()) {
			s_check_draft_CO();
			return;
		}
		slog("s_check_draft");
		slog("Week = " + string(week));
		slog("Draft = " + string(draft_round));
		if (intro > 0) {
		} else if (week == 1) {
			if (ds_list_size(obj_master.freeagentlist)) {
				stage = 1;
				room_goto(rm_freeagents);
				return;
			} else {
				switch (draft_round) {
					case 1:
						if (ds_list_size(draftlist) < 50) {
							s_create_draftlist();
						}
						room_goto(rm_draft);
						return;
						break;
					case 2:
						room_goto(rm_draft);
						return;
						break;
					case 3:
						room_goto(rm_draft);
						return;
						break;
				}
			}
		} else if (ds_list_size(obj_master.roster) >= 12 || obj_master.salary_cap < 200 && ds_list_size(obj_master.roster) >= 10) {
			s_clear_freeagents();
		} else if (week < 8 && !offers_done) {
			offers_done = true;
			if (ds_list_size(obj_master.freeagentlist) || ds_list_size(obj_master.tradelist)) {
				room_goto(rm_freeagents);
				return;
			}
			switch (irandom(2)) {
				case 0:
					s_create_freeagentlist(1);
					var pmap = ds_list_find_value(obj_master.freeagentlist, 0);
					if (pmap) {
						if (s_position_already_on_roster(ds_map_find_value(pmap, "position")) || ds_map_find_value(pmap, "salary") + s_get_salary_total() > obj_master.salary_cap + obj_master.boost_salary_cap) {
							s_clear_freeagents();
							break;
						}
						obj_master.player_profile = pmap;
						var staffmap = -4;
						var msg = s_str("msg_FreeAgentOffer");
						if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
							msg = s_str("msg_FreeAgentOffer_Rookie");
							if (s_is_offensive_player(pmap)) {
								staffmap = s_get_staff(102);
							} else {
								staffmap = s_get_staff(101);
							}
						}
						msg = string_replace(msg, "$playername", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
						msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
						if (staffmap) {
							msg = string_replace(msg, "$coachname", s_get_player_name(staffmap, true));
						}
						s_create_message(s_str("ui_FreeAgent"), msg, s_str("ui_Continue"), "", btn_click_PlayerProfile_Back, "", global.c_background, 1);
						s_savegame();
						return;
					}
					break;
				case 1:
					s_create_tradelist(1);
					var pmap = ds_list_find_value(obj_master.tradelist, 0);
					if (pmap) {
						if (ds_map_find_value(pmap, "salary") + s_get_salary_total() > obj_master.salary_cap + obj_master.boost_salary_cap) {
							s_clear_freeagents();
							break;
						}
						obj_master.player_profile = pmap;
						var rating = clamp(s_get_player_rating(pmap) - 4, 1, 10);
						if (ds_map_find_value(pmap, "attitude") <= 15) {
							rating = 1;
						}
						var pick = s_get_trade_value_by_rating(rating);
						if (s_remaining_picks_by_round(pick) > 0) {
							ds_map_set(pmap, "intrade_pick", pick);
							s_savegame();
							var msg = s_str("msg_TradeOffer");
							msg = string_replace(msg, "$teamname", s_get_team_name_by_id(ds_map_find_value(pmap, "teamid")));
							msg = string_replace(msg, "$playername", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
							msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
							msg = string_replace(msg, "$num", string(pick));
							s_create_message(s_str("ui_TradeOffer"), msg, s_str("ui_Continue"), "", btn_click_PlayerProfile_Back, "", global.c_background, 1);
							return;
						} else {
							s_clear_freeagents();
							break;
						}
					}
					break;
				case 2:
					var size = ds_list_size(obj_master.roster);
					if (size < 4) {
						break;
					}
					var pmap = s_get_random_player(false);
					if (pmap) {
						if (ds_map_find_value(pmap, "age") > 31 || ds_map_find_value(pmap, "signed_year") == obj_master.year || ds_map_find_value(pmap, "attitude") <= 15) {
							break;
						}
						obj_master.player_profile = pmap;
						var rating = clamp(s_get_player_rating(pmap) + 4, 1, 10);
						ds_map_set(pmap, "outtrade_pick", s_get_trade_value_by_rating(rating));
						s_savegame();
						var tmap = s_get_offer_team(pmap);
						var msg = s_str("msg_TradeRequest");
						msg = string_replace(msg, "$teamname", ds_map_find_value(tmap, "name"));
						msg = string_replace(msg, "$playername", ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname"));
						msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
						msg = string_replace(msg, "$num", string(ds_map_find_value(pmap, "outtrade_pick")));
						s_create_message(s_str("ui_TradeRequest"), msg, s_str("ui_Continue"), "", btn_click_PlayerProfile_Back, "", global.c_background, 1);
						return;
					}
					break;
			}
		}
		if (!obj_master.prematch_dilemma_done && !s_is_bye_week(obj_master.week) && obj_master.week < obj_master.last_week_regular && obj_master.year > 1) {
			if (s_do_prematch_dilemma(false)) {
				return;
			}
		}
		obj_master.prematch_dilemma_done = true;
		s_savegame();
		s_play(1);
	}
}

