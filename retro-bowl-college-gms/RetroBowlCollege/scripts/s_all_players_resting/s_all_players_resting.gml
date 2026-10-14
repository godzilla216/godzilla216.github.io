function s_all_players_resting() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (!ds_map_find_value(pmap, "resting")) {
				return false;
			}
		}
	}
	return true;
}

