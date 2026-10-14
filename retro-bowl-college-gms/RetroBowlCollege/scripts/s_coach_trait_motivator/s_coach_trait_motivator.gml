function s_coach_trait_motivator(_arg0) {
	var smap = _arg0;
	with (obj_master) {
		s_meter_change(4, s_get_morale(), rm_frontoffice, "");
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (pmap) {
				if (s_is_offensive_player(smap) == s_is_offensive_player(pmap)) {
					ds_map_set(pmap, "attitude", real(ds_map_find_value(pmap, "attitude")) + 15);
					if (ds_map_find_value(pmap, "attitude") > 100) {
						ds_map_set(pmap, "attitude", 100);
					}
				}
			}
		}
	}
}

