function s_get_player_by_position(_arg0, _arg1) {
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "backup")) {
				continue;
			}
			if (ds_map_find_value(pmap, "condition") < 0) {
				continue;
			}
			if (s_player_benched(pmap)) {
				continue;
			}
			if (ds_map_find_value(pmap, "position") == _arg0) {
				count++;
				if (count == _arg1) {
					return pmap;
				}
			}
		}
	}
	return -4;
}

function s_get_player_by_position_from_roster(_arg0, _arg1, _arg2) {
	if (_arg2 == -4) {
		slog2("s_get_player_by_position. no cur_roster");
		return -4;
	}
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(_arg2); i++) {
			var pmap = ds_list_find_value(_arg2, i);
			if (ds_map_find_value(pmap, "backup")) {
				continue;
			}
			if (ds_map_find_value(pmap, "condition") < 0) {
				continue;
			}
			if (s_player_benched(pmap)) {
				continue;
			}
			if (ds_map_find_value(pmap, "position") == _arg0) {
				count++;
				if (count == _arg1) {
					return pmap;
				}
			}
		}
	}
	return -4;
}

function s_get_player_kick_returner(_arg0) {
	if (_arg0 == -4) {
		slog2("s_get_player_kick_returner. no cur_roster");
		return -4;
	}
	with (obj_master) {
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var pmap = ds_list_find_value(_arg0, i);
			if (ds_map_find_value(pmap, "condition") < 0) {
				continue;
			}
			if (s_player_benched(pmap)) {
				continue;
			}
			if (ds_map_exists(pmap, "kr") && ds_map_find_value(pmap, "kr") == 1) {
				return pmap;
			}
		}
	}
	return -4;
}

