var w = sprite_width;
var h = sprite_height;
if (fill_bg) {
	draw_set_colour(global.c_background);
	draw_rectangle(x + 2, y + 2, x + w - 2, y + h - 2, 0);
	draw_set_colour(colour);
}
var col = colour;
if (s_is_ui_selected()) {
	col = s_ui_selected_color();
}
draw_sprite_ext(spr_box, 0, x, y, 1, 1, 0, col, 1);
draw_sprite_ext(spr_box, 2, x + 4, y, (sprite_width - 8) / 4, 1, 0, col, 1);
draw_sprite_ext(spr_box, 1, x + w - 4, y, 1, 1, 0, col, 1);
draw_sprite_ext(spr_box, 3, x + w - 2, y + 4, 1, (sprite_height - 8) / 4, 0, col, 1);
draw_sprite_ext(spr_box, 0, x + w - 4, y + h - 4, 1, 1, 0, col, 1);
draw_sprite_ext(spr_box, 2, x + 4, y + h - 2, (sprite_width - 8) / 4, 1, 0, col, 1);
draw_sprite_ext(spr_box, 1, x, y + h - 4, 1, 1, 0, col, 1);
draw_sprite_ext(spr_box, 3, x, y + 4, 1, (sprite_height - 8) / 4, 0, col, 1);
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var _title = string_upper(self.title);
var tx = x;
var ty = y;
var sw = 2 + string_hd_width(_title) / 2;
var sh = string_hd_height(_title) / 2;
tx += sprite_width / 2;
if (_title != "") {
	draw_rectangle_color(tx - sw - 1, ty - sh, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_hd_text_color(tx, ty, _title, tcolour, tcolour, tcolour, tcolour, 1);
}
if (text != "") {
	ty = y + h * 0.5;
	sw = string_hd_width(text) / 2;
	sh = string_hd_height(text) / 2;
	draw_hd_text(tx, ty, text);
}
