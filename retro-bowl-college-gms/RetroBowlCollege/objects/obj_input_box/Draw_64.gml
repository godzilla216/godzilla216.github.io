var f = (sin(current_time / 60) + 1) / 2;
if (editing || s_is_ui_selected() && f > 0.5) {
	draw_rectangle_color(x - 2, y - 2, x + sprite_width + 1.5, y + sprite_height + 1.5, s_ui_selected_color(), s_ui_selected_color(), s_ui_selected_color(), s_ui_selected_color(), 0);
}
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, colour, active ? 1 : 0.3);
draw_set_alpha(1);
draw_set_font(font);
draw_set_halign(halign);
draw_set_valign(valign);
var tx = x + sprite_width * 0.5;
var ty = y + sprite_height * 0.5;
if (editing) {
	var a = (sin(current_time / 100) + 1) / 2;
	draw_hd_text_color(tx + 3 + string_hd_width(g_pBuiltIn.keyboard_string) * 0.5, ty, "|", tcolour, tcolour, tcolour, tcolour, a);
	draw_hd_text_color(tx, ty, g_pBuiltIn.keyboard_string, tcolour, tcolour, tcolour, tcolour, 1);
} else {
	draw_hd_text_color(tx, ty, text, tcolour, tcolour, tcolour, tcolour, active ? 1 : 0.3);
}
