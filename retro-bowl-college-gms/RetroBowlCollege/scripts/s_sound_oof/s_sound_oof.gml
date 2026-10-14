function s_sound_oof() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	var snd;
	switch (irandom(2)) {
		case 0:
			snd = audio_play_sound(snd_oof1, 1, false);
			break;
		case 1:
			snd = audio_play_sound(snd_oof2, 1, false);
			break;
		case 2:
			snd = audio_play_sound(snd_oof3, 1, false);
			break;
	}
	var ball = global.master_ball;
	var dist = point_distance(x, y, ball.x, ball.y);
	dist = clamp(20 / dist, 0, 2);
	audio_sound_pitch(snd, random_range(0.8, 1.2));
	audio_sound_gain(snd, dist, 0);
}

