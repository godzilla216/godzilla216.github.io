function s_obj_controller_draw_begin() {
	var fieldfans = s_is_co_mode() ? spr_fieldfans_co : spr_fieldfans;
	var field = s_is_co_mode() ? spr_field_co : spr_field;
	var sideline_crew = s_is_co_mode() ? spr_sideline_crew_co : spr_sideline_crew;
	var show_band = s_is_co_mode();
	var show_field_text = s_is_co_mode();
	if (!obj_master.gamepractice) {
		draw_sprite_ext(field, field_type, 0, 66, 2, 2, 0, 16777215, 1);
		shader_set(sh_ColorReplaceBlend);
		shader_set_uniform_f(global.colorHelmet, 1, 0, 0);
		shader_set_uniform_f(global.colorShirt, 0.5, 0.5, 1);
		shader_set_uniform_f(global.colorPants, 1, 0, 1);
		shader_set_uniform_f(global.colorPants_b, 0, 0, 0.5);
		shader_set_uniform_f(global.colorCleats, 1, 1, 0);
		shader_set_uniform_f(global.colorSleeve, 0.875, 0.443, 0.149);
		shader_set_uniform_f(global.colorLogo, 0.5, 0, 0);
		shader_set_uniform_f(global.colorSocks, 0, 1, 0);
		shader_set_uniform_f(global.colorSocks_b, 0, 0.5, 0);
		shader_set_uniform_f(global.replaceHelmet, shd_helmet[2], shd_helmet[1], shd_helmet[0]);
		shader_set_uniform_f(global.replaceShirt, shd_shirt[2], shd_shirt[1], shd_shirt[0]);
		shader_set_uniform_f(global.replacePants, shd_pants[2], shd_pants[1], shd_pants[0]);
		shader_set_uniform_f(global.replacePants_b, 0.9, 0.9, 0.9);
		shader_set_uniform_f(global.replaceCleats, 0.1, 0.1, 0.1);
		shader_set_uniform_f(global.replaceSleeve, shd_shirt[2] * 0.8, shd_shirt[1] * 0.8, shd_shirt[0] * 0.8);
		shader_set_uniform_f(global.replaceLogo, shd_logo[2], shd_logo[1], shd_logo[0]);
		shader_set_uniform_f(global.replaceSocks, shd_socks1[2], shd_socks1[1], shd_socks1[0]);
		shader_set_uniform_f(global.replaceSocks_b, shd_socks2[2], shd_socks2[1], shd_socks2[0]);
		draw_sprite_ext(fieldfans, 0, 0, 0, 2, 2, 0, 16777215, 1);
		draw_sprite_ext(sideline_crew, 0, 998, 64, 2, 2, 0, 16777215, 1);
		draw_sprite_ext(spr_sideline_crew2_noout, 0, 682, 68, 2, 2, 0, 16777215, 1);
		var i = cheer_frame;
		var cl_adjust = 30;
		if (camera_get_view_x(view_camera[0]) < 1300) {
			draw_sprite_ext(spr_cl1, i, 250 + cl_adjust, 100, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl3, i + 2.5, 220 + cl_adjust, 110, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl5, i, 190 + cl_adjust, 100, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl2, i + 7.5, 160 + cl_adjust, 110, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl4, i + 5, 130 + cl_adjust, 100, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl2, i, 250, 528, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl4, i + 2.5, 220, 518, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl6, i, 190, 528, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl1, i + 7.5, 160, 518, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl3, i + 5, 130, 528, 2, 2, 0, 16777215, 1);
		} else {
			draw_sprite_ext(spr_cl6, i, 2350 - cl_adjust, 100, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl4, i + 2.5, 2380 - cl_adjust, 110, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl2, i, 2410 - cl_adjust, 100, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl1, i + 7.5, 2440 - cl_adjust, 110, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl3, i + 5, 2470 - cl_adjust, 100, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl5, i, 2350, 528, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl3, i + 2.5, 2380, 518, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl1, i, 2410, 528, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl6, i + 7.5, 2440, 518, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_cl4, i + 5, 2470, 528, 2, 2, 0, 16777215, 1);
		}
		if (show_band) {
			if (camera_get_view_x(view_camera[0]) < 1300) {
				draw_sprite_ext(spr_band_flute, i, 328, 61, 2, 2, 0, 16777215, 1);
				if (scored_by == 1) {
					draw_sprite_ext(spr_band_drum1, i, 364, 61, 2, 2, 0, 16777215, 1);
				} else {
					draw_sprite_ext(spr_band_drum1_rest, 0, 364, 61, 2, 2, 0, 16777215, 1);
				}
				draw_sprite_ext(spr_band_trumpet, i, 398, 61, 2, 2, 0, 16777215, 1);
				draw_sprite_ext(spr_band_horn, i, 436, 61, 2, 2, 0, 16777215, 1);
				draw_sprite_ext(spr_band_drum2, i, 346, 66, 2, 2, 0, 16777215, 1);
				draw_sprite_ext(spr_band_sax, i, 414, 66, 2, 2, 0, 16777215, 1);
				draw_sprite_ext(spr_band_conductor, i, 384, 68, 2, 2, 0, 16777215, 1);
			}
		}
		shader_reset();
	} else if (obj_master.qb_mode) {
		draw_sprite_ext(spr_fieldfans, 2, 0, 0, 2, 2, 0, 16777215, 1);
		draw_sprite_ext(field, field_type, 0, 66, 2, 2, 0, 16777215, 1);
	} else {
		draw_sprite_ext(fieldfans, 1, 0, 0, 2, 2, 0, 16777215, 1);
		draw_sprite_ext(field, field_type, 0, 66, 2, 2, 0, 16777215, 1);
	}
	if (field_type != 5 && field_type != 6) {
		draw_sprite_ext(spr_endzone, field_type, 100, 132, 2, 2, 0, c_endzone, 1);
		draw_sprite_ext(spr_endzone, field_type, 2302, 132, 2, 2, 0, c_endzone, 1);
		if (show_field_text) {
			draw_sprite_ext(spr_endzone_text, 0, 100, 132, 2, 2, 0, 16777215, 1);
			draw_sprite_ext(spr_endzone_text, 1, 2302, 132, 2, 2, 0, 16777215, 1);
		}
	}
	switch (state) {
		case 10:
			if (state_previous == 1) {
				break;
			}
		case 2:
			if (kicking) {
				s_draw_kick_cone();
			} else if (!obj_master.gamepractice) {
				s_draw_scrimmage();
			}
			break;
		case 3:
			if (last_play != 1 && global.replay_end != 6 && global.replay_end != 7) {
				s_draw_scrimmage();
			}
			return;
			break;
		default:
			return;
			break;
	}
	if (obj_master.gamepractice != 2) {
		with (global.master_ball) {
			if (xdead > 0) {
				var col = 255;
				if (state == 14) {
					col = 65280;
				}
				draw_sprite_ext(spr_bouncespot, 0, xdead, ydead, 2, 2, 0, col, 1);
			}
		}
	} else if (obj_controller.practice_success > 0 && !global.gamepad) {
		with (global.master_ball) {
			if (state == 2) {
				var s = 2.5 + sin(current_time / 100) * 0.5;
				var r = 0;
				if (obj_controller.drivedir == 1) {
					r = 180;
				}
				draw_sprite_ext(spr_wind, 0, holder.x + obj_controller.drivedir * -100, holder.y, s, s, r, 16777215, 0.5);
			}
		}
	}
}

