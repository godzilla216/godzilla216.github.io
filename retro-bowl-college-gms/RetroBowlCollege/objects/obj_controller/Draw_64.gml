if (global.debug) {
	draw_set_font(global.fnt_small_flex);
	draw_set_valign(1);
	draw_set_halign(1);
	draw_hd_text(display_get_gui_width() / 2, display_get_gui_height() - 10, "DEBUG");
	draw_hd_text(10, 10, "Exhibition = " + string(global.exhibition));
	draw_hd_text(30, 30, string(s_is_kickoff(true)));
}
if (state == 3) {
	var gw = 60;
	if (drivedir == 1) {
		gw = display_get_gui_width();
	}
	draw_set_font(global.fnt_flex);
	draw_set_valign(0);
	draw_set_halign(1);
	if (current_time mod 1000 < 500) {
		draw_set_color(0);
		draw_hd_text_ext_transformed(gw - 30, 8, "R", -1, -1, 2, 2, 0);
		draw_set_color(16777215);
		draw_hd_text_ext_transformed(gw - 32, 6, "R", -1, -1, 2, 2, 0);
	}
	draw_set_alpha(0.3);
	draw_set_halign(2);
	var str = "";
	if (global.exhibition) {
		str = s_str("ui_Exhibition");
	} else {
		switch (obj_master.op_difficulty) {
			case 0:
				str = "D" + string(16 - (5 + obj_master.suppress_difficulty));
				break;
			case 1:
				str = s_str("ui_Easy");
				break;
			case 2:
				str = s_str("ui_Medium");
				break;
			case 3:
				str = s_str("ui_Hard");
				break;
			case 4:
				str = s_str("ui_Extreme");
				break;
		}
	}
	with (obj_weather) {
		if (type == 2) {
			draw_set_colour(16711680);
		}
	}
	draw_set_font(global.fnt_small_flex);
	draw_hd_text(display_get_gui_width() - 10, display_get_gui_height() - 20, str);
	draw_set_alpha(1);
	draw_set_colour(16777215);
	if (global.gamepad) {
		s_draw_gamepad_controls();
	}
	exit;
}
s_draw_scoreboard();
s_draw_commentary();
s_draw_wind();
if (global.gamepad) {
	s_draw_gamepad_controls();
}
