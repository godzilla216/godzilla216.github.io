function s_do_result_news() {
	slog("s_do_result_news");
	slog("Year=" + string(year));
	slog("Week=" + string(week));
	with (obj_master) {
		if (qb_mode) {
			s_do_result_news_qb();
			return;
		}
		var fix = s_get_human_fixture_previous();
		if (fix) {
			var news = "";
			if (year == 1 && week == first_week_playoffs) {
				switch (ds_map_find_value(fix, "human_win")) {
					case "win":
						news = "news_firstmatchWin";
						break;
					case "loss":
						news = "news_firstmatchLoss";
						break;
					case "tie":
						news = "news_firstmatchTie";
						break;
				}
			}
			var oppteamid = ds_map_find_value(fix, "away_team");
			if (oppteamid == myteam_id) {
				oppteamid = ds_map_find_value(fix, "home_team");
			}
			var oppteam = s_get_team_by_id(oppteamid);
			if (news != "") {
				s_add_news(s_parse_news(news, myteam, oppteam, 0, 0));
			}
		}
	}
}

