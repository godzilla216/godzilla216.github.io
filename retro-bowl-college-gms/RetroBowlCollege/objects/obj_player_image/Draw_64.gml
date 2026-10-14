if (pmap == -4) {
	exit;
}
var pos = real(ds_map_find_value(pmap, "position"));
var bx = x - imw * 0.5 * scale;
var by = y;
shader_set(sh_ColorReplaceBlend);
shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
shader_set_uniform_f(global.colorShirt, 0, 1, 0);
shader_set_uniform_f(global.colorPants, 1, 0, 1);
shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
if (s_is_staff(ds_map_find_value(pmap, "position"))) {
	switch (ds_map_find_value(pmap, "face_y")) {
		case 0:
			draw_sprite_ext(spr_coaches_01, ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
			break;
		case 1:
			draw_sprite_ext(spr_coaches_02, ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
			break;
		case 2:
			draw_sprite_ext(spr_coaches_03, ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
			break;
		case 3:
			draw_sprite_ext(spr_coaches_04, ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
			break;
	}
} else {
	switch (ds_map_find_value(pmap, "skin")) {
		case 2:
			switch (ds_map_find_value(pmap, "face_y")) {
				case 0:
					draw_sprite_ext(s_face_from_set(spr_light_001, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 1:
					draw_sprite_ext(s_face_from_set(spr_light_002, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 2:
					draw_sprite_ext(s_face_from_set(spr_light_003, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
			}
			break;
		case 1:
			switch (ds_map_find_value(pmap, "face_y")) {
				case 0:
					draw_sprite_ext(s_face_from_set(spr_mix_001, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
			}
			break;
		case 0:
			switch (ds_map_find_value(pmap, "face_y")) {
				case 0:
					draw_sprite_ext(s_face_from_set(spr_dark_001, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 1:
					draw_sprite_ext(s_face_from_set(spr_dark_002, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 2:
					draw_sprite_ext(s_face_from_set(spr_dark_003, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 3:
					draw_sprite_ext(s_face_from_set(spr_dark_004, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 4:
					draw_sprite_ext(s_face_from_set(spr_dark_005, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 5:
					draw_sprite_ext(s_face_from_set(spr_dark_006, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 6:
					draw_sprite_ext(s_face_from_set(spr_dark_006, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 7:
					draw_sprite_ext(s_face_from_set(spr_dark_007, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
				case 8:
					draw_sprite_ext(s_face_from_set(spr_dark_008, pmap), ds_map_find_value(pmap, "face_x"), bx, by, scale, scale, 0, 16777215, 1);
					break;
			}
			break;
	}
}
shader_reset();
draw_set_font(global.fnt_small_flex);
draw_set_valign(1);
draw_set_halign(1);
var tx = x;
var ty = by + 60;
var name = string_copy(ds_map_find_value(pmap, "lname"), 1, 7);
draw_hd_text(tx, ty, string_upper(name));
