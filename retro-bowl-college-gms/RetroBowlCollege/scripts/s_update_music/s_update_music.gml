function s_update_music() {
	if (global.browser && !audio_system_is_available()) {
		return;
	}
	var music = snd_music;
	music = snd_music_co;
	switch (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		case 0:
		case 1:
			if (audio_is_playing(music)) {
				audio_stop_sound(music);
			}
			break;
		case 2:
			if (instance_exists(obj_controller) && audio_is_playing(music)) {
				audio_sound_gain(music, 0, 2500);
				return;
			}
			if (!audio_is_playing(music)) {
				slog2("audio_play_sound music");
				audio_stop_sound(music);
				audio_play_sound(music, 0, true);
				audio_sound_gain(music, 0.6, 1);
			} else {
				audio_sound_gain(music, 0.6, 5000);
			}
			break;
	}
}

function s_update_music_safe() {
	var cur_time = get_timer();
	slog("- s_update_music_safe cur_time: " + string(cur_time) + " last_opt_music_change_time: " + string(global.last_opt_music_change_time) + " diff: " + string(cur_time - global.last_opt_music_change_time));
	if (cur_time - global.last_opt_music_change_time >= 2000000) {
		s_update_music();
	}
}

