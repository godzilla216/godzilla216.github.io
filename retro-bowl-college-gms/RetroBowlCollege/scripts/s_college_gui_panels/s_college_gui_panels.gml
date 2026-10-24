function s_co_subdivision_create(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = 14;
	}
	instance_create_layer(_arg0.x, _arg0.y, _arg0.layer, obj_blank, {
		sprite_index: spr_box_flex,
		image_xscale: _arg0.w / 16,
		image_yscale: _arg0.h / 16,
		title: s_get_my_subdivision_string(_arg1) + " " + s_str("ui_Rankings"),
		action_create: s_co_subdivision_init,
		action_draw_gui: s_co_division_draw_gui,
		_lines: _arg2,
		_line_height: 12.5,
		_columns: 1,
		_mode_label: false,
		conference: _arg1,
		mode: 2,
		_tier: _arg1.tier
	});
}

function s_co_subdivision_init() {
	if (!s_is_co_mode()) {
		return;
	}
	slogf("College populate subdivision: %1 (%2)", title, _tier);
	s_set_var_if_missing("_show_prev_rank", false);
	if (s_is_preseason_for_ranking()) {
		action_draw_gui = s_co_subdivision_hidden_draw_gui;
	}
	alpha = 1;
	var myid = obj_master.myteam_id;
	if (s_season_competitions_done()) {
		_teams = [];
		array_copy(_teams, 0, obj_master.subdiv_data[_tier].rankings, 0, array_length(obj_master.subdiv_data[_tier].rankings));
		array_sort(_teams, s_co_teams_data_sort_rank);
		s_team_data_array_add_formatted_data(_teams, myid, true);
		_show_prev_rank = true && room != rm_post_match;
	} else {
		s_subdivision_update_rankings(_tier, obj_master.week == 1);
		_teams = obj_master.subdiv_data[_tier].rankings;
		s_team_data_array_add_formatted_data(_teams, myid);
	}
	_my_team_data = s_get_struct_in_array_by_uid(_teams, myid);
	_my_place = array_get_index(_teams, _my_team_data);
	_conf_stats = true;
	if (_my_team_data) {
		_my_team_data.txt_col = global.c_primary;
	}
	if (_tier == 1) {
		_highlight_playoffs = true;
	}
	_split_view = _my_place > _lines * _columns - 1;
	s_panel_scroll_init((array_length(_teams) + 1) * _line_height + 4);
}

function s_co_subdivision_hidden_draw_gui() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, 16777215, 1);
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_hd_text(240, y + sprite_height / 2, s_str_u("msg_PreSeasonRankings"));
}

function s_co_division_create(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (_arg3 == undefined) {
		_arg3 = 4;
	}
	if (_arg4 == undefined) {
		_arg4 = 1;
	}
	if (!s_is_co_mode()) {
		return;
	}
	with (_arg0) {
		_conference = _arg1;
		_division = _arg2;
		_lines = _arg3;
		_columns = _arg4;
		mode = 0;
		s_co_division_init();
	}
}

function s_co_division_init() {
	if (!s_is_co_mode()) {
		return;
	}
	var my_id = obj_master.myteam_id;
	var my_conf = ds_map_find_value(obj_master.myteam, "conference");
	var my_div = ds_map_find_value(obj_master.myteam, "division");
	slog("s_co_division_init my_conf: " + string(my_conf) + " my_div: " + string(my_div) + " myteam_id: " + string(my_id));
	title = s_get_my_conference_division_string(_conference, _division);
	slogf("College populate division: %1 (%2,%3)", title, _conference, _division);
	alpha = 0.6;
	if (_conference == my_conf && _division == my_div) {
		alpha = 1;
	}
	_teams = s_get_team_list(_conference, _division);
	_teams = s_create_team_data_array(_teams);
	s_team_data_array_add_formatted_data(_teams, my_id);
	array_sort(_teams, s_co_teams_data_sort_pct);
	_my_team_data = s_get_struct_in_array_by_uid(_teams, my_id);
	_my_place = array_get_index(_teams, _my_team_data);
	_conf_stats = !s_is_independent_conference_id(_conference);
	if (!_conf_stats && mode == 0) {
		mode = 2;
	}
	if (_my_team_data) {
		_my_team_data.txt_col = global.c_primary;
	}
	_line_height = 15.5;
	_mode_label = true;
	_split_view = _my_place > _lines * _columns - 1;
	s_panel_scroll_init(array_length(_teams) * _line_height + 4);
	_title_space = sprite_width / _columns - 16 - 16 - 56 - (_mode_label ? 32 : 0) - (_scroll ? 10 : 0);
	slogf("title space: %1", _title_space);
	title = s_fit_string(title, s_get_my_conference_division_string(_conference, _division, true), _title_space);
}

