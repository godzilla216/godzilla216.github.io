function s_obj_matchLine_create() {
	week_superbowl = s_get_week_superbowl();
	week_schedule_end = s_get_last_schedule_week();
	line_nodes = !s_is_co_mode() ? week_superbowl : week_schedule_end;
	gap = 192;
	slogf("line_nodes: %1", line_nodes);
	max_w = line_nodes * gap - gap;
	week = obj_master.week;
	if (week > max_w) {
		week = max_w;
	}
	x = display_get_gui_width() / 2 - week * gap + gap;
	ms_offset = 0;
	show_difficulty = false;
	clicked = false;
	if (s_is_co_mode()) {
		_data = [];
		var next_ps_fix, fix;
		for (var i = 1; i <= line_nodes; i++) {
			next_ps_fix = s_get_postseason_fixture_by_week(i + 1);
			fix = s_get_player_schedule_fixture_by_week(i);
			var fd = {
				next_ps_fixture: next_ps_fix,
				schedule_fix: fix,
				is_bowl: s_is_co_bowl_fix(fix),
				comp_str: s_get_fix_competition_string(fix)
			};
			_data[i] = fd;
		}
	}
}

function s_obj_matchLine_step() {
	if (global.gamepad && global.gp.triggerl && global.gp.triggerr) {
		x = display_get_gui_width() / 2 - week * gap + gap;
		flick_lineX = 0;
		ms_offset = 0;
	} else if (global.gamepad && global.gp.triggerl) {
		flick_lineX += 1;
	} else if (global.gamepad && global.gp.triggerr) {
		flick_lineX -= 1;
	} else {
		flick_lineX *= 0.999;
	}
	if (abs(flick_lineX)) {
		x += flick_lineX;
	}
	if (s_is_touch_allowed() && mouse_check_button(1) && mouse_y > y - 32 && mouse_y < y + 32) {
		if (clicked == 0) {
			clicked = current_time;
		}
		if (ms_offset == 0) {
			ms_offset = x - mouse_x;
		}
		x = ms_offset + mouse_x;
		flick_lineX = 0;
	} else {
		if (flick_lineX == 0 && current_time < clicked + 100) {
			show_difficulty = !show_difficulty;
		}
		clicked = 0;
		ms_offset = 0;
	}
	flick_lineX *= 0.9;
	var midscreen = display_get_gui_width() / 2;
	x = clamp(x, midscreen - max_w, midscreen);
}

function s_obj_matchLine_global_flick() {
	if (s_is_touch_allowed() && mouse_y > y - 32 && mouse_y < y + 32) {
		flick_lineX = ds_map_find_value(event_data, "diffX");
	}
}

function s_obj_matchLine_draw() {
}

