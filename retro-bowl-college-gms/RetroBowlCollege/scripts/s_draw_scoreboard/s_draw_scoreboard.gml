function s_draw_scoreboard() {
	if (obj_master.gamepractice) {
		s_draw_scoreboard_qb_training();
		return;
	}
	if (global.debug_aa_hide_ui) {
		return;
	}
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(0);
	draw_set_valign(1);
	draw_set_alpha(1);
	draw_rectangle_colour(0, 0, display_get_gui_width(), 16, 0, 0, 0, 0, 0);
	var tx = 16;
	var ty1 = 8;
	var name1 = ds_map_find_value(team[0], "tla");
	var name2 = ds_map_find_value(team[1], "tla");
	var to_len = 0;
	var tx_score_end = 0;
	if (s_is_co_mode()) {
		var tx2 = 0;
		draw_hd_text_color(tx + tx2, ty1, team_conf_tag[0], 16777215, 16777215, 16777215, 16777215, 0.7);
		tx2 += string_hd_width(team_conf_tag[0]);
		var txt = name1 + " " + string(team_score[0]) + "  ";
		draw_hd_text(tx + tx2, ty1, txt);
		tx2 += string_hd_width(txt);
		draw_hd_text_color(tx + tx2, ty1, team_conf_tag[1], 16777215, 16777215, 16777215, 16777215, 0.7);
		tx2 += string_hd_width(team_conf_tag[1]);
		to_len = tx2;
		txt = name2 + " " + string(team_score[1]);
		draw_hd_text(tx + tx2, ty1, txt);
		tx_score_end = tx + tx2 + string_hd_width(txt);
	} else {
		var txt = name1;
		txt += " " + string(team_score[0]) + "  ";
		to_len = string_hd_width(txt);
		txt += name2 + " " + string(team_score[1]);
		draw_hd_text(tx, ty1, txt);
	}
	with (obj_controller) {
		var to_x = tx;
		var to_y = ty1 + 6;
		if (global.exhibition && obj_master.playerteamindex == -1) {
			for (var i = 0; i < timeouts; i++) {
				draw_line_width(to_x, to_y, to_x + 6, to_y, 2);
				to_x += 8;
			}
			to_x = tx + to_len;
			for (var i = 0; i < timeouts_p2; i++) {
				draw_line_width(to_x, to_y, to_x + 6, to_y, 2);
				to_x += 8;
			}
		} else {
			if (human_team == 1) {
				to_x += to_len;
			}
			for (var i = 0; i < s_count_timeouts(); i++) {
				draw_line_width(to_x, to_y, to_x + 6, to_y, 2);
				to_x += 8;
			}
		}
	}
	var offsetX = 0;
	if (comm_stage != 13) {
		draw_set_halign(2);
		var midx = display_get_gui_width() / 2;
		tx = midx;
		if (s_is_co_mode()) {
			var quarter_len = string_hd_width("1st Quart");
			if (tx_score_end + quarter_len > midx) {
				offsetX = tx_score_end + quarter_len - midx;
				tx += offsetX;
				obj_btn_pause.x = midx + 50 + offsetX;
				slog("overlap! tx_score_end[" + string(tx_score_end) + "] quarter_len[" + string(quarter_len) + "] midx[" + string(midx) + "] tx[" + string(tx) + "]");
			}
		}
		var qtr = s_str("quarter_" + string(quarter)) + " ";
		if (college_overtime) {
			if (quarter >= 5 && college_overtime_round > 1) {
				qtr = string(college_overtime_round) + " " + qtr;
			}
		}
		draw_hd_text(tx, ty1, qtr);
		draw_set_halign(0);
		var time = " " + s_get_string_time(minutes, seconds);
		if (minutes == 0) {
			draw_set_color(65535);
			if (seconds < 11) {
				draw_set_color(255);
			}
		}
		if (timeout_called) {
			draw_set_color(4235519);
		}
		if (college_overtime) {
			time = "";
		}
		draw_hd_text(tx, ty1, time);
		draw_set_color(16777215);
		if (state == 2 || state_previous == 2 && state == 10) {
			draw_set_halign(2);
			draw_set_colour(16777215);
			tx = display_get_gui_width() - 16;
			if (kicking) {
				if (s_aiming()) {
					var kk = s_get_kicker();
					var txt = string(kick_dist) + " " + s_str("tla_yards");
					if (kk && kk.pmap) {
						if (ds_map_find_value(kk.pmap, "stat_attempts") > 0) {
							txt += "  " + string(ds_map_find_value(kk.pmap, "stat_complete")) + "/" + string(ds_map_find_value(kk.pmap, "stat_attempts")) + " " + s_str("tla_Attempts");
						}
					}
					draw_hd_text(tx, ty1, txt);
				}
			} else if (down > 0 && down < 5) {
				draw_hd_text(tx, ty1, s_get_string_downand());
			}
		} else if (global.debug) {
			draw_set_halign(2);
			draw_set_colour(0);
			draw_hd_text(display_get_gui_width() - 16, display_get_gui_height() - 80, string(round(s_convert_scrimmage_to_goal_distance())) + s_str("sla_Yards"));
			draw_set_colour(16777215);
		}
	}
	with (global.master_ball) {
		if (!instance_exists(obj_notification) && !instance_exists(obj_match_msg)) {
			if (holder && holder.pos_name != "") {
				var txt = holder.pos_name;
				var sx = 22;
				var sy = display_get_gui_height() - 10;
				draw_sprite(spr_attitude, s_get_attitude_icon(ds_map_find_value(holder.pmap, "attitude")), sx, sy);
				draw_set_halign(0);
				draw_set_colour(0);
				draw_hd_text(sx + 12, sy, txt);
				draw_set_colour(16777215);
			}
		}
	}
}

