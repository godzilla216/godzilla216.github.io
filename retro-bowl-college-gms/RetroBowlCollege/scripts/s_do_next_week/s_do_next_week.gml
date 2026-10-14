function s_do_next_week() {
	slog("s_do_next_week");
	var facilities_week = 9;
	var contracts_week = 16;
	with (obj_master) {
		week++;
		offers_done = false;
		fans_done_update = false;
		prematch_dilemma_done = false;
		prematch_dilemma_shown_count = 0;
		ds_list_clear(prematch_dilemma_chosen_players);
		boost_morale_done = false;
		boost_condition_done = false;
		boost_gpa_done = false;
		if (qb_mode) {
			s_degrade_shop_items();
			s_qb_mode_update_resting();
		}
		s_clear_trade_offers();
		s_reset_player_meetings();
		s_do_result_news();
		if (week == facilities_week) {
			s_decline_facilities();
		}
		if (week == obj_master.first_week_playoffs && !s_is_co_mode()) {
			s_create_playoffs2();
		}
		s_competitions_status_update();
		s_create_hirelist(true, false);
		s_create_storelist(1 + irandom(2));
		if (!qb_mode) {
			if (week == contracts_week) {
				s_check_contracts_expiring();
			}
			if (week == 8 && !s_is_co_mode()) {
				s_add_news(s_str("msg_TradeDeadline"));
			}
		}
		s_savegame();
		slog(">>>>> NEW WEEK = " + string(week));
	}
}

