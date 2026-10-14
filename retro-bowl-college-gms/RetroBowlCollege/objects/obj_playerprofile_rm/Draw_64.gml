if (!ds_exists(pmap, 1)) {
	exit;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
draw_set_valign(1);
var col = global.c_primary == 0 ? 16777215 : global.c_primary;
if (show_spr_star_rating_cb) {
	draw_sprite_ext(spr_star_rating_cb, star_rating, x_star_rating, y_star_rating, 1, 1, 0, col, 1);
}
if (show_spr_star_rating_cbn) {
	draw_sprite_ext(spr_star_rating_cbn, star_potential, x_star_potential, y_star_potential, 1, 1, 0, 16777215, 1);
}
if (show_spr_attitude) {
	draw_sprite_ext(spr_attitude, s_get_attitude_icon(ds_map_find_value(pmap, "attitude")), x_attitude, y_attitude, 1, 1, 0, 16777215, 1);
}
draw_sprite(spr_rookie, 0, x_rookie, y_rookie);
if (x_trade > 0) {
	draw_sprite_ext(spr_trade, 0, x_trade, y_trade, 1, 1, 0, 16777215, (sin(current_time / 160) + 1) / 2);
}
if (show_spr_condition) {
	if (i_condition > -1) {
		draw_hd_text_color(x_condition - 1, y_condition + 1, txt_condition, 0, 0, 0, 0, 1);
		draw_hd_text_color(x_condition, y_condition, txt_condition, col_condition, col_condition, col_condition, col_condition, 1);
		draw_sprite(spr_condition, i_condition, x_condition2, y_condition);
	} else {
		draw_hd_text_color(x_condition, y_condition, txt_condition, col_condition, col_condition, col_condition, col_condition, 1);
	}
}
