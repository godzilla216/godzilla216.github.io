function s_sound(_arg0) {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	audio_play_sound(_arg0, 1, false);
}

function s_sound_brass_setup() {
	if (variable_global_exists("brass_sounds")) {
		global.brass_sounds = undefined;
	}
	global.brass_sounds = [snd_co_brass1, snd_co_brass2, snd_co_brass3, snd_co_brass4];
}

function s_sound_brass_loop(_arg0) {
	if (s_is_co_mode() == false) {
		return;
	}
	if (ds_map_find_value(obj_master.map_options, "op_soundfx") != 2) {
		return;
	}
	slog("s_sound_brass_loop");
	var isPlayingLog = "";
	for (var i = 0; i < array_length(global.brass_sounds); i++) {
		isPlayingLog += "isPlaying " + string(global.brass_sounds[i]) + "[" + string(audio_is_playing(global.brass_sounds[i])) + "] ";
	}
	slog(isPlayingLog);
	s_stop_brass_loop_finalize();
	obj_master.alarm[2] = -1;
	var index = irandom(array_length(global.brass_sounds) - 1);
	var rnd_sound = global.brass_sounds[index];
	audio_play_sound(rnd_sound, 1, true);
	audio_sound_gain(rnd_sound, _arg0, 0);
}

function s_stop_brass_loop() {
	if (s_is_co_mode() == false) {
		return;
	}
	var fadeout_time = 0.5;
	var isAnySoundPlaying = false;
	for (var i = 0; i < array_length(global.brass_sounds); i++) {
		if (audio_is_playing(global.brass_sounds[i])) {
			audio_sound_gain(global.brass_sounds[i], 0, 1000 * fadeout_time);
			isAnySoundPlaying = true;
		}
	}
	if (isAnySoundPlaying && obj_master.alarm[2] <= 0) {
		slog("s_stop_brass_loop");
		obj_master.alarm[2] = room_speed * fadeout_time;
	}
}

function s_stop_brass_loop_finalize() {
	if (s_is_co_mode() == false) {
		return;
	}
	slog("s_stop_brass_loop_finalize");
	for (var i = 0; i < array_length(global.brass_sounds); i++) {
		audio_stop_sound(global.brass_sounds[i]);
	}
}

