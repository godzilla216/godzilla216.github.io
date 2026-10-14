function s_load_options() {
	slog("loading options..." + global.g_optionsave);
	with (obj_master) {
		map_options = ds_map_secure_load(global.g_optionsave);
		if (!ds_exists(map_options, 1)) {
			slog("map_options does not exist");
			s_create_map_options();
			return;
		}
		if (is_undefined(ds_map_find_value(map_options, "my_version"))) {
			ds_map_set(map_options, "my_version", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "fullversion"))) {
			ds_map_set(map_options, "fullversion", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_soundfx"))) {
			ds_map_set(map_options, "op_soundfx", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_drivedir"))) {
			ds_map_set(map_options, "op_drivedir", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_scanlines"))) {
			ds_map_set(map_options, "op_scanlines", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_weather"))) {
			ds_map_set(map_options, "op_weather", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "done_review_reward"))) {
			ds_map_set(map_options, "done_review_reward", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_zoom"))) {
			ds_map_set(map_options, "op_zoom", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_music"))) {
			ds_map_set(map_options, "op_music", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_credits_purchased"))) {
			ds_map_set(map_options, "op_credits_purchased", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "saveslot"))) {
			ds_map_set(map_options, "saveslot", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_replays"))) {
			ds_map_set(map_options, "op_replays", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "done_ad_retrogoal"))) {
			ds_map_set(map_options, "done_ad_retrogoal", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_gamepad"))) {
			ds_map_set(map_options, "op_gamepad", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_kickoffs"))) {
			ds_map_set(map_options, "op_kickoffs", ds_map_find_value(map_options, "fullversion"));
		}
		if (is_undefined(ds_map_find_value(map_options, "op_invert_throw"))) {
			ds_map_set(map_options, "op_invert_throw", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_gamepad_guides"))) {
			ds_map_set(map_options, "op_gamepad_guides", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "op_invert_throw_p2"))) {
			ds_map_set(map_options, "op_invert_throw_p2", 0);
		}
		if (ds_map_find_value(map_options, "op_weather") == "true") {
			ds_map_set(map_options, "op_weather", 1);
		}
		if (ds_map_find_value(map_options, "op_weather") == "false") {
			ds_map_set(map_options, "op_weather", 0);
		}
		if (ds_map_find_value(map_options, "op_music") > 1) {
			ds_map_set(map_options, "op_music", 1);
		}
		if (!global.mobile_device) {
			ds_map_set(map_options, "fullversion", 1);
		}
		if (ds_map_find_value(map_options, "fullversion") < 1) {
			ds_map_set(map_options, "op_weather", 0);
		}
		ds_map_set(map_options, "op_invert_throw", clamp(ds_map_find_value(map_options, "op_invert_throw"), 0, 1));
		ds_map_set(map_options, "op_invert_throw_p2", clamp(ds_map_find_value(map_options, "op_invert_throw_p2"), 0, 1));
		if (!global.mobile_device && 1) {
			ds_map_set(map_options, "op_scanlines", 0);
		}
		if (ds_map_find_value(map_options, "op_soundfx") == "false") {
			ds_map_set(map_options, "op_soundfx", 0);
		}
		if (ds_map_find_value(map_options, "op_soundfx") == "true") {
			ds_map_set(map_options, "op_soundfx", 1);
		}
		if (global.browser) {
			ds_map_set(map_options, "op_soundfx", clamp(ds_map_find_value(map_options, "op_soundfx"), 0, 1));
		}
		if (is_undefined(ds_map_find_value(map_options, "exh_op_weather"))) {
			ds_map_set(map_options, "exh_op_weather", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "exh_op_kickoffs"))) {
			ds_map_set(map_options, "exh_op_kickoffs", ds_map_find_value(map_options, "fullversion"));
		}
		if (is_undefined(ds_map_find_value(map_options, "exh_op_drivedir"))) {
			ds_map_set(map_options, "exh_op_drivedir", 1);
		}
		if (is_undefined(ds_map_find_value(map_options, "exh_op_matchlength"))) {
			ds_map_set(map_options, "exh_op_matchlength", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "aa_video_watched"))) {
			ds_map_set(map_options, "aa_video_watched", 0);
		}
		if (is_undefined(ds_map_find_value(map_options, "co_op_color"))) {
			ds_map_set(map_options, "co_op_color", 0);
		}
	}
}

