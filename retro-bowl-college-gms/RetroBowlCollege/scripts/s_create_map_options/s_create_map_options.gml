function s_create_map_options() {
	slog("creating options map...");
	with (obj_master) {
		map_options = ds_map_create();
		ds_map_set(map_options, "my_version", 0);
		ds_map_set(map_options, "fullversion", 0);
		if (global.console_build || 0 || global.browser) {
			ds_map_set(map_options, "fullversion", 1);
		}
		ds_map_set(map_options, "op_drivedir", 0);
		ds_map_set(map_options, "op_scanlines", 0);
		ds_map_set(map_options, "op_weather", ds_map_find_value(map_options, "fullversion"));
		ds_map_set(map_options, "op_soundfx", 2);
		ds_map_set(map_options, "done_review_reward", 0);
		ds_map_set(map_options, "op_zoom", 1);
		ds_map_set(map_options, "op_music", 1);
		ds_map_set(map_options, "op_credits_purchased", 0);
		ds_map_set(map_options, "saveslot", -1);
		ds_map_set(map_options, "op_replays", 1);
		ds_map_set(map_options, "done_ad_retrogoal", 0);
		ds_map_set(map_options, "op_kickoffs", ds_map_find_value(map_options, "fullversion"));
		ds_map_set(map_options, "op_invert_throw", 0);
		ds_map_set(map_options, "op_gamepad_guides", 1);
		ds_map_set(map_options, "op_invert_throw_p2", 0);
		if (global.mobile_device) {
			ds_map_set(map_options, "op_drivedir", -1);
		}
		if (global.browser) {
			ds_map_set(map_options, "op_zoom", 0);
			ds_map_set(map_options, "op_replays", 0);
			ds_map_set(map_options, "op_soundfx", 1);
		}
		ds_map_set(map_options, "exh_op_weather", 0);
		ds_map_set(map_options, "exh_op_kickoffs", ds_map_find_value(map_options, "fullversion"));
		ds_map_set(map_options, "exh_op_drivedir", 1);
		ds_map_set(map_options, "exh_op_matchlength", 0);
		ds_map_set(map_options, "aa_video_watched", 0);
		s_save_options();
	}
}

