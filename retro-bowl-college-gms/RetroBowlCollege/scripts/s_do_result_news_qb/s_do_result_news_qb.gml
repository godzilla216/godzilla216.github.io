function s_do_result_news_qb() {
	var fix = s_get_human_fixture_previous();
	if (fix) {
		var pmap = s_get_qb_pmap();
		var news = "";
		if (year == 1 && ds_map_find_value(fix, "week") == 1) {
			switch (ds_map_find_value(fix, "human_win")) {
				case "win":
					news = "news_qb_postgame1_win";
					break;
				case "loss":
					news = "news_qb_postgame1_loss";
					break;
				case "tie":
					news = "news_qb_postgame1_tie";
					break;
			}
		} else if (ds_map_find_value(fix, "human_win") == "win") {
			if (s_get_match_rating(pmap) > 0) {
				news = ds_map_find_value(pmap, "age") == s_rookie_age_internal() ? s_choose_news("news_starman_vet") : s_choose_news("news_starman_vet");
			}
		}
		if (news != "") {
			s_add_news(s_parse_player_message(s_str(news), pmap));
		}
	}
}

function s_choose_news(_arg0) {
	with (obj_master) {
		ds_list_shuffle(news_tags);
		for (var i = 0; i < ds_list_size(news_tags); i++) {
			var str = ds_list_find_value(news_tags, i);
			if (string_count(_arg0, str)) {
				ds_list_delete(news_tags, i);
				return str;
			}
		}
		slog("Repopulate dilemma_tags...");
		s_add_tag_matches_to_list(news_tags, _arg0, s_select_lang_file());
		s_add_tag_matches_to_list(news_tags, _arg0, s_select_override_lang_file());
		return s_choose_news(_arg0);
	}
}

