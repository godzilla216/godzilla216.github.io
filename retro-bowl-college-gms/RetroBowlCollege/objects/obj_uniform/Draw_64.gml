s_shader_set_uniforms();
var body_spr = spr_player_edit;
if (s_is_co_mode()) {
	body_spr = spr_player_edit_co;
	if (body_type == 2) {
		body_spr = spr_player_edit_co;
	} else if (body_type == 1) {
		body_spr = spr_player_edit_co_thin;
	}
}
body_spr = spr_player_edit_co;
if (facing_right) {
	draw_sprite_ext(body_spr, background_im, x, y, scale, scale, 0, 16777215, 1);
} else {
	draw_sprite_ext(body_spr, background_im, x, y, -scale, scale, 0, 16777215, 1);
}
shader_reset();
