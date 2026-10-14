function s_college_details_init() {
	s_college_details_center([100024, 100032, 100033, 100025, 100026, 100035, 100036]);
	s_college_details_hide([100029, 100028, 100034, 100038, 100037, 100030]);
	var pd = {
		x: inst_100024.x,
		y: inst_100024.y + inst_100024.sprite_height + 20,
		w: inst_100035.x + inst_100035.sprite_width - inst_100024.x,
		h: inst_100024.sprite_height + 10,
		layer: inst_100024.layer
	};
	s_reset_team_selections();
	instance_create_layer(pd.x, pd.y, pd.layer, obj_blank, {
		sprite_index: spr_box_flex,
		image_xscale: pd.w / 16,
		image_yscale: pd.h / 16,
		action_create: s_college_details_bottom_panel_init,
		action_draw_gui: s_college_details_bottom_panel_draw_gui
	});
	s_loading_button_hijack(100027);
}

function s_reset_team_selections(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = false;
	}
	if (!s_is_co_mode()) {
		return;
	}
	if (!variable_instance_exists(global.g_m, "team_selections") || _arg0 || array_length(global.g_m.team_selections.starting_teams) < 1) {
		global.g_m.team_selections = {
			favorite_team_id: global.g_m.favourite_team_id,
			starting_team_id: ds_map_find_value(global.g_m.myteam, "uid"),
			mode: 0,
			starting_teams: s_create_starting_teams_list()
		};
		with (global.g_m.team_selections) {
			if (array_length(starting_teams) > 0) {
				starting_team_id = starting_teams[irandom(array_length(starting_teams) - 1)];
				favorite_team_id = s_get_random_non_rival_team(starting_team_id);
			}
		}
	}
}

function s_college_details_hide(_arg0) {
	array_foreach(_arg0, function(_arg0, _arg1) {
		_arg0.visible = false;
	});
}

function s_college_details_center(_arg0) {
	array_foreach(_arg0, function(_arg0, _arg1) {
		_arg0.x += -44;
	});
}

function s_college_details_bottom_panel_init() {
	_col = [{
		title: s_str_u("ui_Favorite"),
		btn_action: s_college_details_favorite_btn_action,
		btn_draw: s_college_details_btn_draw,
		x: x + sprite_width / 2 + sprite_width / 6 * -2 + 4,
		y: y,
		text: s_get_college_details_favorite_label_text(),
		color: 16777215
	}, {
		title: s_str_u("ui_Starting"),
		btn_action: s_college_details_starting_btn_action,
		btn_draw: s_college_details_btn_draw,
		x: x + sprite_width / 2 + sprite_width / 6 * 0,
		y: y,
		text: s_get_college_details_starting_label_text(),
		color: global.c_primary
	}, {
		title: s_str_u("ui_Difficulty"),
		btn_action: s_college_details_difficulty_btn_action,
		btn_draw: s_college_details_btn_draw,
		x: x + sprite_width / 2 + sprite_width / 6 * 2 - 4,
		y: y,
		text: s_get_college_details_difficulty_label_text(),
		color: 16777215
	}];
	s_college_details_bottom_panel_create_buttons(_col[0]);
	s_college_details_bottom_panel_create_buttons(_col[1]);
	s_college_details_bottom_panel_create_buttons(_col[2]);
}

function s_college_details_bottom_panel_draw_gui() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, 16777215, 1);
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_hd_text(_col[0].x, _col[0].y, _col[0].title, true);
	draw_hd_text(_col[1].x, _col[1].y, _col[1].title, true);
	draw_hd_text(_col[2].x, _col[2].y, _col[2].title, true);
}

function s_college_details_bottom_panel_create_buttons(_arg0) {
	var bw = 100;
	var bh = 30;
	_arg0.btn_label = instance_create_layer(_arg0.x - bw / 2, _arg0.y + 10, layer, obj_blank, {
		sprite_index: spr_box_flex,
		image_xscale: bw / 16,
		image_yscale: bh / 16,
		action_draw_gui: _arg0.btn_draw,
		action_tap: _arg0.btn_action,
		col: _arg0
	});
	_arg0.btn_inst = s_create_button(_arg0.x - bw / 2 - 2, _arg0.y + 10 + bh + 4, {
		text: s_str("ui_Change"),
		onClickAction: _arg0.btn_action,
		image_xscale: bw / 32,
		image_yscale: bh / 32,
		col: _arg0
	});
}

