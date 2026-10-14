draw_self();
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x;
var ty = y;
var sw = string_hd_width(title) / 2;
var sh = string_hd_height(title) / 2;
tx += sprite_width / 2;
draw_rectangle_color(tx - sw - 1, ty - sh - 1, tx + sw, ty + sh, global.c_background, global.c_background, global.c_background, global.c_background, 0);
draw_hd_text(tx + 0.5, ty, string_upper(title));
if (image) {
	tx = x + sprite_width * 0.5;
	ty = y + sprite_height * 0.5;
	if (!flash_rating || sin(current_time / 200) > 0.1) {
		draw_sprite_ext(image, image_num, tx, ty, 1, 1, 0, img_colour, 1);
	}
} else {
	draw_set_halign(0);
	tx = x + 16;
	ty = y + 16;
	draw_hd_text(tx, ty, string_upper(text));
	ty += 16;
}
