function s_get_human_fixture_next() {
	if (s_is_co_mode()) {
		return s_get_next_college_human_fixture();
	}
	with (obj_master) {
		for (var f = 0; f < ds_list_size(fixturelist); f++) {
			var fix = ds_list_find_value(fixturelist, f);
			if (fix && ds_map_find_value(fix, "human_win") == "unplayed") {
				return fix;
			}
		}
	}
	return -4;
}

