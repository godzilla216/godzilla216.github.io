function s_check_dummy_collision() {
	if (height < 24 && !global.master_ball.is_dead) {
		if (distance_to_object(obj_dummy) < 8) {
			slog("bheight:" + string(height));
			s_sound_bounce();
			if (lastheight >= 22) {
				other.zvel = 1;
			} else {
				direc += 180 + random_range(-30, 30);
			}
			switch (obj_master.gamepractice) {
				case 3:
				case 4:
					var qb = s_get_quarterback();
					var scr = (1 + point_distance(x, y, qb.x, qb.y)) / 20;
					scr *= 1 + obj_controller.practice_chain_qb_mode / 5;
					scr = round(scr);
					obj_controller.practice_score_qb_mode += scr;
					obj_controller.practice_chain_qb_mode += 1;
					obj_controller.tap_msg = "";
					state = 16;
					s_fieldtxt("+" + string(scr));
					s_sound_training_success(obj_controller.practice_chain_qb_mode);
					slog("Chain = " + string(obj_controller.practice_chain_qb_mode));
					break;
				default:
					state = 17;
					obj_controller.practice_chain_qb_mode = 0;
					s_sound(snd_error);
					break;
			}
		}
	}
}

function s_sound_training_success(_arg0) {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	var snd = audio_play_sound(snd_success, 1, false);
	var p = lerp(0.5, 1.5, min(_arg0, 20) / 20);
	audio_sound_pitch(snd, p);
}

