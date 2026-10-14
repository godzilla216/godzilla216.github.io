function s_check_for_news() {
	with (obj_master) {
		if (obj_master.qb_mode) {
			if (ds_list_size(list_news_dyn) > 0) {
				var news = ds_list_find_value(list_news_dyn, 0);
				if (news) {
					if (ds_map_find_value(news, "typ") == "msg") {
						s_create_message(s_str("ui_News"), ds_map_find_value(news, "txt"), "", s_str("ui_Continue"), "", s_news_clear, global.c_background, 1);
					} else {
						s_create_news_dyn_message(news);
					}
				}
				ds_list_delete(list_news_dyn, 0);
				return;
			}
		} else if (ds_list_size(newslist) > 0) {
			s_create_message(s_str("ui_News"), ds_list_find_value(newslist, 0), "", s_str("ui_Continue"), "", s_news_clear, global.c_background, 1);
			ds_list_delete(newslist, 0);
			return;
		}
	}
	s_check_intro();
}

