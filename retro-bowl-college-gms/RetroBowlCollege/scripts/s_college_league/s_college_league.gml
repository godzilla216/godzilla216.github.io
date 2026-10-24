function s_rm_league_co_init() {
	s_init_rm();
	btns = [];
	s_create_title(s_str("ui_League"), undefined, true);
	b_home = s_create_button(8, 232, { image: s_league_get_btn_back_image(), onClickAction: btn_click_League_Back });
	b_view = s_create_button(45, 232, { text: s_str("ui_View"), onClickAction: s_btn_league_view, image_xscale: 1.25 });
	b_conf = s_create_button(90, 232, { text: s_str("ui_Conference"), mode: 0, onClickAction: s_btn_league_mode, image_xscale: 2.8125 });
	b_rank = s_create_button(186, 232, { text: s_str("ui_Ranking"), mode: 1, onClickAction: s_btn_league_mode, image_xscale: 2.8125 });
	b_schd = s_create_button(282, 232, { text: s_str("ui_Schedule"), mode: 2, onClickAction: s_btn_league_mode, image_xscale: 2.8125 });
	b_pssn = s_create_button(378, 232, { text: s_str("ui_Postseason"), mode: 3, onClickAction: s_btn_league_mode, image_xscale: 2.8125 });
	s_set_league_mode_btn_colour([b_conf, b_rank, b_schd, b_pssn]);
	switch (mode) {
		case 0:
			s_set_var_if_missing("tier", 0);
			s_set_var_if_missing("confd", s_get_conference_data(s_get_my_conference_uid()));
			b_ours = s_create_button(80, 32, { text: s_fit_string(confd.name, confd.tla, 96), tier: 0, onClickAction: -4, image_xscale: 3.125 });
			b_major = s_create_button(190, 32, {
				text: s_get_subdiv_name(1),
				tier: 1,
				onClickAction: s_btn_league_subdivision,
				image_xscale: 3.125
			});
			b_minor = s_create_button(300, 32, {
				text: s_get_subdiv_name(2),
				tier: 2,
				onClickAction: s_btn_league_subdivision,
				image_xscale: 3.125
			});
			b_left = s_create_button(-4, 130, {
				visible: false,
				image: spr_arrowL2,
				add: -1,
				image_only: true,
				onClickAction: s_btn_league_next_conference,
				gp_mapped_button: 32773
			}, obj_button_sqr);
			b_right = s_create_button(450, 130, {
				visible: false,
				image: spr_arrowR2,
				add: 1,
				image_only: true,
				onClickAction: s_btn_league_next_conference,
				gp_mapped_button: 32774
			}, obj_button_sqr);
			switch (tier) {
				case 0:
					s_league_create_conference_panels(confd, tier);
					s_set_league_tier_btn_colour([b_ours, b_major, b_minor]);
					break;
				case 1:
				case 2:
					s_set_var_if_missing("conf_chosen", false);
					s_league_refresh_subdivision();
					break;
			}
			break;
		case 1:
			s_set_var_if_missing("tier", s_get_subdivision(global.g_m.myteam));
			b_major = s_create_button(135, 32, {
				text: s_get_subdiv_name(1),
				tier: 1,
				onClickAction: s_btn_league_subdivision,
				image_xscale: 3.125
			});
			b_minor = s_create_button(245, 32, {
				text: s_get_subdiv_name(2),
				tier: 2,
				onClickAction: s_btn_league_subdivision,
				image_xscale: 3.125
			});
			s_set_league_tier_btn_colour([b_major, b_minor]);
			s_league_create_ranking_panels(tier);
			break;
		case 2:
		case 3:
			b_left = s_create_button(0, 100, {
				image: spr_arrowL2,
				add: -1,
				image_only: true,
				onClickAction: s_league_btn_week,
				gp_mapped_button: 32773
			}, obj_button_sqr);
			b_right = s_create_button(448, 100, {
				image: spr_arrowR2,
				add: 1,
				image_only: true,
				onClickAction: s_league_btn_week,
				gp_mapped_button: 32774
			}, obj_button_sqr);
			b_revw = s_create_button(30, 190, { text: s_str("ui_Review"), onClickAction: btn_click_SeasonReview, image_xscale: 3.125 });
			b_up = s_create_button(230, 190, { text: s_str("ui_PageUp"), onClickAction: s_league_btn_page, add: -1, image_xscale: 3.125 });
			b_down = s_create_button(340, 190, { text: s_str("ui_PageDown"), onClickAction: s_league_btn_page, add: 1, image_xscale: 3.125 });
			b_view.active = false;
			s_league_create_schedule_panels();
			break;
	}
}

