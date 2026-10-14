var bx = x + 2;
var by = y - 2;
if (clicked || !active) {
	bx = x;
	by = y;
}
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, global.c_shadow, 1);
var pos_col = global.c_headcoach;
draw_rectangle_color(bx + 2, by + 2, bx + sprite_width - 3, by + sprite_height - 3, pos_col, pos_col, pos_col, pos_col, 0);
if (s_is_ui_selected()) {
	draw_sprite_ext(sprite_index, image_index, bx, by, 1, 1, 0, s_ui_selected_color(), 1);
} else {
	draw_sprite(sprite_index, image_index, bx, by);
}
shader_set(sh_ColorReplaceBlend);
shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
shader_set_uniform_f(global.colorShirt, 0, 1, 0);
shader_set_uniform_f(global.colorPants, 1, 0, 1);
shader_set_uniform_f(global.replaceHelmet, helmet[0], helmet[1], helmet[2]);
shader_set_uniform_f(global.replaceShirt, shirt[0], shirt[1], shirt[2]);
shader_set_uniform_f(global.replacePants, pants[0], pants[1], pants[2]);
switch (coach_heads) {
	case 0:
		switch (skin) {
			case 2:
				switch (face_y) {
					case 0:
						draw_sprite_ext(s_face_from_set_direct(spr_light_001, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 1:
						draw_sprite_ext(s_face_from_set_direct(spr_light_002, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 2:
						draw_sprite_ext(s_face_from_set_direct(spr_light_003, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
				}
				break;
			case 1:
				switch (face_y) {
					case 0:
						draw_sprite_ext(s_face_from_set_direct(spr_mix_001, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
				}
				break;
			case 0:
				switch (face_y) {
					case 0:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_001, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 1:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_002, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 2:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_003, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 3:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_004, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 4:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_005, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 5:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_006, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 6:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_006, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 7:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_007, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
					case 8:
						draw_sprite_ext(s_face_from_set_direct(spr_dark_008, face_set), face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
						break;
				}
				break;
		}
		break;
	case 1:
		switch (face_y) {
			case 0:
				draw_sprite_ext(spr_coaches_01, face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
				break;
			case 1:
				draw_sprite_ext(spr_coaches_02, face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
				break;
			case 2:
				draw_sprite_ext(spr_coaches_03, face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
				break;
			case 3:
				draw_sprite_ext(spr_coaches_04, face_x, bx + 16, by + 3, 1, 1, 0, 16777215, 1);
				break;
		}
		break;
}
shader_reset();
