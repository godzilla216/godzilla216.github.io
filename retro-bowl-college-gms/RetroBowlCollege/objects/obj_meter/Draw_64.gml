if (draw_box) {
	draw_self();
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x;
var ty = y;
var sw = 2 + string_hd_width(title) / 2;
var sh = 1 + string_hd_height(title) / 2;
tx += sprite_width / 2;
draw_rectangle_color(tx - sw - 2, ty - sh, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
draw_hd_text(tx, ty, string_upper(title));
var bw = sprite_width - 32;
if (!draw_icon) {
	bw = sprite_width - 16;
}
var prc = (bw - 4) / 100 * old_percent;
prc = clamp(prc, 1, bw);
var xbuf = 24;
if (!draw_icon) {
	xbuf = 8;
}
draw_rectangle_color(x + xbuf, y + 8, x + xbuf + bw, y + 24, global.c_backfill, global.c_backfill, global.c_backfill, global.c_backfill, 0);
draw_rectangle_color(x + xbuf + 2, y + 10, x + xbuf + 2 + prc, y + 22, colour, colour, colour, colour, 0);
if (draw_icon) {
	draw_sprite(draw_icon, 0, x + 14, y + 16);
}
if (draw_segments) {
	var sw = bw / 3;
	draw_line_width_color(x + xbuf + sw, y + 8, x + xbuf + sw, y + 24, 2, global.c_backfill, global.c_backfill);
	draw_line_width_color(x + xbuf + 2 + sw * 2, y + 8, x + xbuf + 2 + sw * 2, y + 24, 2, global.c_backfill, global.c_backfill);
}