function s_obj_matchLine_draw_gui() {
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_set_valign(1);
	draw_set_color(16777215);
	var gw = display_get_gui_width();
	var sx = x;
	var sy = y + 8;
	var col = global.c_primary;
	if (obj_master.qb_mode) {
		col = global.c_buttons;
	}
	draw_rectangle_color(0, y - 36, gw, y + 36, col, col, col, col, 0);
	for (var i = 1; i <= line_nodes; i++) {
		var fixture = s_get_human_fixture_by_week(i);
		var next_fixture = s_get_human_fixture_by_week(i + 1);
		var teamid_away = -1;
		var teamid_home = -1;
		var away_score = -1;
		var home_score = -1;
		var opponent = -4;
		var opp_name = "";
		var rescol = 16777215;
		var nextrescol = 16777215;
		var scoreline = "";
		if (fixture) {
			teamid_away = ds_map_find_value(fixture, "away_team");
			teamid_home = ds_map_find_value(fixture, "home_team");
			away_score = ds_map_find_value(fixture, "away_score");
			home_score = ds_map_find_value(fixture, "home_score");
			opponent = ds_list_find_value(obj_master.teamlist, teamid_away);
			if (obj_master.myteam_id == teamid_away) {
				opponent = ds_list_find_value(obj_master.teamlist, teamid_home);
			}
			if (!is_undefined(opponent) && ds_exists(opponent, 1) && !is_undefined(ds_map_find_value(opponent, "name"))) {
				if (teamid_away == obj_master.myteam_id && i != week_superbowl) {
					opp_name = s_str("tla_at") + " " + string_upper(ds_map_find_value(opponent, "name"));
				} else {
					opp_name = s_str("tla_versus") + " " + string_upper(ds_map_find_value(opponent, "name"));
				}
				if (ds_map_find_value(fixture, "human_win") != "unplayed") {
					if (ds_map_find_value(fixture, "human_win") == "win") {
						rescol = 65280;
					} else if (ds_map_find_value(fixture, "human_win") == "loss") {
						rescol = 255;
					} else if (ds_map_find_value(fixture, "human_win") == "tie") {
						rescol = 12632256;
					}
				}
				if (ds_map_find_value(fixture, "human_win") != "unplayed") {
					scoreline = string(away_score) + "-" + string(home_score);
					if (away_score < home_score) {
						scoreline = string(home_score) + "-" + string(away_score);
					}
					if (ds_map_find_value(fixture, "human_win") == "win") {
						scoreline = s_str("sla_Win") + " " + scoreline;
					} else if (ds_map_find_value(fixture, "human_win") == "loss") {
						scoreline = s_str("sla_Loss") + " " + scoreline;
					} else if (ds_map_find_value(fixture, "human_win") == "tie") {
						scoreline = s_str("sla_Tie") + " " + scoreline;
					}
				}
				if (next_fixture) {
					if (ds_map_find_value(next_fixture, "human_win") == "win") {
						nextrescol = 65280;
					} else if (ds_map_find_value(next_fixture, "human_win") == "loss") {
						nextrescol = 255;
					} else if (ds_map_find_value(next_fixture, "human_win") == "tie") {
						nextrescol = 12632256;
					}
				}
				if (s_is_co_mode() && _data[i].next_ps_fixture) {
					nextrescol = 12632256;
				}
			}
		} else if (s_is_co_mode() && i > obj_master.last_week_regular) {
			rescol = 12632256;
			fixture = _data[i].schedule_fix;
			if (fixture && ds_map_find_value(fixture, "show") == 1) {
				teamid_away = ds_map_find_value(fixture, "away_team");
				teamid_home = ds_map_find_value(fixture, "home_team");
				away_score = ds_map_find_value(fixture, "away_score");
				home_score = ds_map_find_value(fixture, "home_score");
				if (teamid_away > -1 && teamid_home > -1) {
					var team_away = ds_list_find_value(obj_master.teamlist, teamid_away);
					var team_home = ds_list_find_value(obj_master.teamlist, teamid_home);
					opp_name = ds_map_find_value(team_away, "tla") + " - " + ds_map_find_value(team_home, "tla");
					if (away_score > -1) {
						scoreline = string(away_score) + "-" + string(home_score);
					}
				}
			}
		} else if (i < obj_master.first_week_playoffs) {
			opp_name = s_str("ui_ByeWeek");
			rescol = 16777215;
			if (next_fixture) {
				if (ds_map_find_value(next_fixture, "human_win") == "win") {
					nextrescol = 65280;
				} else if (ds_map_find_value(next_fixture, "human_win") == "loss") {
					nextrescol = 255;
				} else if (ds_map_find_value(next_fixture, "human_win") == "tie") {
					nextrescol = 12632256;
				}
			}
		} else if (!s_is_co_mode()) {
			rescol = 12632256;
			fixture = s_get_playoff_fixture_by_week(i);
			if (fixture) {
				teamid_away = ds_map_find_value(fixture, "away_team");
				teamid_home = ds_map_find_value(fixture, "home_team");
				away_score = ds_map_find_value(fixture, "away_score");
				home_score = ds_map_find_value(fixture, "home_score");
				if (teamid_away > -1 && teamid_home > -1) {
					var team_away = ds_list_find_value(obj_master.teamlist, teamid_away);
					var team_home = ds_list_find_value(obj_master.teamlist, teamid_home);
					opp_name = ds_map_find_value(team_away, "tla") + " - " + ds_map_find_value(team_home, "tla");
					if (away_score > -1) {
						scoreline = string(away_score) + "-" + string(home_score);
					}
				}
			}
		}
		if (!s_is_co_mode() && i < obj_master.last_week_regular || s_is_co_mode() && i < week_schedule_end) {
			draw_line_width_colour(sx, sy, sx + gap, sy, 4, rescol, nextrescol);
			draw_line_width_colour(sx, sy + 1, sx + gap, sy + 1, 2, 4210752, 4210752);
		} else if (i < line_nodes) {
			draw_line_width_colour(sx, sy, sx + gap, sy, 4, 12632256, 12632256);
			draw_line_width_colour(sx, sy + 1, sx + gap, sy + 1, 2, 4210752, 4210752);
		}
		var wk;
		if (s_is_co_mode()) {
			wk = s_get_week_name(i);
		} else {
			wk = string_upper(s_get_string_week(i));
		}
		draw_hd_text_color(sx - 1, y - 27, wk, 0, 0, 0, 0, 1);
		draw_hd_text(sx, y - 28, wk);
		if (s_is_co_mode() && _data[i].comp_str != -4) {
			draw_set_color(0);
			draw_hd_text(sx - 1, y - 17, _data[i].comp_str);
			draw_set_color(16777215);
			draw_hd_text(sx, y - 18, _data[i].comp_str);
		}
		var col = 0;
		if (s_is_co_mode() && _data[i].is_bowl) {
			if (!is_undefined(opponent) && opponent != -4) {
				opp_name = string_upper(ds_map_find_value(opponent, "name"));
			}
		}
		draw_hd_text_color(sx - 1, y - 8 + 1, opp_name, col, col, col, col, 1);
		draw_hd_text(sx, y - 8, opp_name);
		draw_hd_text_color(sx - 1, y + 25, scoreline, col, col, col, col, 1);
		draw_hd_text(sx, y + 24, scoreline);
		draw_sprite_ext(spr_matchline_dot, 0, sx, sy, 1, 1, 0, rescol, 1);
		if (show_difficulty) {
			if (fixture && ds_map_find_value(fixture, "human_win") != "unplayed" && ds_map_exists(fixture, "difficulty")) {
				draw_set_alpha(0.75);
				draw_hd_text_transformed(sx, sy + 25, ds_map_find_value(fixture, "difficulty"), 0.5, 0.5, 0);
				draw_set_alpha(1);
			}
		}
		sx += gap;
	}
}

