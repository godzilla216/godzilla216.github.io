function btn_click_PlayOffsSkip() {
	with (obj_master) {
		while (!s_get_human_fixture_by_week(week) && week <= s_get_week_superbowl()) {
			slog("SKIP PLAY-OFFS wk=" + string(week));
			if (!s_do_schedule(false)) {
				return;
			}
			week++;
		}
		week--;
		var sz = 0;
		if (week >= s_get_week_superbowl()) {
			sz = 1;
			if (year > 1) {
				sz++;
			}
		}
		if (obj_master.fr_mode || s_is_co_mode()) {
			while (ds_list_size(newslist) > sz) {
				ds_list_delete(newslist, 0);
			}
		} else {
			while (ds_list_size(list_news_dyn) > sz) {
				ds_list_delete(list_news_dyn, 0);
			}
		}
		playoff_proceed = false;
		stage = 7;
		s_play(1);
	}
}

