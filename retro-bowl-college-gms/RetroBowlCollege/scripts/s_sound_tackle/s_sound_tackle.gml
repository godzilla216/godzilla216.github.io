function s_sound_tackle() {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	if (current_time < global.snd_tackle_time + 50) {
		return;
	}
	var ball = global.master_ball;
	var snd = audio_play_sound(snd_tackle, 1, false);
	var dist = point_distance(x, y, ball.x, ball.y);
	dist = clamp(20 / dist, 0, 2);
	audio_sound_pitch(snd, random_range(0.8, 1.2));
	audio_sound_gain(snd, dist, 0);
	global.snd_tackle_time = current_time;
}

