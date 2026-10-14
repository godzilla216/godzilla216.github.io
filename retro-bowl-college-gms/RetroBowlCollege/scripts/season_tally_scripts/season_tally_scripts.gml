function s_obj_season_tally_create() {
	slog("year: " + string(obj_master.year));
	slog("week: " + string(obj_master.week));
	slog("last_week_regular: " + string(obj_master.last_week_regular));
	watcol = s_get_watermark_color();
	sclx = 1.1;
	scly = 1.1;
	rot = random(360);
	page = 1;
	with (obj_master) {
		var dt = "Y" + string(year) + " ";
		if (!done_season_review) {
			dt += week > 18 ? "PS" : "W" + string(week);
		}
		inst_100658.text = s_str("ui_SeasonReview") + ":  " + ds_map_find_value(myteam, "name") + "  (" + fname + " " + lname + ")" + "  " + dt;
		inst_100655.text = s_get_string_record(myteam, true);
	}
	l_result = ds_list_create();
	l_week = ds_list_create();
	l_team = ds_list_create();
	l_score = ds_list_create();
	l_pd = ds_list_create();
	l_diff = ds_list_create();
	l_qtr = ds_list_create();
	l_weather = ds_list_create();
	l_of = ds_list_create();
	l_df = ds_list_create();
	totalpd = 0;
	total_of = 0;
	total_df = 0;
	l_pname = ds_list_create();
	l_pos = ds_list_create();
	l_games = ds_list_create();
	l_attcmp = ds_list_create();
	l_yards = ds_list_create();
	l_tds = ds_list_create();
	l_turn = ds_list_create();
	l_sacks_avg = ds_list_create();
	var gamecount = 0;
	var tof = 0;
	var tdf = 0;
	var map, wk, str_wk, cat;
	var fixtures = [];
	with (obj_master) {
		for (var i = 0; i < ds_list_size(fixturelist); i++) {
			array_push(fixtures, ds_list_find_value(fixturelist, i));
		}
		array_sort(fixtures, s_maps_array_sort_week);
		for (var i = 0; i < array_length(fixtures); i++) {
			map = fixtures[i];
			if (ds_map_find_value(map, "human_win") != "unplayed") {
				wk = real(ds_map_find_value(map, "week"));
				if (obj_master.year == 1 && wk < obj_master.last_week_regular) {
					continue;
				}
				str_wk = string(wk);
				if (s_is_co_mode()) {
					cat = ds_map_find_value(map, "cat");
					if (!is_undefined(cat)) {
						cat = string_upper(string(cat));
						if (cat != "") {
							str_wk = cat;
						}
					}
				} else {
					if (wk >= obj_master.first_week_playoffs) {
						str_wk = "PO";
					}
					if (wk == s_get_week_superbowl()) {
						str_wk = "RB";
					}
				}
				ds_list_add(other.l_week, str_wk);
				var pd = 0;
				var opp_map = s_get_team_by_id(ds_map_find_value(map, "home_team"));
				if (ds_map_find_value(map, "away_team") == obj_master.myteam_id) {
					ds_list_add(other.l_team, s_get_human_opponent_sla_prefix("@", wk) + ds_map_find_value(opp_map, "tla"));
					pd = ds_map_find_value(map, "away_score") - ds_map_find_value(map, "home_score");
				} else {
					opp_map = s_get_team_by_id(ds_map_find_value(map, "away_team"));
					ds_list_add(other.l_team, s_get_human_opponent_sla_prefix("", wk) + ds_map_find_value(opp_map, "tla"));
					pd = ds_map_find_value(map, "home_score") - ds_map_find_value(map, "away_score");
				}
				ds_list_add(other.l_pd, pd > 0 ? "+" + string(pd) : string(pd));
				ds_list_add(other.l_of, s_get_team_offense_with_reputation_boost(opp_map));
				ds_list_add(other.l_df, s_get_team_defense_with_reputation_boost(opp_map));
				tof += s_get_team_offense_with_reputation_boost(opp_map);
				tdf += s_get_team_defense_with_reputation_boost(opp_map);
				ds_list_add(other.l_score, string(ds_map_find_value(map, "away_score")) + "-" + string(ds_map_find_value(map, "home_score")));
				other.totalpd += pd;
				switch (ds_map_find_value(map, "human_win")) {
					case "win":
						ds_list_add(other.l_result, "W");
						break;
					case "loss":
						ds_list_add(other.l_result, "L");
						break;
					case "tie":
						ds_list_add(other.l_result, "T");
						break;
					default:
						ds_list_add(other.l_result, "");
						break;
				}
				if (ds_map_exists(map, "difficulty")) {
					var dif = ds_map_find_value(map, "difficulty");
					dif = string_replace(dif, s_str("ui_Dynamic"), "Dyn");
					dif = string_replace(dif, s_str("ui_Easy"), "Easy");
					dif = string_replace(dif, s_str("ui_Medium"), "Med");
					dif = string_replace(dif, s_str("ui_Hard"), "Hard");
					dif = string_replace(dif, s_str("ui_Extreme"), "Extrm");
					ds_list_add(other.l_diff, dif);
				}
				if (ds_map_exists(map, "op_matchlength")) {
					switch (ds_map_find_value(map, "op_matchlength")) {
						case -1:
							ds_list_add(other.l_qtr, "1m");
							break;
						case 0:
							ds_list_add(other.l_qtr, "2m");
							break;
						case 1:
							ds_list_add(other.l_qtr, "3m");
							break;
					}
				}
				if (ds_map_exists(map, "weather")) {
					switch (ds_map_find_value(map, "weather")) {
						case 0:
							ds_list_add(other.l_weather, "C");
							break;
						case 1:
							ds_list_add(other.l_weather, "R");
							break;
						case 2:
							ds_list_add(other.l_weather, "S");
							break;
					}
				}
				gamecount++;
			}
		}
		other.total_of = s_get_string_float(tof / 2, 1);
		other.total_df = s_get_string_float(tdf / 2, 1);
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 1) {
				ds_list_add(other.l_pname, ds_map_find_value(pmap, "lname"));
				ds_list_add(other.l_pos, real(ds_map_find_value(pmap, "position")));
				ds_list_add(other.l_games, string(ds_map_find_value(pmap, "season_games")) + "/" + string(ds_map_find_value(pmap, "career_games")));
				ds_list_add(other.l_attcmp, string(ds_map_find_value(pmap, "season_attempts")) + "/" + string(ds_map_find_value(pmap, "season_complete")));
				ds_list_add(other.l_yards, string(round(ds_map_find_value(pmap, "season_yards"))) + "/" + string(round(ds_map_find_value(pmap, "season_rush_yards"))));
				ds_list_add(other.l_tds, string(ds_map_find_value(pmap, "season_touchdowns")) + "/" + string(ds_map_find_value(pmap, "season_rush_touchdowns")));
				ds_list_add(other.l_turn, string(ds_map_find_value(pmap, "season_int")) + "/" + string(ds_map_find_value(pmap, "season_fumbles")));
				ds_list_add(other.l_sacks_avg, string(ds_map_find_value(pmap, "season_sacks")));
			}
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 2) {
				ds_list_add(other.l_pname, ds_map_find_value(pmap, "lname"));
				ds_list_add(other.l_pos, real(ds_map_find_value(pmap, "position")));
				ds_list_add(other.l_games, string(ds_map_find_value(pmap, "season_games")) + "/" + string(ds_map_find_value(pmap, "career_games")));
				ds_list_add(other.l_attcmp, string(ds_map_find_value(pmap, "season_attempts")) + "/" + string(ds_map_find_value(pmap, "season_rush_attempts")));
				ds_list_add(other.l_yards, string(round(ds_map_find_value(pmap, "season_yards"))) + "/" + string(round(ds_map_find_value(pmap, "season_rush_yards"))));
				ds_list_add(other.l_tds, string(ds_map_find_value(pmap, "season_touchdowns")) + "/" + string(ds_map_find_value(pmap, "season_rush_touchdowns")));
				ds_list_add(other.l_turn, string(ds_map_find_value(pmap, "season_fumbles")));
				ds_list_add(other.l_sacks_avg, "");
			}
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 4 || ds_map_find_value(pmap, "position") == 3) {
				ds_list_add(other.l_pname, ds_map_find_value(pmap, "lname"));
				ds_list_add(other.l_pos, real(ds_map_find_value(pmap, "position")));
				ds_list_add(other.l_games, string(ds_map_find_value(pmap, "season_games")) + "/" + string(ds_map_find_value(pmap, "career_games")));
				ds_list_add(other.l_attcmp, string(ds_map_find_value(pmap, "season_attempts")));
				ds_list_add(other.l_yards, string(round(ds_map_find_value(pmap, "season_yards"))));
				ds_list_add(other.l_tds, string(ds_map_find_value(pmap, "season_touchdowns")));
				ds_list_add(other.l_turn, string(ds_map_find_value(pmap, "season_fumbles")));
				ds_list_add(other.l_sacks_avg, s_get_string_float(s_get_average_yards(pmap, 1, false), 1));
			}
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 5) {
				ds_list_add(other.l_pname, ds_map_find_value(pmap, "lname"));
				ds_list_add(other.l_pos, real(ds_map_find_value(pmap, "position")));
				ds_list_add(other.l_games, string(ds_map_find_value(pmap, "season_games")) + "/" + string(ds_map_find_value(pmap, "career_games")));
				ds_list_add(other.l_attcmp, string(ds_map_find_value(pmap, "season_tackles")));
				ds_list_add(other.l_yards, "");
				ds_list_add(other.l_tds, "");
				ds_list_add(other.l_turn, "");
				ds_list_add(other.l_sacks_avg, "");
			}
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (s_is_defensive_player(pmap)) {
				ds_list_add(other.l_pname, ds_map_find_value(pmap, "lname"));
				ds_list_add(other.l_pos, real(ds_map_find_value(pmap, "position")));
				ds_list_add(other.l_games, string(ds_map_find_value(pmap, "season_games")) + "/" + string(ds_map_find_value(pmap, "career_games")));
				ds_list_add(other.l_attcmp, string(ds_map_find_value(pmap, "season_tackles")));
				ds_list_add(other.l_yards, string(round(ds_map_find_value(pmap, "season_sacks"))));
				ds_list_add(other.l_tds, string(ds_map_find_value(pmap, "season_int")));
				ds_list_add(other.l_turn, string(ds_map_find_value(pmap, "season_fumbles")));
				ds_list_add(other.l_sacks_avg, "");
			}
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 10) {
				ds_list_add(other.l_pname, ds_map_find_value(pmap, "lname"));
				ds_list_add(other.l_pos, real(ds_map_find_value(pmap, "position")));
				ds_list_add(other.l_games, string(ds_map_find_value(pmap, "season_games")) + "/" + string(ds_map_find_value(pmap, "career_games")));
				ds_list_add(other.l_attcmp, string(ds_map_find_value(pmap, "season_attempts")) + "/" + string(ds_map_find_value(pmap, "season_complete")));
				ds_list_add(other.l_yards, string(round(ds_map_find_value(pmap, "season_yards"))));
				ds_list_add(other.l_tds, "");
				ds_list_add(other.l_turn, "");
				ds_list_add(other.l_sacks_avg, "");
			}
		}
	}
	with (obj_master) {
		var num_restarts = max(0, gamestarts - gamecount);
		inst_100652.text = "Restarts:" + string(num_restarts);
		inst_100652.text += " CCs:" + string(season_credits_purchased);
		inst_100652.visible = false;
	}
	var typ = "Html5";
	if (!global.browser) {
		switch (os_type) {
			case 0:
				typ = "Windows";
				break;
			case 4:
				typ = "Android";
				break;
			case 1:
				typ = "MacOS";
				break;
			case 3:
				typ = "iOS";
				break;
			case 21:
				typ = "Switch";
				break;
		}
	}
	inst_100653.text = typ + " v" + s_get_gm_version();
	if (global.poki) {
		inst_100653.text += " Poki";
	}
	inst_100653.text += s_cap_breach_str();
	inst_100653.visible = false;
	if (s_is_co_mode()) {
		inst_100656.visible = false;
		tally_rc_earned = instance_create_layer(120, 232, "Instances", obj_vbox, {
			image_xscale: 0.6,
			image_yscale: 0.25,
			text: "$" + string(obj_master.rc_season_earned) + s_str("sla_Thousand"),
			title: s_str("ui_Received")
		});
		tally_rc_spent = instance_create_layer(224, 232, "Instances", obj_vbox, {
			image_xscale: 0.6,
			image_yscale: 0.25,
			text: "$" + string(-obj_master.rc_season_spent) + s_str("sla_Thousand"),
			title: s_str("ui_Spent")
		});
	}
}

