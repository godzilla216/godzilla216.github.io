function s_injury_effect_on_attitude() {
	with (obj_master) {
		var oc = s_get_staff(102);
		var dc = s_get_staff(101);
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(oc, "trait") == 8 && s_is_offensive_player(pmap)) {
				continue;
			} else if (ds_map_find_value(dc, "trait") == 8 && !s_is_offensive_player(pmap)) {
				continue;
			}
			if (ds_map_find_value(pmap, "condition") <= -1 && ds_map_find_value(pmap, "attitude") > 60) {
				ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") - 1 + irandom(5), 1, 100));
			}
		}
	}
}

