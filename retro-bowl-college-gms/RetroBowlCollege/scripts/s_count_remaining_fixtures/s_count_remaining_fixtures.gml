function s_count_remaining_fixtures() {
	with (obj_master) {
		var count = 0;
		for (var f = 0; f < ds_list_size(fixturelist); f++) {
			var fix = ds_list_find_value(fixturelist, f);
			if (fix && ds_map_find_value(fix, "human_win") == "unplayed") {
				count++;
			}
		}
		return count;
	}
}

