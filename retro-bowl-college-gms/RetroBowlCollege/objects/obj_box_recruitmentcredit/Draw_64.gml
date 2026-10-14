draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x;
var ty = y;
var sw = string_hd_width(title) / 2;
var sh = string_hd_height(title) / 2;
if (show_frame) {
	draw_self();
	tx += sprite_width / 2;
	draw_rectangle_color(tx - sw - 1, ty - sh - 1, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
	draw_hd_text(tx + 0.5, ty, string_upper(title));
}
if (!flash || sin(current_time / 200) > 0.1) {
	var imw = 0;
	if (image != -4) {
		imw = sprite_get_width(image);
	}
	tx = x + sprite_width / 2;
	ty = y + sprite_height * 0.5;
	tx -= imw / 2;
	draw_hd_text(tx, ty, text);
	if (image != -4) {
		var tw = string_hd_width(text) * 0.5;
		tw += sprite_get_width(image) * 0.5;
		draw_sprite_ext(image, image_num, tx + tw + 1, ty, 1, 1, 0, img_colour, 1);
	}
}
