function s_rm_postseason_init() {
	s_init_rm();
	btns = [];
	mode = 3;
	s_create_title(s_str("ui_League"), undefined, true);
	b_back = s_create_button(8, 232, { image: spr_arrowL, onClickAction: s_postseason_goto_home });
	b_skip = s_create_button(282, 232, {
		text: s_str("ui_Skip"),
		mode: 2,
		onClickAction: s_btn_postseason_skip_loading,
		image_xscale: 2.8125,
		visible: !s_is_human_in_week(obj_master.week)
	});
	b_continue = s_create_button(378, 232, { text: s_str("ui_Play"), mode: 3, onClickAction: s_btn_postseason_play, image_xscale: 2.8125 });
	b_left = s_create_button(0, 100, {
		visible: false,
		image: spr_arrowL2,
		add: -1,
		image_only: true,
		onClickAction: s_league_btn_week,
		gp_mapped_button: 32773
	}, obj_button_sqr);
	b_right = s_create_button(448, 100, {
		visible: false,
		image: spr_arrowR2,
		add: 1,
		image_only: true,
		onClickAction: s_league_btn_week,
		gp_mapped_button: 32774
	}, obj_button_sqr);
	b_up = s_create_button(230, 190, { text: s_str("ui_PageUp"), onClickAction: s_league_btn_page, add: -1, image_xscale: 3.125 });
	b_down = s_create_button(340, 190, { text: s_str("ui_PageDown"), onClickAction: s_league_btn_page, add: 1, image_xscale: 3.125 });
	s_league_create_schedule_panels();
}

function s_btn_postseason_skip_loading() {
	s_loading_start(s_btn_postseason_skip);
}

function s_btn_postseason_skip() {
	var is_there_human = s_skip_postseason_until_human_match();
	if (is_there_human) {
		obj_master.stage = 1;
		s_goto_room(rm_home);
	} else {
		slogf("*** show finals");
		s_postseason_show_finals(s_postseason_goto_home);
	}
}

function s_btn_postseason_play() {
	if (s_is_human_in_week(obj_master.week)) {
		slogf("there's a human in ps chunk");
		s_play(0);
	} else {
		var news_week = obj_master.week;
		s_skip_postseason_chunk();
		s_postseason_show_news(news_week, s_postseason_goto_home);
	}
}

function s_postseason_goto_home() {
	slogf("*** postseason go home");
	global.g_m.stage = 1;
	s_play(0);
}

function s_btn_result_postseason_continue(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	s_postseason_show_news(obj_master.week, _arg0);
}

function s_btn_postmatch_co_continue() {
	s_btn_result_postseason_continue(post_click_action);
}

function s_btn_postmatch_co_league() {
	s_btn_result_postseason_continue(post_click_action);
}

function s_postseason_show_news(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = -4;
	}
	if (obj_master.postseason_chunk_news_last_shown == _arg0 || !s_is_co_postseason(_arg0)) {
		slogf("*** postseason news already shown or still in regular season, proceeding");
		s_msg_clear();
		if (_arg1 != -4) {
			_arg1();
		}
	} else {
		slogf("*** show postseason news for %1", s_get_week_name(_arg0));
		obj_master.postseason_chunk_results = s_postseason_results(_arg0);
		obj_master.postseason_chunk_news_post_action = _arg1;
		obj_master.postseason_chunk_news_last_shown = _arg0;
		s_postseason_show_next_result();
	}
}

function s_postseason_show_finals(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	var _week = s_get_last_schedule_week();
	obj_master.postseason_chunk_results = s_postseason_results(_week);
	obj_master.postseason_chunk_news_post_action = _arg0;
	obj_master.postseason_chunk_news_last_shown = _week;
	s_postseason_show_finals_result();
}

function s_postseason_show_next_result() {
	var result = -4;
	if (array_length(obj_master.postseason_chunk_results) > 0) {
		result = obj_master.postseason_chunk_results[0];
		array_delete(obj_master.postseason_chunk_results, 0, 1);
	}
	if (result == -4) {
		if (obj_master.postseason_chunk_news_post_action != -4) {
			obj_master.postseason_chunk_news_post_action();
		}
		return;
	}
	var is_last = result != -4 && array_length(obj_master.postseason_chunk_results) < 1;
	var text;
	switch (result.show) {
		case "std":
			text = result.comp_str + "\n\n" + result.score_str;
			if (result.access_str != "") {
				text += "\n\n" + string_replace(s_str("msg_WillCompete"), "$COMPETITION", result.access_str);
			}
			break;
		case "bkt":
			text = s_str("msg_TeamsAdvance");
			text = string_replace(text, "$LEVEL", s_get_comp_level_str(result.level - 1));
			text = string_replace(text, "$COMPETITION", result.comp_str);
			text += "\n\n" + result.team_names;
			break;
	}
	s_create_message(s_str("ui_News"), text, is_last ? "" : s_str("ui_Skip"), s_str("ui_Continue"), s_btn_postseason_news_skip, s_btn_postseason_news_continue, global.c_background, 1);
}

