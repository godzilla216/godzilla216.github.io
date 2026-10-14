var f = (sin(current_time / 60) + 1) / 2;
if (s_is_ui_selected()) {
	draw_sprite_ext(sprite_index, selected ? 1 : 0, x, y, 1, 1, 0, s_ui_selected_color(), 1);
} else {
	draw_sprite(sprite_index, selected ? 1 : 0, x, y);
}
