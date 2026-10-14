function s_count_defenders(_arg0) {
	var count = 0;
	if (_arg0 == -4) {
		slog("s_count_defenders. no cur_roster");
		return 0;
	}
	with (obj_master) {
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var pmap = ds_list_find_value(_arg0, i);
			if (s_is_defensive_player(pmap)) {
				count++;
			}
		}
	}
	return count;
}

