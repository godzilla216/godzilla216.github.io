function s_set_team_morale(_arg0, _arg1) {
	var amt_min = _arg0;
	var amt_max = _arg1;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "attitude", clamp(irandom_range(amt_min, amt_max), 1, 100));
		}
	}
}

