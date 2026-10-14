function s_sound_loop(_arg0) {
	if (!ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		return;
	}
	audio_play_sound(_arg0, 1, true);
}

