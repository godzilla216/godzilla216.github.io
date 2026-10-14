function s_draw_player_image(_arg0, _arg1, _arg2, _arg3) {
	if (_arg2 == -4) {
		return;
	}
	if (helmet[2] == -1) {
		if (uniform) {
			s_load_uniform_file2(ds_map_find_value(_arg2, "teamid"), uniform, 0, "");
			s_set_up_uniform_profile(uniform);
		} else {
			s_set_up_uniform_profile(-4);
		}
	}
	shader_set(sh_ColorReplaceBlend);
	shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
	shader_set_uniform_f(global.colorShirt, 0, 1, 0);
	shader_set_uniform_f(global.colorPants, 1, 0, 1);
	shader_set_uniform_f(global.replaceHelmet, helmet[2], helmet[1], helmet[0]);
	shader_set_uniform_f(global.replaceShirt, shirt[2], shirt[1], shirt[0]);
	shader_set_uniform_f(global.replacePants, pants[2], pants[1], pants[0]);
	if (s_is_staff(ds_map_find_value(_arg2, "position"))) {
		switch (ds_map_find_value(_arg2, "face_y")) {
			case 0:
				draw_sprite_ext(spr_coaches_01, ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
				break;
			case 1:
				draw_sprite_ext(spr_coaches_02, ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
				break;
			case 2:
				draw_sprite_ext(spr_coaches_03, ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
				break;
			case 3:
				draw_sprite_ext(spr_coaches_04, ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
				break;
		}
	} else {
		switch (ds_map_find_value(_arg2, "skin")) {
			case 2:
				switch (ds_map_find_value(_arg2, "face_y")) {
					case 0:
						draw_sprite_ext(s_face_from_set(spr_light_001, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 1:
						draw_sprite_ext(s_face_from_set(spr_light_002, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 2:
						draw_sprite_ext(s_face_from_set(spr_light_003, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
				}
				break;
			case 1:
				switch (ds_map_find_value(_arg2, "face_y")) {
					case 0:
						draw_sprite_ext(s_face_from_set(spr_mix_001, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
				}
				break;
			case 0:
				switch (ds_map_find_value(_arg2, "face_y")) {
					case 0:
						draw_sprite_ext(s_face_from_set(spr_dark_001, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 1:
						draw_sprite_ext(s_face_from_set(spr_dark_002, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 2:
						draw_sprite_ext(s_face_from_set(spr_dark_003, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 3:
						draw_sprite_ext(s_face_from_set(spr_dark_004, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 4:
						draw_sprite_ext(s_face_from_set(spr_dark_005, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 5:
						draw_sprite_ext(s_face_from_set(spr_dark_006, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 6:
						draw_sprite_ext(s_face_from_set(spr_dark_006, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 7:
						draw_sprite_ext(s_face_from_set(spr_dark_007, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
					case 8:
						draw_sprite_ext(s_face_from_set(spr_dark_008, _arg2), ds_map_find_value(_arg2, "face_x"), _arg0, _arg1, _arg3, _arg3, 0, 16777215, 1);
						break;
				}
				break;
		}
	}
	shader_reset();
}

