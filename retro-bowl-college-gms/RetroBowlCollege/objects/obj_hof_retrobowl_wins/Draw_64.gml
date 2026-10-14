function s_hof_retrobowl_wins_franchise_draw() {
	var tx = x + 8;
	var ty = y + 12;
	var th = string_hd_height("I");
	for (var i = 0; i < ds_list_size(retrobowlhof); i++) {
		var map = ds_list_find_value(retrobowlhof, i);
		var count = string(real(ds_map_find_value(map, "count")));
		var txt = ds_map_find_value(map, "name");
		var col = 16777215;
		if (string_count("you_", txt)) {
			txt = string_replace(txt, "you_", "");
			col = global.c_primary;
		}
		tx = x + 8;
		draw_set_halign(0);
		draw_hd_text_color(tx, ty, txt, col, col, col, col, 1);
		tx = x + sprite_width - 8;
		draw_set_halign(2);
		draw_hd_text_color(tx, ty, count, col, col, col, col, 1);
		ty += th;
	}
}

function s_academic_gpa_limits_draw() {
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	var tx = x + 6;
	var ty = y + 12;
	with (obj_master) {
		var xl = tx;
		var xr = other.x + other.sprite_width - 18;
		var gpaVal = 0;
		var teamName = s_get_team_name_by_id(obj_master.myteam_id);
		draw_set_halign(0);
		draw_hd_text_color(xl - 1, ty + 1, teamName, 0, 0, 0, 0, 1);
		draw_hd_text_color(xl, ty, teamName, global.c_primary, global.c_primary, global.c_primary, global.c_primary, 1);
		ty += other.txt_h;
		gpaVal = s_gpa_from_percent_grade(s_player_grade_suspend_from_age(s_rookie_age_internal()) + 1);
		draw_set_halign(0);
		draw_hd_text(xl, ty, s_str("ui_Freshman"));
		draw_set_halign(2);
		draw_hd_text(xr, ty, string_format(gpaVal, 1, 1));
		ty += other.txt_h;
		gpaVal = s_gpa_from_percent_grade(s_player_grade_suspend_from_age(s_rookie_age_internal() + 1) + 1);
		draw_set_halign(0);
		draw_hd_text(xl, ty, s_str("ui_Sophomore"));
		draw_set_halign(2);
		draw_hd_text(xr, ty, string_format(gpaVal, 1, 1));
		ty += other.txt_h;
		gpaVal = s_gpa_from_percent_grade(s_player_grade_suspend_from_age(s_rookie_age_internal() + 2) + 1);
		draw_set_halign(0);
		draw_hd_text(xl, ty, s_str("ui_JuniorSenior"));
		draw_set_halign(2);
		draw_hd_text(xr, ty, string_format(gpaVal, 1, 1));
		ty += other.txt_h;
		gpaVal = s_gpa_from_percent_grade(s_player_grade_lift_suspension() + 1);
		draw_set_halign(0);
		draw_hd_text(xl, ty, s_str("ui_Unsuspend"));
		draw_set_halign(2);
		draw_hd_text(xr, ty, string_format(gpaVal, 1, 1));
	}
}

event_inherited();
if (s_is_co_mode()) {
	s_academic_gpa_limits_draw();
} else {
	s_hof_retrobowl_wins_franchise_draw();
}
