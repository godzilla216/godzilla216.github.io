function s_get_human_fixture_previous() {
	with (obj_master) {
		var prevfix = -4;
		for (var f = 0; f < ds_list_size(fixturelist); f++) {
			var fix = ds_list_find_value(fixturelist, f);
			if (fix && ds_map_find_value(fix, "human_win") == "unplayed") {
				return prevfix;
			}
			prevfix = fix;
		}
		return prevfix;
	}
}

