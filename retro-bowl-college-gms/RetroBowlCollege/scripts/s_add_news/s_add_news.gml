function s_add_news(_arg0) {
	if (obj_master.qb_mode) {
		s_add_news_dyn("web", _arg0, s_get_qb_pmap(), false);
	} else {
		ds_list_add(obj_master.newslist, _arg0);
	}
}

function s_add_news_if_new(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.newslist); i++) {
		var oldMsg = ds_list_find_value(obj_master.newslist, i);
		if (oldMsg == _arg0) {
			slog("skip news[" + string(_arg0) + "]");
			return;
		}
	}
	s_add_news(_arg0);
}

function s_remove_news(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.newslist); i++) {
		var oldMsg = ds_list_find_value(obj_master.newslist, i);
		if (oldMsg == _arg0) {
			slog("s_remove_news [" + string(oldMsg) + "] at #" + string(i) + " ");
			ds_list_delete(obj_master.newslist, i);
			return;
		}
	}
}

function s_add_news_dyn(_arg0, _arg1, _arg2, _arg3) {
	if (_arg2 != -4) {
		_arg1 = s_parse_player_message(_arg1, _arg2);
	}
	var news = ds_map_create();
	ds_map_set(news, "typ", _arg0);
	ds_map_set(news, "txt", _arg1);
	ds_map_set(news, "pmap_teamid", -1);
	ds_map_set(news, "pmap_position", -1);
	ds_map_set(news, "pmap_skin", -1);
	ds_map_set(news, "pmap_face_x", -1);
	ds_map_set(news, "pmap_face_y", -1);
	if (_arg2 != -4) {
		ds_map_set(news, "pmap_teamid", real(ds_map_find_value(_arg2, "teamid")));
		ds_map_set(news, "pmap_position", real(ds_map_find_value(_arg2, "position")));
		ds_map_set(news, "pmap_skin", real(ds_map_find_value(_arg2, "skin")));
		ds_map_set(news, "pmap_face_x", real(ds_map_find_value(_arg2, "face_x")));
		ds_map_set(news, "pmap_face_y", real(ds_map_find_value(_arg2, "face_y")));
	}
	ds_list_add(obj_master.list_news_dyn, news);
	slog("Added dynamic news: " + _arg1);
	if (_arg3) {
		s_check_for_news();
	}
}

