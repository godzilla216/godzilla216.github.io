function s_sound_audience_inc() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx") || obj_master.gamepractice) {
		return;
	}
	var snd = audio_play_sound(snd_audience_dis, 1, false);
	audio_sound_pitch(snd, random_range(0.9, 1));
	audio_sound_gain(snd, 0.5, 0);
}

