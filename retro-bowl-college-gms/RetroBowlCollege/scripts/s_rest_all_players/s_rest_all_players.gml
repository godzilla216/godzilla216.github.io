function s_rest_all_players(_arg0) {
	var rest = _arg0;
	for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		switch (rest) {
			case true:
				if (!ds_map_find_value(pmap, "resting") && ds_map_find_value(pmap, "condition") < 40) {
					ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + 15, 1, 100));
				}
				ds_map_set(pmap, "resting", true);
				break;
			case false:
				if (ds_map_find_value(pmap, "resting") && ds_map_find_value(pmap, "condition") < 40) {
					ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") - 15, 1, 100));
				}
				ds_map_set(pmap, "resting", false);
				break;
		}
	}
}

