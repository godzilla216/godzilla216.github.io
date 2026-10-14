draw_set_font(global.fnt_small_flex);
draw_set_halign(0);
var tx = x;
var ty = y - 8;
draw_hd_text(tx, ty, string_upper(title));
var bw = sprite_width - 5;
var bh = sprite_height - 3;
var prc = bw / 100 * percent;
prc = clamp(prc, 1, bw);
var prc_buff = bw / 100 * (percent + buff * 10);
prc_buff = clamp(prc_buff, 1, bw);
var pot = bw / 100 * potential;
pot = clamp(pot, 1, bw);
draw_sprite_ext(sprite_index, 1, x, y, 1, 1, 0, global.c_backfill, 1);
var col = global.c_primary;
draw_rectangle_color(x + 2, y + 2, x + 2 + pot, y + bh, col, col, col, col, 0);
draw_rectangle_color(x + 3, y + 3, x + 3 + pot - 2, y + bh - 1, global.c_backfill, global.c_backfill, global.c_backfill, global.c_backfill, 0);
if (flash) {
	var a = 1 + sin(current_time / 160) / 2;
	draw_set_alpha(a);
}
if (buff && percent < 100) {
	draw_rectangle_color(x + 2, y + 2, x + 2 + prc_buff, y + bh, col_buff, col_buff, col_buff, col_buff, 0);
	draw_set_halign(1);
	draw_set_valign(1);
	draw_text_color(x + prc_buff - 7, y + 9, "+1", 0, 0, 0, 0, 0.4);
}
draw_rectangle_color(x + 2, y + 2, x + 2 + prc, y + bh, col, col, col, col, 0);
draw_set_alpha(1);
