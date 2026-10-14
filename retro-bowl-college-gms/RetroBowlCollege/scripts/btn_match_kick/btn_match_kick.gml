function btn_match_kick() {
	mouse_clear(1);
	if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		audio_play_sound(snd_click, 1, false);
		audio_play_sound(snd_audible, 1, false);
	}
	with (obj_controller) {
		s_update_timeouts(-1);
		if (scrimmage > 0) {
			btn_response_fg_yes();
		} else {
			btn_response_punt_yes();
		}
	}
}

function btn_match_goforit() {
	mouse_clear(1);
	if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		audio_play_sound(snd_click, 1, false);
		audio_play_sound(snd_audible, 1, false);
	}
	with (obj_controller) {
		s_update_timeouts(-1);
		s_set_up_play(true);
	}
}

function btn_match_gofor1pt() {
	mouse_clear(1);
	if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		audio_play_sound(snd_click, 1, false);
		audio_play_sound(snd_audible, 1, false);
	}
	with (obj_controller) {
		s_update_timeouts(-1);
		s_set_up_fieldgoal(2);
	}
}

