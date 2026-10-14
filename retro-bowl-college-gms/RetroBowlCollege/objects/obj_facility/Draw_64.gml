draw_self();
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x;
var ty = y;
var sw = 2 + string_hd_width(title) / 2;
var sh = 1 + string_hd_height(title) / 2;
tx += sprite_width / 2;
draw_rectangle_color(tx - sw - 2, ty - sh, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
draw_hd_text(tx, ty, string_upper(title));
var bw = sprite_width - 16;
draw_rectangle_color(x + 8, y + 8, x + 8 + bw, y + 24, global.c_backfill, global.c_backfill, global.c_backfill, global.c_backfill, 0);
bw -= 4;
var prc = clamp(bw / 10 * percent, 1, bw);
draw_rectangle_color(x + 10, y + 10, x + 10 + prc, y + 22, colour, colour, colour, colour, 0);
var sw = bw / 10;
for (var i = 0; i < 9; i++) {
	draw_line_width_color(x + 10 + sw, y + 8, x + 10 + sw, y + 24, 2, global.c_backfill, global.c_backfill);
	sw += bw / 10;
}