function s_maps_array_sort_week(_arg0, _arg1) {
	return real(ds_map_find_value(_arg0, "week")) - real(ds_map_find_value(_arg1, "week"));
}

function s_get_human_opponent_sla_prefix(_arg0, _arg1) {
	if (!s_is_co_mode()) {
		return _arg0;
	}
	var fix = s_get_player_schedule_fixture_by_week(_arg1);
	if (s_is_co_bowl_fix(fix)) {
		return "n";
	}
	return _arg0;
}

function s_obj_season_tally_step() {
	inst_100661.visible = true;
	inst_100660.visible = true;
	switch (page) {
		case 1:
			inst_100661.visible = false;
			break;
		case 2:
			inst_100660.visible = false;
			break;
	}
}

function s_obj_season_tally_draw_gui() {
}

function s_obj_season_tally_draw_gui_begin() {
	var tx = display_get_gui_width() * 0.5;
	var ty = display_get_gui_height() * 0.5;
	var score_alf = 1;
	if (!global.gamepad && s_is_touch_allowed() && mouse_check_button(1) && mouse_x < 100 && mouse_y < 100 || global.gamepad && gamepad_button_check(global.gp.slot, 32771) && gamepad_button_check(global.gp.slot, 32772)) {
		inst_100652.visible = true;
		inst_100653.visible = true;
		draw_sprite_ext(spr_watermark, 0, tx, ty, sclx, scly, rot, watcol, 1);
		score_alf = 0.5;
		if (s_is_co_mode()) {
			tally_rc_earned.text = "$" + string(obj_master.rc_season_earned) + "(" + string(obj_master.rc_lifetime_earned) + ")" + s_str("sla_Thousand");
			tally_rc_spent.text = "$" + string(-obj_master.rc_season_spent) + "(" + string(-obj_master.rc_lifetime_spent) + ")" + s_str("sla_Thousand");
		}
	} else {
		inst_100652.visible = false;
		inst_100653.visible = false;
		if (s_is_co_mode()) {
			tally_rc_earned.text = "$" + string(obj_master.rc_season_earned) + s_str("sla_Thousand");
			tally_rc_spent.text = "$" + string(-obj_master.rc_season_spent) + s_str("sla_Thousand");
		}
	}
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	draw_set_alpha(1);
	var tab = 46;
	tx = 46;
	ty = 24;
	var spc = 8.5;
	if (ds_list_size(l_week) < 21) {
		spc = 9;
	}
	if (ds_list_size(l_week) < 18) {
		spc = 10;
	}
	if (ds_list_size(l_week) < 16) {
		spc = 12;
	}
	switch (page) {
		case 1:
			draw_hd_text_color(tx, ty, s_str("tla_Week"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 1, ty - 1, s_str("tla_Week"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx - 6 + tab * 1, ty, s_str("ui_Team"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx - 5 + tab * 1, ty - 1, s_str("ui_Team"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + tab * 2, ty, s_str("tla_Offense"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 1 + tab * 2, ty - 1, s_str("tla_Offense"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + tab * 3, ty, s_str("tla_Defense"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 1 + tab * 3, ty - 1, s_str("tla_Defense"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + 6 + tab * 4, ty, s_str("tla_Score"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 7 + tab * 4, ty - 1, s_str("tla_Score"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + 4 + tab * 5, ty, s_str("short_PointDiff"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 5 + tab * 5, ty - 1, s_str("short_PointDiff"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + 4 + tab * 6, ty, s_str("short_Difficulty"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 5 + tab * 6, ty - 1, s_str("short_Difficulty"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + 6 + tab * 7, ty, s_str("short_QtrLength"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 7 + tab * 7, ty - 1, s_str("short_QtrLength"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(tx + tab * 8, ty, s_str("short_Weather"), 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 1 + tab * 8, ty - 1, s_str("short_Weather"), 16777215, 16777215, 16777215, 16777215, 1);
			for (var i = 0; i < ds_list_size(l_week); i++) {
				ty += spc;
				draw_set_alpha(1);
				if (string_count("@", ds_list_find_value(l_team, i))) {
					draw_set_alpha(0.7);
				}
				draw_set_color(16777215);
				draw_hd_text(tx, ty, ds_list_find_value(l_week, i));
				draw_hd_text(tx - 6 + tab * 1, ty, ds_list_find_value(l_team, i));
				draw_set_alpha(1);
				draw_set_color(16777215);
				if (!inst_100652.visible) {
					draw_sprite_ext(spr_star_rating_cb, real(ds_list_find_value(l_of, i)), tx + tab * 2, ty, 1, 1, 0, global.c_offense, 1);
					draw_sprite_ext(spr_star_rating_cb, real(ds_list_find_value(l_df, i)), tx + tab * 3, ty, 1, 1, 0, global.c_defense, 1);
				} else {
					draw_hd_text_color(tx + tab * 2, ty, s_get_string_float(ds_list_find_value(l_of, i) / 2, 1), global.c_offense, global.c_offense, global.c_offense, global.c_offense, 1);
					draw_hd_text_color(tx + tab * 3, ty, s_get_string_float(ds_list_find_value(l_df, i) / 2, 1), global.c_defense, global.c_defense, global.c_defense, global.c_defense, 1);
				}
				draw_hd_text_color(tx + 6 + tab * 4, ty, ds_list_find_value(l_score, i), 16777215, 16777215, 16777215, 16777215, score_alf);
				switch (ds_list_find_value(l_result, i)) {
					case "W":
						draw_hd_text_color(tx + 4 + tab * 5, ty, ds_list_find_value(l_pd, i), 65280, 65280, 65280, 65280, 1);
						break;
					case "L":
						draw_hd_text_color(tx + 4 + tab * 5, ty, ds_list_find_value(l_pd, i), 255, 255, 255, 255, 1);
						break;
					default:
						draw_hd_text_color(tx + 4 + tab * 5, ty, ds_list_find_value(l_pd, i), 16777215, 16777215, 16777215, 16777215, 1);
						break;
				}
				if (!is_undefined(ds_list_find_value(l_diff, i))) {
					draw_hd_text(tx + 6 + tab * 6, ty, ds_list_find_value(l_diff, i));
				}
				if (!is_undefined(ds_list_find_value(l_qtr, i))) {
					draw_hd_text(tx + 6 + tab * 7, ty, ds_list_find_value(l_qtr, i));
				}
				if (!is_undefined(ds_list_find_value(l_weather, i))) {
					switch (ds_list_find_value(l_weather, i)) {
						case "R":
							draw_sprite(spr_weather, 1, tx + tab * 8, ty);
							break;
						case "S":
							draw_sprite(spr_weather, 2, tx + tab * 8, ty);
							break;
						default:
							draw_sprite(spr_weather, 0, tx + tab * 8, ty);
							break;
					}
				} else {
					draw_sprite(spr_weather, 0, tx + tab * 8, ty);
				}
				if (i == ds_list_size(l_pd) - 1) {
					draw_hd_text_color(tx + tab * 2, ty + 12, total_of, 0, 0, 0, 0, 1);
					draw_hd_text_color(tx + 1 + tab * 2, ty + 11, total_of, global.c_offense, global.c_offense, global.c_offense, global.c_offense, 1);
					draw_hd_text_color(tx + tab * 3, ty + 12, total_df, 0, 0, 0, 0, 1);
					draw_hd_text_color(tx + 1 + tab * 3, ty + 11, total_df, global.c_defense, global.c_defense, global.c_defense, global.c_defense, 1);
					var str_pd = totalpd > 0 ? "+" + string(totalpd) : string(totalpd);
					draw_hd_text_color(tx + tab * 5, ty + 12, str_pd, 0, 0, 0, 0, 1);
					draw_hd_text_color(tx + 1 + tab * 5, ty + 11, str_pd, 16777215, 16777215, 16777215, 16777215, 1);
				}
			}
			break;
		case 2:
			tab = 50;
			spc = 8.5;
			ty -= spc * 2;
			var done_qb = false;
			var done_rb = false;
			var done_rec = false;
			var done_ol = false;
			var done_kk = false;
			var done_def = false;
			for (var i = 0; i < ds_list_size(l_pos); i++) {
				switch (ds_list_find_value(l_pos, i)) {
					case 1:
						if (!done_qb) {
							ty += spc + spc;
							s_draw_season_tally_header(1, tx, ty, tab);
							done_qb = true;
						}
						break;
					case 2:
						if (!done_rb) {
							ty += spc + spc;
							s_draw_season_tally_header(2, tx, ty, tab);
							done_rb = true;
						}
						break;
					case 3:
					case 4:
						if (!done_rec) {
							ty += spc + spc;
							s_draw_season_tally_header(3, tx, ty, tab);
							done_rec = true;
						}
						break;
					case 5:
						if (!done_ol) {
							ty += spc + spc;
							s_draw_season_tally_header(5, tx, ty, tab);
							done_ol = true;
						}
						break;
					case 10:
						if (!done_kk) {
							ty += spc + spc;
							s_draw_season_tally_header(10, tx, ty, tab);
							done_kk = true;
						}
						break;
					default:
						if (!done_def) {
							ty += spc + spc;
							s_draw_season_tally_header(6, tx, ty, tab);
							done_def = true;
						}
						break;
				}
				ty += spc;
				draw_set_alpha(1);
				draw_set_color(16777215);
				draw_set_halign(0);
				draw_hd_text(tx + 21, ty, ds_list_find_value(l_pname, i));
				draw_set_halign(1);
				var col = s_get_position_colour(ds_list_find_value(l_pos, i));
				draw_hd_text_color(tx + 4, ty, s_get_string_position(ds_list_find_value(l_pos, i)), col, col, col, col, 1);
				draw_hd_text(tx + 8 + tab * 2, ty, ds_list_find_value(l_games, i));
				draw_hd_text(tx + 10 + tab * 3, ty, ds_list_find_value(l_attcmp, i));
				draw_hd_text(tx - 6 + tab * 4.5, ty, ds_list_find_value(l_yards, i));
				draw_hd_text(tx + tab * 5.5, ty, ds_list_find_value(l_tds, i));
				draw_hd_text(tx + tab * 6.5, ty, ds_list_find_value(l_turn, i));
				draw_hd_text(tx - 4 + tab * 7.5, ty, ds_list_find_value(l_sacks_avg, i));
			}
			break;
	}
	draw_set_color(16777215);
	draw_set_alpha(1);
}

function s_draw_season_tally_header(_arg0, _arg1, _arg2, _arg3) {
	var colx_1 = _arg1 + 20;
	var colx_2 = _arg1 + 4;
	var colx_3 = _arg1 + 8 + _arg3 * 2;
	var colx_4 = _arg1 + 10 + _arg3 * 3;
	var colx_5 = _arg1 - 6 + _arg3 * 4.5;
	var colx_6 = _arg1 + _arg3 * 5.5;
	var colx_7 = _arg1 + _arg3 * 6.5;
	var colx_8 = _arg1 - 4 + _arg3 * 7.5;
	draw_set_halign(0);
	draw_hd_text_color(colx_1, _arg2, s_str("ui_Name"), 0, 0, 0, 0, 1);
	draw_hd_text_color(colx_1 + 1, _arg2 - 1, s_str("ui_Name"), 16777215, 16777215, 16777215, 16777215, 1);
	draw_set_halign(1);
	draw_hd_text_color(_arg1 + 4, _arg2, s_str("tla_Position"), 0, 0, 0, 0, 1);
	draw_hd_text_color(_arg1 + 5, _arg2 - 1, s_str("tla_Position"), 16777215, 16777215, 16777215, 16777215, 1);
	draw_hd_text_color(colx_3, _arg2, s_str("short_GamesCareer"), 0, 0, 0, 0, 1);
	draw_hd_text_color(colx_3 + 1, _arg2 - 1, s_str("short_GamesCareer"), 16777215, 16777215, 16777215, 16777215, 1);
	switch (_arg0) {
		case 1:
			draw_hd_text_color(colx_4, _arg2, s_str("short_AttemptsComplete"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_4 + 1, _arg2 - 1, s_str("short_AttemptsComplete"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_5, _arg2, s_str("short_YardsRush"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_5 + 1, _arg2 - 1, s_str("short_YardsRush"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_6, _arg2, s_str("short_TdsRush"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_6 + 1, _arg2 - 1, s_str("short_TdsRush"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_7, _arg2, s_str("short_Turnovers"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_7 + 1, _arg2 - 1, s_str("short_Turnovers"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_8, _arg2, s_str("short_Sacks"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_8 + 1, _arg2 - 1, s_str("short_Sacks"), 16777215, 16777215, 16777215, 16777215, 1);
			break;
		case 2:
			draw_hd_text_color(colx_4, _arg2, s_str("short_RecepCarries"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_4 + 1, _arg2 - 1, s_str("short_RecepCarries"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_5, _arg2, s_str("short_YardsRush"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_5 + 1, _arg2 - 1, s_str("short_YardsRush"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_6, _arg2, s_str("short_TdsRush"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_6 + 1, _arg2 - 1, s_str("short_TdsRush"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_7, _arg2, s_str("short_Fumbles"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_7 + 1, _arg2 - 1, s_str("short_Fumbles"), 16777215, 16777215, 16777215, 16777215, 1);
			break;
		case 3:
		case 4:
			draw_hd_text_color(colx_4, _arg2, s_str("short_Receptions"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_4 + 1, _arg2 - 1, s_str("short_Receptions"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_5, _arg2, s_str("tla_Yards"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_5 + 1, _arg2 - 1, s_str("tla_Yards"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_6, _arg2, s_str("short_Touchdowns"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_6 + 1, _arg2 - 1, s_str("short_Touchdowns"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_7, _arg2, s_str("short_Fumbles"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_7 + 1, _arg2 - 1, s_str("short_Fumbles"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_8, _arg2, s_str("short_Average"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_8 + 1, _arg2 - 1, s_str("short_Average"), 16777215, 16777215, 16777215, 16777215, 1);
			break;
		case 5:
			draw_hd_text_color(colx_4, _arg2, s_str("short_Blocks"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_4 + 1, _arg2 - 1, s_str("short_Blocks"), 16777215, 16777215, 16777215, 16777215, 1);
			break;
		case 10:
			draw_hd_text_color(colx_4, _arg2, s_str("short_AttemptsComplete"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_4 + 1, _arg2 - 1, s_str("short_AttemptsComplete"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_5, _arg2, s_str("tla_Yards"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_5 + 1, _arg2 - 1, s_str("tla_Yards"), 16777215, 16777215, 16777215, 16777215, 1);
			break;
		case 6:
			draw_hd_text_color(colx_4, _arg2, s_str("short_Tackles"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_4 + 1, _arg2 - 1, s_str("short_Tackles"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_5, _arg2, s_str("short_Sacks"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_5 + 1, _arg2 - 1, s_str("short_Sacks"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_6, _arg2, s_str("short_Interceptions"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_6 + 1, _arg2 - 1, s_str("short_Interceptions"), 16777215, 16777215, 16777215, 16777215, 1);
			draw_hd_text_color(colx_7, _arg2, s_str("short_ForcedFumbles"), 0, 0, 0, 0, 1);
			draw_hd_text_color(colx_7 + 1, _arg2 - 1, s_str("short_ForcedFumbles"), 16777215, 16777215, 16777215, 16777215, 1);
			break;
	}
}

