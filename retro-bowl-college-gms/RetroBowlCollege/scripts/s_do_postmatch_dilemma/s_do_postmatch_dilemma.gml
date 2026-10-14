function s_do_postmatch_dilemma() {
	with (obj_master) {
		if (qb_mode && s_qb_mode_benched_status()) {
			s_play(1);
			return;
		}
		var pmap = s_get_random_player(false);
		var msg = "";
		var fixture = s_get_human_fixture_by_week(week);
		if (week > 4 && week < s_get_week_superbowl() && pmap && ds_map_find_value(pmap, "attitude") <= 15) {
			msg = s_choose_dilemma("postmatch_toxic");
		} else if (pmap && s_get_match_rating(pmap) > 7) {
			msg = s_choose_dilemma("postmatch_performance_good");
		} else if (week < s_get_week_superbowl() && pmap && s_get_match_rating(pmap) < 4) {
			msg = s_choose_dilemma("postmatch_performance_bad");
		} else if (pmap && !irandom(4)) {
			if (irandom(4)) {
				msg = s_choose_dilemma("postmatch_question_player");
			} else {
				pmap = s_get_random_coach();
				msg = s_choose_dilemma("postmatch_question_staff");
			}
		} else if (ds_map_find_value(fixture, "human_win") == "loss") {
			msg = s_choose_dilemma("postmatch_loss");
		} else if (ds_map_find_value(fixture, "human_win") == "win") {
			msg = s_choose_dilemma("postmatch_win");
		} else if (pmap) {
			msg = s_choose_dilemma("postmatch_question_player");
		}
		if (msg != "") {
			ds_map_clear(map_dilemma);
			map_dilemma = s_parse_dilemma(msg, pmap, "ui_PressInterview");
			obj_master.player_profile = pmap;
			s_create_dilemma(map_dilemma);
		} else {
			s_play(1);
		}
	}
}