function s_btn_league_view() {
	s_change_panel_division_mode(global.rm.p1);
	s_change_panel_division_mode(global.rm.p2);
}

function s_btn_league_mode() {
	s_goto_room(room, { mode: mode });
}

function s_btn_league_subdivision() {
	s_goto_room(room, { mode: global.rm.mode, tier: tier });
}

function s_btn_division_home_view() {
	s_change_panel_division_mode(_panel);
}

function s_btn_division_postmatch_view() {
	if (variable_instance_exists(self, "_panel")) {
		s_change_panel_division_mode(_panel);
	} else {
		s_change_panel_division_mode();
	}
}

function s_btn_league_next_conference() {
	var cl = s_get_conference_list(global.rm.confd.tier);
	var next = array_get_index(cl, global.rm.confd) + add;
	if (next < 0) {
		next += array_length(cl);
	}
	if (next >= array_length(cl)) {
		next = 0;
	}
	s_goto_room(room, { mode: global.rm.mode, tier: global.rm.tier, confd: cl[next], conf_chosen: true });
}

function s_set_league_mode_btn_colour(_arg0) {
	array_foreach(_arg0, function(_arg0, _arg1) {
		_arg0.colour = _arg0.mode == global.rm.mode ? global.c_primary : global.c_background;
	});
}

function s_set_league_tier_btn_colour(_arg0) {
	array_foreach(_arg0, function(_arg0, _arg1) {
		_arg0.colour = _arg0.tier == global.rm.tier ? global.c_primary : global.c_background;
	});
}

function s_set_var_if_missing(_arg0, _arg1) {
	if (!variable_instance_exists(id, _arg0)) {
		variable_instance_set(id, _arg0, _arg1);
	}
}

function s_league_get_btn_back_image() {
	switch (obj_master.stage) {
		case 3:
		case 5:
			return spr_arrowL;
		default:
			return spr_home;
	}
}

function s_league_refresh_subdivision() {
	with (global.rm) {
		b_view.active = conf_chosen;
		b_conf.visible = false;
		b_rank.visible = false;
		b_schd.visible = false;
		b_pssn.visible = false;
		b_home.image = spr_arrowL;
		b_home.mode = 0;
		b_home.onClickAction = s_btn_league_mode;
		s_destroy_dynamic_buttons(btns);
		if (conf_chosen) {
			s_league_create_conference_panels(confd, tier);
			b_ours.colour = global.c_primary;
		} else {
			btns = s_league_create_conference_buttons(tier);
			b_ours.onClickAction = s_btn_league_mode;
			b_ours.mode = 0;
			s_set_league_tier_btn_colour([b_ours, b_major, b_minor]);
		}
	}
}

function s_league_create_conference_buttons(_arg0) {
	var cl = s_get_conference_list(_arg0);
	var cb = [];
	var t = s_calc_grid_coords(array_length(cl));
	var btn, jo;
	for (var i = 0; i < array_length(cl); i++) {
		btn = s_create_button(t[i].x, t[i].y, {
			text: s_fit_string(cl[i].name, cl[i].tla, 96),
			conference: cl[i],
			tier: _arg0,
			onClickAction: s_league_btn_conference,
			image_xscale: 3.125
		});
		array_push(cb, btn);
	}
	return cb;
}

function s_league_btn_conference() {
	s_goto_room(room, { mode: global.rm.mode, tier: tier, confd: conference, conf_chosen: true });
}

