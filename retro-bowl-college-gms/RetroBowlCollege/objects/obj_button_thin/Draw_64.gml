if (s_is_new_shadow()) {
	draw_sprite_ext(sprite_index, 1, x, y, 1, 1, 0, global.c_shadow, 1);
	draw_sprite(sprite_index, 1, x + 2, y - 2);
} else {
	draw_sprite(sprite_index, image_index, x, y);
}
draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x + sprite_width / 2;
var ty = y + sprite_height / 2;
tx += 1;
ty -= 1;
if (!clicked) {
	var f = (sin(current_time / 60) + 1) / 2;
	if (s_is_ui_selected()) {
		draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, s_ui_selected_color(), 1);
	}
	draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, colour, 1);
} else {
	draw_sprite_ext(sprite_index, 2, x - 2, y + 2, 1, 1, 0, colour, 1);
	tx -= 2;
	ty += 2;
}
if (image && text != "") {
	draw_set_halign(2);
	draw_hd_text_color(tx, ty, text, tcolour, tcolour, tcolour, tcolour, 1);
	tx += 2 + sprite_get_width(image) / 2;
	draw_sprite_ext(image, 0, tx, ty, 1, 1, 0, 16777215, 1);
} else if (image) {
	draw_sprite(image, 0, tx, ty);
} else {
	draw_hd_text_color(tx, ty, string_upper(text), tcolour, tcolour, tcolour, tcolour, 1);
}
