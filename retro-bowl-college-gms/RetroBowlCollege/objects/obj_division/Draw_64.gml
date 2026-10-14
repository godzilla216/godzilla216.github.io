if (s_is_co_mode()) {
	s_co_division_draw_gui();
	exit;
}
var gx = x;
var gy = y;
if (active) {
	draw_sprite_ext(sprite_index, image_index, x - 2, y + 2, 1, 1, 0, 4210752, 1);
}
if (clicked) {
	gx -= 2;
	gy += 2;
}
draw_set_alpha(alpha);
draw_rectangle_color(gx + 2, gy, gx + 2 + sprite_width - 4, gy + 2 + sprite_height - 4, global.c_background, global.c_background, global.c_background, global.c_background, 0);
draw_sprite(sprite_index, image_index, gx, gy);
if (s_is_ui_selected()) {
	var f = (sin(current_time / 60) + 1) / 2;
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
var tx = gx;
var ty = gy;
var sw = 1 + string_hd_width(title);
var sh = string_hd_height(title) / 2;
tx += 16;
draw_set_alpha(1);
draw_rectangle_color(tx - 2, ty - sh, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
draw_set_alpha(alpha);
draw_hd_text(tx, ty, string_upper(title));
draw_set_halign(1);
tx = gx + sprite_width - 56;
switch (mode) {
	case 0:
		draw_set_alpha(1);
		draw_rectangle_color(tx - 14, ty - sh, tx + 48, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
		draw_set_alpha(alpha);
		draw_hd_text(tx, ty, string_upper(s_str("tla_Percentage")));
		tx += 35;
		draw_hd_text(tx, ty, string_upper(s_str("tla_NetPoints")));
		break;
	case 1:
		draw_set_alpha(1);
		draw_rectangle_color(tx - 8, ty - sh, tx + 46, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
		draw_set_alpha(alpha);
		draw_hd_text(tx, ty, s_str("sla_Wins"));
		tx += 20;
		draw_hd_text(tx, ty, s_str("sla_Losses"));
		tx += 20;
		draw_hd_text(tx, ty, s_str("sla_Ties"));
		break;
	case 2:
		draw_set_alpha(1);
		draw_rectangle_color(tx - 14, ty - sh, tx + 48, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
		draw_set_alpha(alpha);
		draw_hd_text(tx, ty, string_upper(s_str("tla_Offense")));
		tx += 35;
		draw_hd_text(tx, ty, string_upper(s_str("tla_Defense")));
		break;
}
ty = gy + 16;
for (var t = 0; t < 4; t++) {
	tx = gx + 16;
	draw_set_halign(0);
	draw_hd_text_color(tx, ty, string_upper(team_name[t]), col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
	tx = gx + sprite_width - 56;
	draw_set_halign(1);
	switch (mode) {
		case 0:
			draw_hd_text_color(tx, ty, pct[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			tx += 35;
			draw_hd_text_color(tx, ty, net[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			break;
		case 1:
			draw_hd_text_color(tx, ty, wins[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			tx += 20;
			draw_hd_text_color(tx, ty, losses[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			tx += 20;
			draw_hd_text_color(tx, ty, ties[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			break;
		case 2:
			draw_hd_text_color(tx, ty, offense[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			tx += 35;
			draw_hd_text_color(tx, ty, defense[t], col_txt[t], col_txt[t], col_txt[t], col_txt[t], alpha);
			break;
	}
	ty += 16;
}
draw_set_alpha(1);
