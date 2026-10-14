function s_do_timeout() {
	slog("s_do_timeout");
	mouse_clear(1);
	with (obj_controller) {
		if (s_count_timeouts()) {
			if (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
				audio_play_sound(snd_click, 1, false);
				audio_play_sound(snd_timeout, 1, false);
			}
			s_update_timeouts(-1);
			timeout_called = true;
			with (obj_ball) {
				s_fieldtxt(s_str("match_TimeOut") + "!");
			}
			instance_destroy(obj_btn_timeout);
		}
	}
}

