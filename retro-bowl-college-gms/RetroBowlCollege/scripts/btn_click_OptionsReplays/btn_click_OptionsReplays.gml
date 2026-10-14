function btn_click_OptionsReplays() {
	with (obj_master) {
		ds_map_set(map_options, "op_replays", ds_map_find_value(map_options, "op_replays") + 1);
		if (ds_map_find_value(map_options, "op_replays") > 2) {
			ds_map_set(map_options, "op_replays", 0);
		}
		s_update_options();
	}
}

