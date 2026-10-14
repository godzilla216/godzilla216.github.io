function s_get_random_player(_arg0, _arg1) {
	with (obj_master) {
		if (_arg0 && _arg1 == undefined) {
			return ds_list_find_value(roster, irandom(ds_list_size(roster) - 1));
		}
		ds_list_shuffle(roster);
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (!_arg0) {
				if (ds_map_find_value(pmap, "condition") < 0) {
					continue;
				}
				if (ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup")) {
					continue;
				}
				if (s_player_benched(pmap)) {
					continue;
				}
			}
			if (_arg1 != undefined) {
				if (ds_list_find_index(_arg1, pmap) >= 0) {
					continue;
				}
			}
			return pmap;
		}
	}
	return -4;
}

