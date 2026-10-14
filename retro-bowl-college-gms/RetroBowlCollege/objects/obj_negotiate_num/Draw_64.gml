shader_set(sh_ColorReplaceBlend);
shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
shader_set_uniform_f(global.colorShirt, 0, 1, 0);
shader_set_uniform_f(global.colorPants, 1, 0, 1);
shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
draw_sprite_ext(spr_negotiate_num, 0, x, y, scl + 1, scl + 1, 0, 16777215, 1);
shader_reset();
draw_set_font(fnt_tecmo_small);
draw_set_halign(1);
draw_set_valign(1);
if (position < 0 || revealed) {
	draw_hd_text_transformed(x, y + 3 * scl, string(number), scl, scl, 0);
} else {
	draw_hd_text_transformed(x, y + 3 * scl, "?", scl, scl, 0);
}
