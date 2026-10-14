function s_count_players_onfield_by_position(_arg0, _arg1) {
	var pos = _arg0;
	var count = 0;
	if (_arg1 == -4) {
		slog2("s_count_players_onfield_by_position. no cur_roster");
		return 0;
	}
	with (obj_master) {
		for (var i = 0; i < ds_list_size(_arg1); i++) {
			var pmap = ds_list_find_value(_arg1, i);
			if (ds_map_find_value(pmap, "backup")) {
				continue;
			}
			if (ds_map_find_value(pmap, "condition") < 0) {
				continue;
			}
			if (s_player_benched(pmap)) {
				continue;
			}
			if (pos == 9 || pos == 8) {
				if (ds_map_find_value(pmap, "position") == 9 || ds_map_find_value(pmap, "position") == 8) {
					count++;
				}
			} else if (ds_map_find_value(pmap, "position") == pos) {
				count++;
			}
		}
	}
	return count;
}