function s_league_create_conference_panels(_arg0, _arg1) {
	var _divisions = _arg0.divisions;
	switch (_divisions) {
		case 2:
			p1 = s_league_create_conference_division(_arg0.uid, 0, 2);
			p2 = s_league_create_conference_division(_arg0.uid, 1, 2);
			break;
		case 1:
			p1 = s_league_create_conference_division(_arg0.uid, 0, 1);
			p2 = -4;
			break;
	}
	with (global.rm) {
		b_left.visible = true;
		b_right.visible = true;
	}
}

function s_league_create_conference_division(_arg0, _arg1, _arg2) {
	if (_arg1 == undefined) {
		_arg1 = 0;
	}
	if (_arg2 == undefined) {
		_arg2 = 2;
	}
	var tl = s_get_team_list(_arg0, _arg1);
	var tc = array_length(tl);
	var tw = tc > 8;
	var cnt = !tw && _arg2 < 2;
	slogf("c:%1 d:%2(%3) t:%4", _arg0, _arg1, _arg2, tc);
	var s = { x1: 20, x2: 250, xc: 135, y: 80, ws: 210, wl: 440, h: 140 };
	var panel = instance_create_layer(_arg1 > 0 ? s.x2 : (cnt ? s.xc : s.x1), s.y, id.layer, obj_blank, {
		sprite_index: spr_box_flex,
		image_xscale: (tw ? s.wl : s.ws) / 16,
		image_yscale: s.h / 16,
		action_create: s_co_division_init,
		action_draw_gui: s_co_division_draw_gui,
		_lines: 8,
		_columns: tw ? 2 : 1,
		_line_height: 15.5,
		_mode_label: false,
		_conference: _arg0,
		_division: _arg1,
		mode: 0
	});
	return panel;
}

function s_league_create_ranking_panels(_arg0) {
	var s = { x: 105, y: 80, w: 270, h: 140 };
	global.rm.p1 = instance_create_layer(s.x, s.y, id.layer, obj_blank, {
		sprite_index: spr_box_flex,
		image_xscale: s.w / 16,
		image_yscale: s.h / 16,
		title: s_co_get_year(),
		action_create: s_co_subdivision_init,
		action_step: s_co_division_step,
		action_draw_gui: s_co_division_draw_gui,
		_lines: 7,
		_columns: 1,
		_line_height: 12.5,
		_mode_label: true,
		_tier: _arg0,
		_scroll: true,
		_show_prev_rank: s_is_prev_rank_visible(),
		_debug_rank: 0,
		mode: 2
	});
	global.rm.p2 = -4;
}

function s_is_prev_rank_visible(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.week;
	}
	return _arg0 > 1 && _arg0 <= obj_master.last_week_regular + obj_master.extra_weeks_endofseason;
}

function s_league_create_schedule_panels() {
	var s = { x: 30, y: 40, w: 420, h: 140 };
	var min_week, max_week, cur_week;
	switch (mode) {
		case 2:
			min_week = 1;
			max_week = obj_master.last_week_regular;
			cur_week = obj_master.week <= obj_master.last_week_regular ? obj_master.week : min_week;
			global.rm.p1 = instance_create_layer(s.x, s.y, id.layer, obj_blank, {
				sprite_index: spr_box_flex,
				image_xscale: s.w / 16,
				image_yscale: s.h / 16,
				action_create: s_co_schedule_init,
				action_step: s_co_schedule_step,
				action_draw_gui: s_co_schedule_draw_gui,
				_lines: 7,
				_columns: 2,
				_line_height: 16,
				_week: cur_week,
				_min_week: min_week,
				_max_week: max_week,
				_page: 0,
				_max_page: 3,
				_mode: mode
			});
			break;
		case 3:
			min_week = obj_master.first_week_postseason;
			max_week = s_get_last_schedule_week();
			cur_week = obj_master.week >= obj_master.first_week_postseason && obj_master.week <= s_get_last_schedule_week() ? obj_master.week : min_week;
			if (s_season_competitions_done()) {
				cur_week = s_get_last_schedule_week();
			}
			global.rm.p1 = instance_create_layer(s.x, s.y, id.layer, obj_blank, {
				sprite_index: spr_box_flex,
				image_xscale: s.w / 16,
				image_yscale: s.h / 16,
				action_create: s_co_schedule_init,
				action_step: s_co_schedule_step,
				action_draw_gui: s_co_schedule_draw_gui,
				_lines: 2,
				_columns: 1,
				_line_height: 60,
				_week: cur_week,
				_min_week: min_week,
				_max_week: max_week,
				_page: 0,
				_max_page: 3,
				_mode: mode
			});
			break;
	}
	global.rm.p2 = -4;
}

