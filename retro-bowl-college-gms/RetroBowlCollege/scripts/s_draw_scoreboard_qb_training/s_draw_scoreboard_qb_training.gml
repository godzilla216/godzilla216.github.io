function s_draw_scoreboard_qb_training() {
	if (obj_master.gamepractice != 4) {
		return;
	}
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(0);
	draw_set_valign(1);
	draw_set_alpha(1);
	draw_rectangle_colour(0, 0, display_get_gui_width(), 16, 0, 0, 0, 0, 0);
	var tx = 16;
	var ty1 = 8;
	var txt = s_str("ui_Score") + ": " + string(practice_score_qb_mode);
	draw_hd_text(tx, ty1, txt);
	txt = s_str("ui_Best") + ": " + string(obj_master.qb_training_hiscore);
	draw_hd_text(tx + 90, ty1, txt);
	draw_set_halign(1);
	tx = display_get_gui_width() / 2;
	var time = " " + s_get_string_time(minutes, seconds);
	if (minutes == 0) {
		draw_set_color(65535);
		if (seconds < 6) {
			draw_set_color(255);
		}
	}
	draw_hd_text(tx, ty1, time);
	draw_set_color(16777215);
}

