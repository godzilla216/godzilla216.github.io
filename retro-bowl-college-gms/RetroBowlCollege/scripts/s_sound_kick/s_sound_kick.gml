function s_sound_kick() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	if (audio_is_playing(snd_kick)) {
		return;
	}
	var snd = audio_play_sound(snd_kick, 1, false);
	audio_sound_pitch(snd, random_range(0.8, 1.2));
}

