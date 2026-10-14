function s_sound_bounce() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	slog("s_sound_bounce");
	var snd = audio_play_sound(snd_bounce, 1, false);
	audio_sound_pitch(snd, random_range(0.8, 1.2));
}

