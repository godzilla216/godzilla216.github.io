function s_do_audible() {
	slog("s_do_audible");
	mouse_clear(1);
	with (obj_controller) {
		if (s_count_audibles() < 1) {
			with (global.master_ball) {
				with (holder) {
					s_fieldtxt(s_str("match_AudiblesNone") + "!");
				}
			}
		} else {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
				audio_play_sound(snd_audible, 1, false);
			}
			s_update_audibles(-1);
			s_set_up_play(true);
			with (obj_player) {
				if (position == 1) {
					s_fieldtxt(s_str("match_Audible") + "!");
				}
			}
		}
	}
}

