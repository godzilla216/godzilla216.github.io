function s_get_random_player_defensive(_arg0) {
	var inc_injured = _arg0;
	if (inc_injured) {
		return ds_list_find_value(obj_master.roster, irandom(size - 1));
	}
	with (obj_master) {
		ds_list_shuffle(roster);
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap) && s_is_defensive_player(pmap)) {
				return pmap;
			}
		}
	}
	return -4;
}

