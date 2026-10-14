draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
draw_set_valign(1);
var sep = -1;
if (string_hd_height_ext(text, sep, msg_width) > 150) {
	sep = 12;
}
if (draw_box) {
	var w = 16 + string_hd_width_ext(text, sep, msg_width);
	var tw = 16 + string_hd_width_ext(self.title, sep, msg_width);
	if (tw > w) {
		w = tw;
	}
	var h = 16 + string_hd_height_ext(text, sep, msg_width);
	var bx = x - w * 0.5;
	var by = y - h * 0.5;
	draw_rectangle_color(bx + 2, by + 2, bx + w - 2, by + h - 2, colour, colour, colour, colour, 0);
	draw_sprite(spr_box, 0, bx, by);
	draw_sprite_ext(spr_box, 2, bx + 4, by, (w - 8) / 4, 1, 0, 16777215, 1);
	draw_sprite(spr_box, 1, bx + w - 4, by);
	draw_sprite_ext(spr_box, 3, bx + w - 2, by + 4, 1, (h - 8) / 4, 0, 16777215, 1);
	draw_sprite(spr_box, 0, bx + w - 4, by + h - 4);
	draw_sprite_ext(spr_box, 2, bx + 4, by + h - 2, (w - 8) / 4, 1, 0, 16777215, 1);
	draw_sprite(spr_box, 1, bx, by + h - 4);
	draw_sprite_ext(spr_box, 3, bx, by + 4, 1, (h - 8) / 4, 0, 16777215, 1);
}
if (text_shadow) {
	draw_set_color(0);
	draw_hd_text_ext(x - 1, y + 1, text, sep, msg_width);
}
draw_set_color(text_col);
draw_hd_text_ext(x, y, text, sep, msg_width);
draw_set_color(16777215);
var h = 16 + string_hd_height_ext(text, sep, msg_width);
var by = y - h * 0.5;
if (self.title == "") {
	exit;
}
var _title = string_upper(self.title);
var tx = x;
var ty = by;
var sw = 2 + string_hd_width(_title) / 2;
var sh = string_hd_height(_title) / 2;
tx += sprite_width / 2;
if (_title != "") {
	draw_rectangle_color(tx - sw - 2, ty - sh + 1, tx + sw + 1, ty + sh - 6, 16777215, 16777215, 16777215, 16777215, 0);
	draw_rectangle_color(tx - sw - 1, ty - sh, tx + sw + 0, ty + sh - 6, 16777215, 16777215, 16777215, 16777215, 0);
	draw_rectangle_color(tx - sw, ty - sh + 2, tx + sw - 1, ty + sh - 2, colour, colour, colour, colour, 0);
	if (title_shadow) {
		draw_hd_text_color(tx - 1, ty + 1, _title, 0, 0, 0, 0, 1);
	}
	draw_hd_text_color(tx, ty, _title, 16777215, 16777215, 16777215, 16777215, 1);
}
