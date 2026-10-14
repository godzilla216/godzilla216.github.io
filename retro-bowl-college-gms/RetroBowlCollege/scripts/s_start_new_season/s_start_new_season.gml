function s_start_new_season(_arg0) {
	slog("s_start_new_season");
	with (obj_master) {
		if (s_is_co_mode()) {
			s_update_history_season_end();
			slog("s_start_new_season rc tally: rc_season_earned[" + string(rc_season_earned) + "] rc_season_spent[" + string(rc_season_spent) + "]  ");
			slog("s_start_new_season rc tally: rc_lifetime_earned[" + string(rc_lifetime_earned) + "] rc_lifetime_spent[" + string(rc_lifetime_spent) + "]  ");
			rc_season_earned = 0;
			rc_season_spent = 0;
		}
		s_reset_match_stats(true);
		jobofferdone = false;
		if (year > 1) {
			s_complete_achievement("ACH_SEASON1");
		}
		if (s_count_achievement("ACH_SEASON1") >= 5) {
			s_complete_achievement("ACH_SEASON5");
		}
		if (s_count_achievement("ACH_SEASON1") >= 10) {
			s_complete_achievement("ACH_SEASON10");
		}
		if (s_count_achievement("ACH_SEASON1") >= 20) {
			s_complete_achievement("ACH_SEASON20");
		}
		week = 1;
		last_week_regular = 18;
		first_week_playoffs = 19;
		s_college_shorter_season();
		year += 1;
		gamestarts = 0;
		done_season_review = false;
		qb_new_offer = -1;
		s_update_all_teams_reputation(year);
		for (var i = 0; i < ds_list_size(schedule); i++) {
			ds_map_destroy(ds_list_find_value(schedule, i));
			ds_list_set(schedule, i, -1);
		}
		for (var i = 0; i < ds_list_size(fixturelist); i++) {
			ds_map_destroy(ds_list_find_value(fixturelist, i));
			ds_list_set(fixturelist, i, -1);
		}
		for (var i = 0; i < ds_list_size(playoffs); i++) {
			ds_map_destroy(ds_list_find_value(playoffs, i));
			ds_list_set(playoffs, i, -1);
		}
		ds_list_destroy(playoffs);
		ds_list_destroy(schedule);
		ds_list_destroy(fixturelist);
		playoffs = -1;
		schedule = -1;
		fixturelist = -1;
		playoffs = ds_list_create();
		schedule = s_load_schedule();
		fixturelist = s_create_my_fixture_list();
		ds_list_clear(list_teams_rejected);
		var msg = s_str("msg_NewSeason");
		if (s_is_co_mode()) {
			var rc_amount = 10;
			if (year == 2) {
				slog("First RC new season award. Ensuring at least 25RC. Current[" + string(obj_master.recruitment_credits) + "]");
				if (obj_master.recruitment_credits + rc_amount < 25) {
					rc_amount += 25 - (obj_master.recruitment_credits + rc_amount);
				}
			}
			if (can_fit_recruitment_credits(rc_amount)) {
				msg = string_replace(s_str("msg_NewSeasonCollege"), "$num", rc_amount);
				recruitment_credits_add(rc_amount);
			} else {
				var rc_space = recruitment_credits_space();
				if (rc_space == 0) {
					msg = string_replace(s_str("msg_NewSeasonCollege_Zero"), "$maxNum", rc_amount);
				} else {
					msg = string_replace(s_str("msg_NewSeasonCollege_NoSpace"), "$maxNum", rc_amount);
					msg = string_replace(msg, "$num", rc_space);
				}
				recruitment_credits_add(rc_amount);
			}
			college_awards_done = false;
			non_champ_conferences_resolved = false;
		}
		s_add_news(msg);
		draft_round = 1;
		draft_entered = false;
		if (s_is_co_mode()) {
			college_admissions_draft_round = 1;
		}
		for (var i = 0; i < ds_list_size(teamlist); i++) {
			var team = ds_list_find_value(obj_master.teamlist, i);
			ds_map_set(team, "wins", 0);
			ds_map_set(team, "losses", 0);
			ds_map_set(team, "ties", 0);
			ds_map_set(team, "old_rating", ds_map_find_value(team, "offense") + ds_map_find_value(team, "defense"));
			if (ds_map_find_value(team, "defense") + ds_map_find_value(team, "offense") < 9) {
				ds_map_set(team, "defense", clamp(real(ds_map_find_value(team, "defense")) + 1 + irandom(2), 1, 10));
				ds_map_set(team, "offense", clamp(real(ds_map_find_value(team, "offense")) + 1 + irandom(2), 1, 10));
			} else if (ds_map_find_value(team, "defense") + ds_map_find_value(team, "offense") > 15) {
				ds_map_set(team, "defense", clamp(real(ds_map_find_value(team, "defense")) + irandom_range(-2, 1), 1, 10));
				ds_map_set(team, "offense", clamp(real(ds_map_find_value(team, "offense")) + irandom_range(-2, 1), 1, 10));
			} else {
				ds_map_set(team, "defense", clamp(real(ds_map_find_value(team, "defense")) + irandom_range(-2, 2), 1, 10));
				ds_map_set(team, "offense", clamp(real(ds_map_find_value(team, "offense")) + irandom_range(-2, 2), 1, 10));
			}
		}
		s_refactor_team_strengths();
		s_co_reset_teams_rank();
		s_co_conference_stats();
		s_competitions_status_update();
		s_update_contracts();
		if (qb_mode) {
			s_renew_contracts_qb_mode();
		}
		if (!_arg0 && year > 2) {
			s_decline_facilities();
			if (fans > 80) {
				fans = clamp(fans * 0.75, 10, 100);
				s_add_news(s_str("msg_FansGood" + string(1 + irandom(2))));
			} else if (fans > 50) {
				fans = clamp(fans * 0.85, 10, 100);
				s_add_news(s_str("msg_FansBad" + string(1 + irandom(2))));
			}
			if (s_get_morale() > 65) {
				s_adjust_team_morale(-5, -15);
				s_add_news(s_str("msg_MoraleDown"));
			}
		}
		s_clear_storelist();
		s_create_storelist(false);
		s_reset_staff_hire_list(false);
		room_goto(rm_home);
		stage = 1;
	}
}

function s_renew_contracts_qb_mode() {
	with (obj_master) {
		if (ds_list_size(freeagentlist)) {
			for (var i = 0; i < ds_list_size(freeagentlist); i++) {
				var pmap = ds_list_find_value(freeagentlist, i);
				if (!irandom(2)) {
					s_do_contract_news(s_str("news_QB_contract_playerleaves" + choose("1", "2")), pmap);
				} else {
					s_do_contract_news(s_str("news_QB_contract_playersigns"), pmap);
					ds_list_add(roster, pmap);
					ds_list_delete(freeagentlist, ds_list_find_index(freeagentlist, pmap));
				}
			}
			for (var i = 0; i < ds_list_size(freeagentlist); i++) {
				ds_map_destroy(ds_list_find_value(freeagentlist, i));
				ds_list_set(freeagentlist, i, -1);
			}
			ds_list_clear(freeagentlist);
		}
	}
}

