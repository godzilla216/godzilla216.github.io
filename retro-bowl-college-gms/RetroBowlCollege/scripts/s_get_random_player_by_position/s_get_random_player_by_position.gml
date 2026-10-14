function s_get_random_player_by_position(_arg0, _arg1) {
	with (obj_master) {
		ds_list_shuffle(roster);
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (!_arg0) {
				if (ds_map_find_value(pmap, "condition") <= 0 || s_player_benched(pmap)) {
					continue;
				}
			}
			if (ds_map_find_value(pmap, "position") == _arg1) {
				return pmap;
			}
		}
	}
	return -4;
}

function s_get_random_player_by_position_from_roster(_arg0, _arg1, _arg2) {
	if (_arg2 == -4) {
		slog("s_get_random_player_by_position_from_roster. no cur_roster");
		return -4;
	}
	with (obj_master) {
		ds_list_shuffle(_arg2);
		for (var i = 0; i < ds_list_size(_arg2); i++) {
			var pmap = ds_list_find_value(_arg2, i);
			if (!_arg0) {
				if (ds_map_find_value(pmap, "condition") <= 0 || s_player_benched(pmap)) {
					continue;
				}
			}
			if (ds_map_find_value(pmap, "position") == _arg1) {
				return pmap;
			}
		}
	}
	return -4;
}

