function s_sound_dive() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	var ball = global.master_ball;
	var snd = audio_play_sound(snd_throw, 1, false);
	var dist = point_distance(x, y, ball.x, ball.y);
	dist = clamp(20 / dist, 0, 2);
	audio_sound_pitch(snd, 1.5);
	audio_sound_gain(snd, dist, 0);
}

