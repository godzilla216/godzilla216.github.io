draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
draw_set_alpha(1);
var tx = x + 4;
var ty = y + 18;
var line_buf = 13;
var col_buf = 34;
var showSal = true;
var showCnt = true;
var showAge = true;
var showGpa = false;
if (s_is_co_mode()) {
	showSal = false;
	showCnt = false;
	showGpa = true;
	if (obj_master.stage == 7) {
		var byeWeek = s_is_bye_week(obj_master.week);
		if (!byeWeek) {
			showSal = true;
			showCnt = true;
			showGpa = true;
			col_buf = 30;
		}
	}
}
if (ds_list_size(l_attitude) > 11) {
	ty = y + 14;
	line_buf = 11.5;
}
for (var l = 0; l < ds_list_size(l_attitude); l++) {
	draw_set_color(16777215);
	if (l > 0) {
		if (s_is_co_mode() && ds_list_find_value(l_suspended, l)) {
			draw_sprite(spr_condition, 4, tx, ty);
		} else if (ds_list_find_value(l_resting, l)) {
			draw_sprite(spr_condition, 3, tx, ty);
		} else {
			draw_sprite(spr_attitude, s_get_attitude_icon(ds_list_find_value(l_attitude, l)), tx, ty);
		}
	}
	tx += 12;
	draw_set_halign(0);
	var txt = ds_list_find_value(l_names, l);
	if (l == 0) {
		draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
	}
	draw_hd_text(tx, ty, txt);
	draw_set_halign(1);
	tx += 82;
	draw_set_color(s_get_position_colour(ds_list_find_value(l_pos, l)));
	var txt = s_get_string_position(ds_list_find_value(l_pos, l));
	draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
	draw_hd_text(tx, ty, txt);
	draw_set_color(16777215);
	tx += col_buf;
	var con = ds_list_find_value(l_condition, l);
	if (l == 0) {
		draw_hd_text_color(tx - 1, ty + 1, con, 0, 0, 0, 0, 1);
		draw_hd_text(tx, ty, con);
	} else if (con <= 40) {
		var str_con = string(abs(con));
		if (con <= 0) {
			draw_hd_text_color(tx + 5, ty + 1, str_con, 0, 0, 0, 0, 1);
			draw_hd_text_color(tx + 6, ty, str_con, 255, 255, 255, 255, 1);
			draw_sprite(spr_condition, 0, tx - 2 - string_hd_width(str_con) / 2, ty);
		} else if (con <= 20) {
			draw_hd_text_color(tx - 1, ty + 1, str_con + "%", 0, 0, 0, 0, 1);
			draw_hd_text_color(tx, ty, str_con + "%", 4235519, 4235519, 4235519, 4235519, 1);
		} else {
			draw_hd_text_color(tx - 1, ty + 1, str_con + "%", 0, 0, 0, 0, 1);
			draw_hd_text_color(tx, ty, str_con + "%", 65535, 65535, 65535, 65535, 1);
		}
	} else {
		draw_hd_text(tx, ty, string(con) + "%");
	}
	if (obj_master.stage == 7) {
		draw_set_color(16777215);
		tx += col_buf;
		var txt = ds_list_find_value(l_yards, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf;
		var txt = ds_list_find_value(l_tds, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf;
		var txt = ds_list_find_value(l_tackles, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf;
		var txt = ds_list_find_value(l_intsacks, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		if (showSal) {
			tx += col_buf;
			var txt = ds_list_find_value(l_fumbles, l);
			if (l == 0) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
				draw_hd_text(tx, ty, txt);
			}
			draw_hd_text_color(tx, ty, txt, 16777215, 16777215, 16777215, 16777215, 1);
		}
		if (showCnt) {
			tx += col_buf;
			var txt = ds_list_find_value(l_rating, l);
			if (l == 0) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			}
			draw_hd_text(tx, ty, txt);
		}
		if (showGpa) {
			tx += col_buf;
			var txt = "";
			if (l == 0) {
				txt = string(ds_list_find_value(l_gpa, l));
			} else {
				txt = s_gpa_string_direct(ds_list_find_value(l_gpa, l));
			}
			if (l == 0) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			}
			var t_col = ds_list_find_value(l_gpa_col, l);
			if (t_col != 16777215) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			}
			draw_hd_text_color(tx, ty, txt, t_col, t_col, t_col, t_col, 1);
		}
		tx += col_buf;
		draw_set_colour(global.c_primary);
		var txt = ds_list_find_value(l_xp, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf + 8;
		var a = 1 + sin(current_time / 100);
		draw_set_colour(16777215);
		var txt = ds_list_find_value(l_levelup, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		} else if (string_count("flash_", txt)) {
			txt = string_replace(txt, "flash_", "");
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, a * 0.7);
			draw_set_alpha(a);
			draw_set_colour(global.c_primary);
		}
		draw_hd_text(tx, ty, txt);
		draw_set_alpha(1);
	} else {
		draw_set_color(16777215);
		tx += col_buf;
		var txt = ds_list_find_value(l_yards, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf;
		var txt = ds_list_find_value(l_tds, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf;
		var txt = ds_list_find_value(l_tackles, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		tx += col_buf;
		var txt = ds_list_find_value(l_intsacks, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
		if (showSal) {
			if (obj_master.qb_mode) {
				tx += col_buf + 1;
				if (l == 0) {
					draw_hd_text_color(tx - 1, ty + 1, s_str("tla_Rating"), 0, 0, 0, 0, 1);
					draw_hd_text(tx, ty, s_str("tla_Rating"));
				} else {
					draw_sprite_ext(spr_star_rating_cb, real(ds_list_find_value(l_fumbles, l)), tx, ty, 1, 1, 0, 65535, 1);
				}
				tx += 1;
			} else {
				tx += col_buf;
				var txt = ds_list_find_value(l_fumbles, l);
				if (l == 0) {
					draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
				}
				draw_hd_text(tx, ty, txt);
			}
		}
		if (showCnt) {
			tx += col_buf;
			var txt = ds_list_find_value(l_rating, l);
			if (l == 0) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			}
			draw_hd_text(tx, ty, txt);
		}
		if (showAge) {
			tx += col_buf;
			var txt = ds_list_find_value(l_xp, l);
			if (l == 0) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			} else if (txt == s_rookie_age_internal()) {
				draw_set_colour(global.c_primary);
			}
			draw_hd_text(tx, ty, txt);
			draw_set_colour(16777215);
		}
		if (showGpa) {
			tx += col_buf;
			var txt = "";
			if (l == 0) {
				txt = string(ds_list_find_value(l_gpa, l));
			} else {
				txt = s_gpa_string_direct(ds_list_find_value(l_gpa, l));
			}
			if (l == 0) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			}
			var t_col = ds_list_find_value(l_gpa_col, l);
			if (t_col != 16777215) {
				draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
			}
			draw_hd_text_color(tx, ty, txt, t_col, t_col, t_col, t_col, 1);
		}
		tx += col_buf + 8;
		var txt = ds_list_find_value(l_levelup, l);
		if (l == 0) {
			draw_hd_text_color(tx - 1, ty + 1, txt, 0, 0, 0, 0, 1);
		}
		draw_hd_text(tx, ty, txt);
	}
	tx = x + 4;
	ty += line_buf;
}
draw_set_alpha(1);
draw_set_colour(16777215);
