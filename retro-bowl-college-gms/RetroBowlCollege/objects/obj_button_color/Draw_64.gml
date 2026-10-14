draw_set_font(global.fnt_small_flex);
draw_set_halign(1);
var tx = x + sprite_width / 2;
var ty = y + sprite_height / 2;
tx += 1;
ty -= 1;
if (!active) {
	draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, 4210752, 1);
} else if (!clicked) {
	draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, colour, 1);
	var f = (sin(current_time / 60) + 1) / 2;
	if (s_is_ui_selected()) {
		if (f > 0.5) {
			draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, s_ui_selected_color(), 1);
		} else {
			draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, 16777215, 1);
		}
	}
	draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, colour, 1);
} else {
	draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, colour, 1);
	tx -= 2;
	ty += 2;
}
if (color_get_value(colour) < 230) {
	draw_set_color(0);
	draw_hd_text(tx - 1, ty + 1, string_upper(text));
	draw_set_color(16777215);
	draw_hd_text(tx, ty, string_upper(text));
} else {
	draw_set_color(16777215);
	draw_hd_text(tx - 1, ty + 1, string_upper(text));
	draw_set_color(0);
	draw_hd_text(tx, ty, string_upper(text));
	draw_set_color(16777215);
}