function s_co_schedule_init() {
	if (!s_is_co_mode()) {
		return;
	}
	s_set_var_if_missing("active", true);
	s_set_var_if_missing("clicked", false);
	_schedule = [];
	s_co_schedule_filter_format(_schedule, _week, _mode, "std");
	array_sort(_schedule, s_co_schedule_sort_order);
	_playoffs = [];
	if (_mode == 3) {
		s_co_schedule_filter_format(_playoffs, undefined, _mode, "bkt");
	}
	_page = 0;
	_schedule_size = array_length(_schedule);
	_playoffs_size = array_length(_playoffs);
	_max_page_items = _lines * _columns;
	_max_page = ceil(_schedule_size / _max_page_items) - 1;
	_show_bracket = false;
	if (_playoffs_size > 0 && _week >= _playoffs[0].week && _week <= _playoffs[_playoffs_size - 1].week) {
		slogf("Activate bracket page, %1 games : %4 in (%2-%3)", _playoffs_size, _playoffs[0].week, _playoffs[_playoffs_size - 1].week, _week);
		s_set_matchlist_bracket_coords(_playoffs, id);
		_max_page += 2;
		_show_bracket = true;
		if (s_get_subdivision(global.g_m.myteam) == 2) {
			_page = _max_page - 1 + s_league_get_own_bracket_page(_playoffs);
			slogf("FCS, page %1", _page);
		}
	}
	s_co_schedule_refresh();
}

function s_league_btn_week() {
	with (global.rm.p1) {
		_week = clamp(_week + other.add, _min_week, _max_week);
		s_co_schedule_init();
	}
}

function s_league_btn_page() {
	with (global.rm.p1) {
		_page = clamp(_page + other.add, 0, _max_page);
		s_co_schedule_refresh();
	}
}

function s_co_schedule_sort_order(_arg0, _arg1) {
	return _arg1.order - _arg0.order;
}

function s_league_get_own_bracket_page(_arg0) {
	var fix;
	for (var i = 0; i < array_length(_arg0); i++) {
		fix = _arg0[i];
		if ((fix.team_a_id == global.g_m.myteam_id || fix.team_h_id == global.g_m.myteam_id) && fix.pg != 0) {
			return fix.pg;
		}
	}
	return 0;
}

function s_co_schedule_refresh() {
	title = s_strf("%1 (%2/%3)", s_get_week_name(_week), _page + 1, _max_page + 1);
}

function s_co_schedule_step() {
	global.rm.b_left.active = _week > _min_week;
	global.rm.b_right.active = _week < _max_week;
	global.rm.b_up.active = _page > 0;
	global.rm.b_down.active = _page < _max_page;
}

