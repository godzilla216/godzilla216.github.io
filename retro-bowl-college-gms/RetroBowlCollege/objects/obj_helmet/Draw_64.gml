s_shader_set_uniforms();
draw_sprite_ext(sprite_index, image, x, y, 2, 2, 0, 16777215, 1);
if (facing == 1) {
	draw_sprite_ext(spr_stand, 0, x + 100, y - 20, 2, 2, 0, 16777215, 1);
} else {
	draw_sprite_ext(spr_stand, 0, x - 100, y - 20, -2, 2, 0, 16777215, 1);
}
shader_reset();
draw_set_font(global.fnt_flex);
draw_set_halign(1);
draw_set_valign(1);
var ty = y + 72;
draw_hd_text(x, ty, string_upper(name));
draw_set_font(global.fnt_small_flex);
ty += 16;
if (show_stats) {
	draw_hd_text(x, ty, record);
}
draw_set_halign(2);
if (facing == -1) {
	draw_set_halign(0);
}
if (!show_stats) {
	exit;
}
ty += 14;
draw_hd_text(x, ty, string_upper(s_str("ui_Defense")));
var sx = x;
if (facing == 1) {
	draw_sprite_ext(spr_star_rating, defense, sx + 5, ty, 1, 1, 0, 65535, 1);
} else {
	draw_sprite_ext(spr_star_rating, defense, sx - 5, ty, -1, 1, 0, 65535, 1);
}
ty += 14;
draw_hd_text(x, ty, string_upper(s_str("ui_Offense")));
if (facing == 1) {
	draw_sprite_ext(spr_star_rating, offense, sx + 5, ty, 1, 1, 0, 65535, 1);
} else {
	draw_sprite_ext(spr_star_rating, offense, sx - 5, ty, -1, 1, 0, 65535, 1);
}