function s_postseason_show_finals_result() {
	var result = -4;
	var comps_str = "";
	while (array_length(obj_master.postseason_chunk_results) > 0) {
		result = obj_master.postseason_chunk_results[0];
		array_delete(obj_master.postseason_chunk_results, 0, 1);
		comps_str = result.comp_str + "\n\n" + result.score_str + (comps_str != "" ? "\n\n" + comps_str : "");
	}
	s_create_message(s_str("ui_News"), comps_str, "", s_str("ui_Continue"), -4, s_btn_postseason_news_continue, global.c_background, 1);
}

function s_btn_postseason_news_skip() {
	obj_master.postseason_chunk_results = [];
	s_btn_postseason_news_continue();
}

function s_btn_postseason_news_continue() {
	s_msg_clear();
	s_postseason_show_next_result();
}

function s_postseason_results(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = true;
	}
	var results = [];
	var fix;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			if (real(ds_map_find_value(fix, "week")) == _arg0) {
				if (_arg1 && s_is_human_fix(fix)) {
					continue;
				}
				if (!s_is_fix_played(fix)) {
					continue;
				}
				s_create_postseason_result(results, fix);
			}
		}
	}
	array_sort(results, s_postseason_results_data_sort);
	return results;
}

function s_create_postseason_result(_arg0, _arg1) {
	switch (ds_map_find_value(_arg1, "show")) {
		case "std":
			var item = {
				show: ds_map_find_value(_arg1, "show"),
				comp_id: ds_map_find_value(_arg1, "cid"),
				comp_str: s_get_fix_competition_string(_arg1),
				score_str: s_get_fix_result_string(_arg1),
				access_str: s_get_fix_access_string(_arg1),
				sort: real(ds_map_find_value(_arg1, "cid"))
			};
			var at = s_get_team_by_id(ds_map_find_value(_arg1, "away_team"));
			var ht = s_get_team_by_id(ds_map_find_value(_arg1, "home_team"));
			if (ds_map_find_value(at, "conference") == obj_master.myconference || ds_map_find_value(ht, "conference") == obj_master.myconference) {
				item.sort += 10000;
			}
			array_push(_arg0, item);
			break;
		case "bkt":
			var item = s_get_postseason_result_by_cid(_arg0, ds_map_find_value(_arg1, "cid"));
			if (item == -4) {
				item = {
					show: ds_map_find_value(_arg1, "show"),
					level: array_get(string_split(ds_map_find_value(_arg1, "mid"), "."), 0),
					comp_id: ds_map_find_value(_arg1, "cid"),
					comp_str: s_get_fix_competition_string(_arg1),
					team_names: s_get_team_name_by_id(s_get_fix_winner_id(_arg1)),
					sort: 1000
				};
				array_push(_arg0, item);
			} else {
				item.team_names += "\n" + s_get_team_name_by_id(s_get_fix_winner_id(_arg1));
			}
			break;
	}
}

function s_postseason_results_data_sort(_arg0, _arg1) {
	return real(_arg1.sort) - real(_arg0.sort);
}

function s_get_postseason_result_by_cid(_arg0, _arg1) {
	for (var i = 0; i < array_length(_arg0); i++) {
		if (_arg0[i].comp_id == _arg1) {
			return _arg0[i];
		}
	}
	return -4;
}

function s_get_competition_win_access(_arg0) {
	var list = s_get_competition_win_access_list();
	return s_get_struct_in_array_by_uid(list, _arg0);
}

function s_get_fix_access_string(_arg0) {
	var aid = s_get_competition_win_access(ds_map_find_value(_arg0, "cid"));
	if (aid != -4) {
		return s_get_competition_string(aid.access);
	}
	return "";
}

function s_get_fix_result_string(_arg0) {
	var t1, t2, s1, s2, fmt;
	s1 = real(ds_map_find_value(_arg0, "away_score"));
	s2 = real(ds_map_find_value(_arg0, "home_score"));
	t1 = s_get_team_by_id(ds_map_find_value(_arg0, "away_team"));
	t2 = s_get_team_by_id(ds_map_find_value(_arg0, "home_team"));
	fmt = s1 > s2 ? "%1 %5 %2 %3-%4!" : "%2 %5 %1 %4-%3!";
	return s_strfl(fmt, ds_map_find_value(t1, "name"), ds_map_find_value(t2, "name"), s1, s2, s_str("ui_beat"));
}

function s_skip_postseason_until_human_match() {
	with (obj_master) {
		while (week <= s_get_last_schedule_week()) {
			if (s_is_human_in_week(week)) {
				return true;
			} else {
				s_skip_postseason_chunk();
			}
		}
		return false;
	}
}

function s_skip_postseason_chunk() {
	with (obj_master) {
		s_do_schedule(true);
		week++;
		s_competitions_status_update();
	}
}