function s_co_schedule_filter_format(_arg0, _arg1, _arg2, _arg3) {
	if (_arg1 == undefined) {
		_arg1 = -4;
	}
	if (_arg3 == undefined) {
		_arg3 = -4;
	}
	for (var f = 0; f < ds_list_size(obj_master.schedule); f++) {
		var fix = ds_list_find_value(obj_master.schedule, f);
		if (_arg1 == -4 || real(ds_map_find_value(fix, "week")) == _arg1) {
			if (_arg3 != -4 && !is_undefined(ds_map_find_value(fix, "show")) && ds_map_find_value(fix, "show") != _arg3) {
				continue;
			}
			if (_arg2 == 3 && is_undefined(ds_map_find_value(fix, "show"))) {
				continue;
			}
			var wf = {};
			wf.week = real(ds_map_find_value(fix, "week"));
			wf.team_a_id = ds_map_find_value(fix, "away_team");
			wf.team_h_id = ds_map_find_value(fix, "home_team");
			wf.score_a = ds_map_find_value(fix, "away_score");
			wf.score_h = ds_map_find_value(fix, "home_score");
			wf.team_a = s_get_team_by_id(wf.team_a_id);
			wf.team_h = s_get_team_by_id(wf.team_h_id);
			wf.played = wf.score_a > -1;
			wf.colour = 16777215;
			wf.alpha = 0.6;
			wf.order = 10000 - s_get_map_real(fix, "cid", 0);
			switch (_arg2) {
				case 2:
					wf.vs = wf.played ? string(wf.score_a) + " " + string(wf.score_h) : s_str("tla_At");
					break;
				case 3:
					wf.competition = s_get_fix_competition_string(fix);
					wf.location = s_get_fix_location_string(fix);
					wf.vs = wf.played ? string(wf.score_a) + " " + string(wf.score_h) : s_str("tla_versus");
					wf.sc = wf.played ? string(wf.score_a) + " " + string(wf.score_h) : "";
					wf.mid = ds_map_find_value(fix, "mid");
					break;
			}
			if (ds_map_find_value(wf.team_a, "conference") == obj_master.myconference || ds_map_find_value(wf.team_h, "conference") == obj_master.myconference) {
				wf.order += 10000;
				wf.alpha = 1;
			}
			if (wf.team_a_id == obj_master.myteam_id || wf.team_h_id == obj_master.myteam_id) {
				wf.order += 10000;
				wf.colour = global.c_primary;
			}
			if (ds_map_find_value(fix, "cat") == "sf") {
				wf.order += 1000;
			}
			array_push(_arg0, wf);
		}
	}
}

function s_set_matchlist_bracket_coords(_arg0, _arg1) {
	var _map = [{ id1: "5.01", id2: "5.05", pg: 0, px: -3, py: -3, dy: 0 }, { id1: "5.02", id2: "5.06", pg: 0, px: -3, py: 3, dy: 0 }, { id1: "5.03", id2: "5.07", pg: 0, px: 3, py: -3, dy: 0 }, { id1: "5.04", id2: "5.08", pg: 0, px: 3, py: 3, dy: 0 }, { id1: "4.01", id2: "4.05", pg: 0, px: -2, py: -2.2, dy: 0 }, { id1: "4.02", id2: "4.06", pg: 0, px: -2, py: 2.2, dy: 0 }, { id1: "4.03", id2: "4.07", pg: 0, px: 2, py: -2.2, dy: 0 }, { id1: "4.04", id2: "4.08", pg: 0, px: 2, py: 2.2, dy: 0 }, { id1: "3.01", id2: "3.03", pg: 0, px: -1, py: 0, dy: 1 }, { id1: "3.02", id2: "3.04", pg: 0, px: 1, py: 0, dy: 1 }, { id1: "2.01", id2: "2.02", pg: 0, px: 0, py: 0, dy: 0 }];
	var pc = {
		x: _arg1.x + _arg1.sprite_width / 2,
		y: _arg1.y + _arg1.sprite_height / 2,
		hw: _arg1.sprite_width / 2 / 3.6,
		hh: _arg1.sprite_height / 2 / 6
	};
	var m, wf;
	for (var i = 0; i < array_length(_arg0); i++) {
		wf = _arg0[i];
		m = s_get_bracket_map_entry(_map, wf.mid);
		if (m) {
			wf.pg = m.pg;
			wf.px = pc.x + m.px * pc.hw;
			wf.py = pc.y + m.py * pc.hh;
			wf.dy = m.dy;
		} else {
			wf.pg = -1;
		}
	}
}

function s_get_bracket_map_entry(_arg0, _arg1) {
	for (var i = 0; i < array_length(_arg0); i++) {
		if (_arg0[i].id1 == _arg1 || _arg0[i].id2 == _arg1) {
			_arg0[i].pg = _arg0[i].id1 == _arg1 ? 0 : 1;
			return _arg0[i];
		}
	}
	return -4;
}

