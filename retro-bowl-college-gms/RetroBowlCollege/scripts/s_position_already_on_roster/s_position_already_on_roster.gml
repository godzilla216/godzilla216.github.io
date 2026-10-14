function s_position_already_on_roster(_arg0) {
	var pos = _arg0;
	for (var r = 0; r < ds_list_size(obj_master.roster); r++) {
		var pmap = ds_list_find_value(obj_master.roster, r);
		if (ds_map_find_value(pmap, "position") == pos) {
			return true;
		}
	}
	return false;
}

