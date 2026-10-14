function s_add_xp_gain_all(_arg0, _arg1) {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			var con = ds_map_find_value(pmap, "condition");
			if (_arg1 || con > 0) {
				ds_map_set(pmap, "xp_gain", round(ds_map_find_value(pmap, "xp_gain") + _arg0));
			}
		}
	}
}

