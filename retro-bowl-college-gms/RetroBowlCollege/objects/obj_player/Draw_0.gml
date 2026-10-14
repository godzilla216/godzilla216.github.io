if (global.browser) {
	s_obj_player_draw_begin();
}
var ball = global.master_ball;
if (obj_controller.state == 3) {
	s_shader_set_uniforms();
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, 0, 16777215, 1);
	shader_reset();
	exit;
}
if (pmap && obj_controller.state != 10) {
	var a = (sin(current_time / 200) + 1) / 2;
	var col = 65535;
	if (ball.state == 0 && (sprite_index == spr_stand || sprite_index == spr_stand_thin || sprite_index == spr_stand_bulky)) {
		draw_sprite_ext(s_spr_from_bt(spr_stand_highlight, body_type), image_index, x, y - z, image_xscale, image_yscale, 0, col, a);
		draw_sprite_ext(spr_star_s, 0, x, y - z - sprite_height - 6, image_xscale, image_yscale, 0, col, a);
		if (pos_name3 != "") {
			draw_hd_text_transformed_color(x - 30 * obj_controller.drivedir, y - 15, pos_name3, 1.5, 1.5, 0, 0, 0, 0, 0, 1);
		}
	} else if (ball.state == 0 || ball.state == 2 || ball.state == 5 && ball.holder == id) {
		draw_sprite_ext(spr_star_s, 0, x, y - z - sprite_height - 6, image_xscale, image_yscale, 0, col, a);
	}
}
s_shader_set_uniforms();
draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, 0, 16777215, 1);
shader_reset();