function s_co_division_step() {
	s_panel_scroll_step();
}

function s_fit_string(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = global.fnt_small_flex;
	}
	draw_set_font(_arg3);
	if (string_hd_width(_arg0) <= _arg2) {
		return _arg0;
	}
	return _arg1;
}

function s_co_division_draw_gui() {
	if (!s_is_co_mode()) {
		return;
	}
	if (!variable_instance_exists(id, "_teams") || is_undefined(_teams)) {
		return;
	}
	s_set_var_if_missing("active", true);
	s_set_var_if_missing("clicked", false);
	s_set_var_if_missing("_show_prev_rank", false);
	s_set_var_if_missing("_debug_rank", false);
	s_set_var_if_missing("_highlight_playoffs", false);
	var gx = x;
	var gy = y;
	if (clicked && variable_instance_exists(id, "onClickAction") && onClickAction != -4) {
		gx -= 2;
		gy += 2;
	}
	if (!clicked && variable_instance_exists(id, "onClickAction") && onClickAction != -4) {
		draw_sprite_ext(sprite_index, image_index, gx - 2, gy + 2, image_xscale, image_yscale, 0, global.c_shadow, alpha);
	}
	draw_rectangle_color(gx + 2, gy, gx + 2 + sprite_width - 4, gy + 2 + sprite_height - 4, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_sprite_ext(sprite_index, image_index, gx, gy, image_xscale, image_yscale, 0, 16777215, alpha);
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(0);
	var tx = gx;
	var ty = gy;
	var sw = 2 + string_hd_width(title);
	var sh = string_hd_height(title) / 2;
	var pw = sprite_width / _columns;
	var tb = [gx, gx + pw];
	tx += 16;
	draw_set_alpha(alpha);
	draw_hd_text(tx, ty, string_upper(title), true);
	for (var c = 0; c < _columns; c++) {
		draw_set_halign(1);
		tx = tb[c] + pw - (_scroll ? 66 : 56);
		ty = gy;
		switch (mode) {
			case 1:
				if (_mode_label) {
					draw_hd_text(tx - 32, ty, string_upper(s_str("tla_Conference")), true);
				}
				draw_hd_text(tx, ty, string_upper(s_str("tla_Percentage")), true);
				tx += 35;
				draw_hd_text(tx, ty, string_upper(s_str("tla_NetPoints")), true);
				break;
			case 3:
				if (_mode_label) {
					draw_hd_text(tx - 32, ty, string_upper(s_str("tla_Overall")), true);
				}
				draw_hd_text(tx, ty, string_upper(s_str("tla_Percentage")), true);
				tx += 35;
				draw_hd_text(tx, ty, string_upper(s_str("tla_NetPoints")), true);
				break;
			case 0:
				if (_mode_label) {
					draw_hd_text(tx - 32, ty, string_upper(s_str("tla_Conference")), true);
				}
				draw_hd_text(tx, ty, s_str("sla_Wins"), true);
				tx += 35;
				draw_hd_text(tx, ty, s_str("sla_Losses"), true);
				break;
			case 2:
				if (_mode_label) {
					draw_hd_text(tx - 32, ty, string_upper(s_str("tla_Overall")), true);
				}
				draw_hd_text(tx, ty, s_str("sla_Wins"), true);
				tx += 35;
				draw_hd_text(tx, ty, s_str("sla_Losses"), true);
				break;
			case 4:
				draw_hd_text(tx, ty, string_upper(s_str("tla_Offense")), true);
				tx += 35;
				draw_hd_text(tx, ty, string_upper(s_str("tla_Defense")), true);
				break;
		}
		if (_debug_rank) {
			draw_set_halign(0);
			draw_hd_text_color(gx - 90, gy, string(s_get_ranking_pos_last_season()) + (s_is_preseason_for_ranking() ? " - preseason" : ""), 16777215, 16777215, 16777215, 16777215, 0.3);
		}
		if (_scroll) {
			_split_view = false;
		}
		ty = gy + 16 + _scroll_y;
		var td, tc;
		var lc = array_length(_teams);
		for (var t = 0 + _lines * c; t < (_split_view || _scroll ? lc : min(lc, _lines * (c + 1))); t++) {
			td = _teams[t];
			tc = td.txt_col;
			if (_highlight_playoffs && t < 4) {
				if (tc == 16777215) {
					tc = global.c_highlight;
				}
			}
			tx = tb[c] + 16;
			if (_scroll || t < _lines * _columns && !_split_view || t < _lines * _columns - 3 && _split_view || _my_place == t || _my_place - 1 == t) {
				if (_split_view && _my_place - 1 == t) {
					draw_rectangle_color(tx, ty - 1, tx + sprite_width - 32, ty - 0, 16777215, 16777215, 16777215, 16777215, 0);
					ty += _line_height;
				}
				if (s_panel_scroll_is_inside(ty)) {
					draw_set_halign(0);
					if (_show_prev_rank) {
						draw_hd_text_color(tx, ty, td.rank_s, tc, tc, tc, tc, alpha);
					}
					if (_conf_stats && !_show_prev_rank) {
						draw_hd_text_color(tx, ty, string(t + 1), tc, tc, tc, tc, alpha);
					}
					draw_hd_text_color(tx + (_conf_stats ? 24 : 0) + (_show_prev_rank ? 36 : 0), ty, string_upper(td.name), tc, tc, tc, tc, alpha);
					tx = tb[c] + pw - (_scroll ? 66 : 56);
					draw_set_halign(1);
					switch (mode) {
						case 1:
							draw_hd_text_color(tx, ty, td.show_cnf_stats ? td.pct_cnf_s : "-", tc, tc, tc, tc, alpha);
							tx += 35;
							draw_hd_text_color(tx, ty, td.show_cnf_stats ? td.net : "-", tc, tc, tc, tc, alpha);
							break;
						case 3:
							draw_hd_text_color(tx, ty, td.pct_s, tc, tc, tc, tc, alpha);
							tx += 35;
							draw_hd_text_color(tx, ty, td.net, tc, tc, tc, tc, alpha);
							break;
						case 0:
							draw_hd_text_color(tx, ty, td.show_cnf_stats ? td.wins_cnf : "-", tc, tc, tc, tc, alpha);
							tx += 35;
							draw_hd_text_color(tx, ty, td.show_cnf_stats ? td.losses_cnf : "-", tc, tc, tc, tc, alpha);
							break;
						case 2:
							draw_hd_text_color(tx, ty, td.wins, tc, tc, tc, tc, alpha);
							tx += 35;
							draw_hd_text_color(tx, ty, td.losses, tc, tc, tc, tc, alpha);
							break;
						case 4:
							draw_hd_text_color(tx, ty, td.offense_s, tc, tc, tc, tc, alpha);
							tx += 35;
							draw_hd_text_color(tx, ty, td.defense_s, tc, tc, tc, tc, alpha);
							break;
					}
					if (_debug_rank) {
						draw_set_halign(0);
						draw_hd_text_color(gx - 90, ty, td.rank_pts_prev, tc, tc, tc, tc, 0.3);
						draw_hd_text_color(gx - 60, ty, td.rank_pts, tc, tc, tc, tc, 0.3);
						draw_hd_text_color(gx - 30, ty, td.rank_season, tc, tc, tc, tc, 0.3);
						draw_hd_text_color(tx + 40, ty, ds_map_find_value(td.team, "reputation"), tc, tc, tc, tc, 0.3);
					}
				}
				ty += _line_height;
			}
		}
	}
	s_panel_scroll_draw_gui();
	draw_set_alpha(1);
}

