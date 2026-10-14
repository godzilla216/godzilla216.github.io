if (draw_box && sprite_index) {
	if (shadow) {
		draw_sprite_ext(sprite_index, 0, x - 2, y + 2, image_xscale, image_yscale, 0, 4210752, alpha);
	}
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, colour, alpha);
}
draw_set_font(font);
draw_set_halign(halign);
draw_set_valign(valign);
text = string_upper(text);
var tx = x;
var ty = y;
var a = alpha;
if (icon) {
	tx -= sprite_get_width(icon) * 0.25;
}
if (a == 1 && flashtext) {
	a = (sin(current_time / 160) + 1) / 2;
}
if (shadow) {
	draw_hd_text_ext_color(tx - 2, ty + 2, text, -1, sprite_width, 0, 0, 0, 0, a);
}
var max_str_w = sprite_width;
if (string_hd_width(text) >= sprite_width && string_pos(" ", text) == 0) {
	max_str_w = 1000;
}
draw_hd_text_ext_color(tx, ty, text, -1, max_str_w, tcolour, tcolour, tcolour, tcolour, a);
if (icon) {
	var tw = string_hd_width(text) * 0.5;
	tw += sprite_get_width(icon) * 0.5;
	draw_sprite(icon, 0, tx + tw, ty);
}