function s_co_schedule_draw_gui() {
	if (!s_is_co_mode()) {
		return;
	}
	var gx = x;
	var gy = y;
	if (active) {
		draw_sprite_ext(sprite_index, image_index, x - 2, y + 2, 1, 1, 0, global.c_shadow, 1);
	}
	var tx = gx;
	var ty = gy;
	draw_rectangle_color(tx + 2, ty, tx + 2 + sprite_width - 4, ty + 2 + sprite_height - 4, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_sprite_ext(sprite_index, image_index, tx, ty, image_xscale, image_yscale, 0, 16777215, 1);
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	var sw = string_hd_width(title);
	var sh = 4;
	draw_hd_text(tx + sprite_width / 2, ty, title, true);
	var j = 0;
	var c = 0;
	var ttx = [gx + sprite_width / 4, gx + sprite_width / 4 * 3];
	var tty;
	var fix;
	for (var i = _max_page_items * _page; i < min(_schedule_size, _max_page_items * (_page + 1)); i++) {
		fix = _schedule[i];
		switch (_mode) {
			case 2:
				tty = gy + 20 + j * _line_height;
				draw_set_alpha(fix.alpha);
				draw_set_color(fix.colour);
				draw_set_halign(1);
				draw_hd_text(ttx[c], tty, fix.vs);
				draw_set_halign(2);
				draw_hd_text(ttx[c] - 40, tty, ds_map_find_value(fix.team_a, "tla"));
				draw_set_halign(0);
				draw_hd_text(ttx[c] + 40, tty, ds_map_find_value(fix.team_h, "tla"));
				break;
			case 3:
				tx = gx + sprite_width / 2;
				tty = gy + 24 + j * _line_height;
				draw_set_alpha(1);
				draw_set_color(16777215);
				draw_set_halign(1);
				draw_hd_text(tx, tty, fix.competition);
				tty += 14;
				draw_hd_text(tx, tty, fix.location);
				tty += 16;
				draw_hd_text(tx, tty, fix.vs);
				draw_set_alpha(fix.alpha);
				draw_set_color(fix.colour);
				draw_set_halign(2);
				draw_hd_text(tx - 40, tty, ds_map_find_value(fix.team_a, "name"));
				draw_set_halign(0);
				draw_hd_text(tx + 40, tty, ds_map_find_value(fix.team_h, "name"));
				break;
		}
		j++;
		if (j >= _lines) {
			j = 0;
			c++;
		}
	}
	if (_show_bracket && _page >= _max_page - 1) {
		var pg = 1 - (_max_page - _page);
		var y1, y2;
		var wk_future, tm_future;
		tx = gx + sprite_width / 2;
		ty = gy + 40;
		draw_set_halign(1);
		draw_hd_text(tx, ty, string_upper(s_str("ui_Semi")));
		draw_set_halign(0);
		draw_hd_text(tx - 84, ty - 16, string_upper(s_str("ui_Quarter")));
		draw_set_halign(2);
		draw_hd_text(tx + 84, ty - 16, string_upper(s_str("ui_Quarter")));
		for (var i = 0; i < _playoffs_size; i++) {
			fix = _playoffs[i];
			if (fix.pg != pg) {
				continue;
			}
			wk_future = fix.week > _week;
			tm_future = fix.week > _week + 1;
			draw_set_halign(1);
			y1 = fix.py - 14 - fix.dy * 16;
			y2 = fix.py + 5 + fix.dy * 16;
			s_draw_bracket_name_box(fix.px, y1);
			draw_set_color(fix.colour);
			draw_hd_text(fix.px, y1, tm_future ? "-" : ds_map_find_value(fix.team_a, "tla"));
			s_draw_bracket_name_box(fix.px, y2);
			draw_set_color(fix.colour);
			draw_hd_text(fix.px, y2, tm_future ? "-" : ds_map_find_value(fix.team_h, "tla"));
			draw_set_color(16777215);
			draw_hd_text(fix.px, y2 + 15, wk_future ? "" : fix.sc);
		}
	}
	draw_set_alpha(1);
}

function s_draw_bracket_name_box(_arg0, _arg1) {
	draw_sprite_ext(spr_box_flex, 0, _arg0 - 25, _arg1 - 7, 3.125, 0.9375, 0, 16777215, 1);
}

