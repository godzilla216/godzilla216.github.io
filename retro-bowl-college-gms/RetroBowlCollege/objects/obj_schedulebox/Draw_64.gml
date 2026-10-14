draw_self();
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var title = s_str("ui_Week") + " " + string(sweek);
var tx = x;
var ty = y;
var sw = 1 + string_hd_width(title) / 2;
var sh = 1 + string_hd_height(title) / 2;
tx += sprite_width / 2;
draw_rectangle_color(tx - sw - 1, ty - sh - 1, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
draw_hd_text(tx, ty, title);
tx = x + sprite_width * 0.25;
ty = y + 18;
for (var f = 0; f < 8; f++) {
	draw_set_alpha(str_fix_alf[f]);
	draw_set_colour(16777215);
	if (f == highlight) {
		draw_set_colour(global.c_primary);
	}
	draw_set_halign(1);
	draw_hd_text(tx, ty, str_fix_vs[f]);
	draw_set_halign(2);
	draw_hd_text(tx - buf, ty, str_fix_a[f]);
	draw_hd_text(tx - 4, ty, str_scr_a[f]);
	draw_set_halign(0);
	draw_hd_text(tx + buf, ty, str_fix_h[f]);
	draw_hd_text(tx + 4, ty, str_scr_h[f]);
	ty += 16;
}
tx = x + sprite_width * 0.75;
ty = y + 18;
for (var f = 8; f < 16; f++) {
	draw_set_alpha(str_fix_alf[f]);
	draw_set_colour(16777215);
	if (f == highlight) {
		draw_set_colour(global.c_primary);
	}
	draw_set_halign(1);
	draw_hd_text(tx, ty, str_fix_vs[f]);
	draw_set_halign(2);
	draw_hd_text(tx - buf, ty, str_fix_a[f]);
	draw_hd_text(tx - 4, ty, str_scr_a[f]);
	draw_set_halign(0);
	draw_hd_text(tx + buf, ty, str_fix_h[f]);
	draw_hd_text(tx + 4, ty, str_scr_h[f]);
	ty += 16;
}
draw_set_colour(16777215);
draw_set_alpha(1);
