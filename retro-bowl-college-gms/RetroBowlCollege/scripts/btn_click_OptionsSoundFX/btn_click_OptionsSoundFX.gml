function btn_click_OptionsSoundFX() {
	with (obj_master) {
		slog("btn_click_OptionsSoundFX");
		ds_map_set(map_options, "op_soundfx", ds_map_find_value(map_options, "op_soundfx") + 1);
		if (ds_map_find_value(map_options, "op_soundfx") > 2) {
			ds_map_set(map_options, "op_soundfx", 0);
		}
		s_update_options();
		global.last_opt_music_change_time = get_timer();
	}
}

