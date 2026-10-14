function s_sound_audience_idle() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx") || obj_master.gamepractice) {
		return;
	}
	if (audio_is_playing(snd_audience_idle)) {
		audio_sound_gain(snd_audience_idle, 0.2, 1000);
	} else {
		var snd = audio_play_sound(snd_audience_idle, 1, true);
		audio_sound_gain(snd, 0, 0);
		audio_sound_gain(snd, 0.2, 1000);
		audio_sound_pitch(snd, 1);
	}
}

