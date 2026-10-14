draw_self();
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
draw_set_valign(1);
var tx = x;
var ty = y;
var sw = string_hd_width(title) / 2;
var sh = string_hd_height(title) / 2;
tx += sprite_width / 2;
if (title != "") {
	draw_rectangle_color(tx - sw - 1, ty - sh - 1, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_hd_text(tx + 0.5, ty, string_upper(title));
}
if (image != -4 && text != "") {
	tx = x + sprite_width * 0.5;
	ty = y + sprite_height * 0.5;
	var tw = string_hd_width(text) * 0.5;
	tw += 2 + sprite_get_width(image) * 0.5;
	tw *= 0.5;
	draw_hd_text(tx - tw, ty, text);
	draw_sprite_ext(image, image_num, tx + tw, ty, 1, 1, 0, img_colour, 1);
} else if (image != -4) {
	tx = x + sprite_width * 0.5;
	ty = y + sprite_height * 0.5;
	draw_sprite_ext(image, image_num, tx, ty, 1, 1, 0, img_colour, 1);
} else {
	tx = x + sprite_width * 0.5;
	ty = y + sprite_height * 0.5;
	draw_hd_text(tx, ty, string_upper(text));
	ty += 16;
}