function s_college_details_favorite_btn_action() {
	global.g_m.team_selections.mode = 1;
	btn_click_Change_Favourite();
}

function s_college_details_starting_btn_action() {
	global.g_m.team_selections.mode = 0;
	btn_click_Change_Favourite();
}

function s_college_details_difficulty_btn_action() {
	with (obj_master) {
		op_difficulty += 1;
		if (op_difficulty > 4) {
			op_difficulty = 0;
		}
	}
	col.text = s_get_college_details_difficulty_label_text();
}

function s_get_college_details_favorite_label_text() {
	return string_upper(s_get_team_name_by_id(global.g_m.team_selections.favorite_team_id));
}

function s_get_college_details_starting_label_text() {
	return string_upper(s_get_team_name_by_id(global.g_m.team_selections.starting_team_id));
}

function s_get_college_details_difficulty_label_text() {
	return string_upper(s_get_difficulty_str());
}

function s_college_details_btn_draw() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, 16777215, 1);
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_hd_text_color(col.x, y + sprite_height / 2, col.text, col.color, col.color, col.color, col.color, 1);
}

function s_create_starting_teams_list() {
	var list = [];
	var fix;
	slogf("\n*** CREATING STARTING TEAMS LIST");
	for (var i = 0; i < ds_list_size(global.g_m.schedule); i++) {
		fix = ds_list_find_value(global.g_m.schedule, i);
		if (real(ds_map_find_value(fix, "week")) == s_get_skip_to_week()) {
			s_add_starting_team(list, ds_map_find_value(fix, "away_team"), ds_map_find_value(fix, "home_team"));
			s_add_starting_team(list, ds_map_find_value(fix, "home_team"), ds_map_find_value(fix, "away_team"));
		}
	}
	array_unique(list);
	return list;
}

function s_add_starting_team(_arg0, _arg1, _arg2) {
	var team = s_get_team_by_id(_arg1);
	var tier = s_get_subdivision(team);
	var rank = s_get_ranking_pos_data(team).pos;
	var opp_team = s_get_team_by_id(_arg2);
	var opp_tier = s_get_subdivision(opp_team);
	var opp_rank = s_get_ranking_pos_data(opp_team).pos;
	var starting = s_get_map_real(team, "starting", 0);
	if (starting == -1) {
		return;
	}
	if (starting == 0) {
		if (tier == 1 && rank <= 100) {
			return;
		}
		if (tier == 2 && rank <= 40) {
			return;
		}
	}
	if (tier == 2 && opp_tier == 1) {
		return;
	}
	if (opp_rank < 40) {
		return;
	}
	array_push(_arg0, _arg1);
	slogf("%1 tier: %2 rank_pos: %3", ds_map_find_value(team, "name"), tier, rank);
}

function s_is_starting_team_selectable(_arg0) {
	return array_contains(global.g_m.team_selections.starting_teams, _arg0);
}

function s_count_starting_team_selectable_conference(_arg0) {
	var tl = s_get_team_list(_arg0.uid);
	var count = 0;
	for (var i = 0; i < array_length(tl); i++) {
		if (s_is_starting_team_selectable(ds_map_find_value(array_get(tl, i), "uid"))) {
			count++;
		}
	}
	return count;
}

function s_get_random_non_rival_team(_arg0) {
	var st, ft, ft_id;
	var sr_id, fr_id;
	var cnt = 50;
	st = s_get_team_by_id(_arg0);
	sr_id = s_get_map_real(st, "rival", -1);
	slogf("get random non rival team for %1", _arg0);
	while (cnt-- > 0) {
		ft_id = s_get_random_team_id();
		ft = s_get_team_by_id(ft_id);
		fr_id = s_get_map_real(ft, "rival", -1);
		if (fr_id != _arg0 && sr_id != ft_id) {
			return ft_id;
		}
		slogf("%1 and %2 are rivals", _arg0, ft_id);
	}
	return ft_id;
}

