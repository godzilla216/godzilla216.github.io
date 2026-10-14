var f = (sin(current_time / 60) + 1) / 2;
var col = 16777215;
if (s_is_ui_selected()) {
	col = s_ui_selected_color();
}
switch (state) {
	case false:
		draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, col, 1);
		break;
	case true:
		draw_sprite_ext(sprite_index, 1, x, y, 1, 1, 0, col, 1);
		break;
}
draw_set_font(global.fnt_small_flex);
draw_set_valign(1);
if (txt_side == 0) {
	draw_set_halign(2);
	draw_hd_text(x - 8, y + sprite_height * 0.5, text);
} else {
	draw_set_halign(0);
	draw_hd_text(x + 18, y + sprite_height * 0.5, text);
}
