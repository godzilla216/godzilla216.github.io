function s_toxic_effect_on_morale() {
	with (obj_master) {
		var of_coach = s_get_staff(102);
		var df_coach = s_get_staff(101);
		var of_negotiator = false;
		var df_negotiator = false;
		if (ds_map_find_value(of_coach, "trait") == 4) {
			of_negotiator = true;
		}
		if (ds_map_find_value(df_coach, "trait") == 4) {
			df_negotiator = true;
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "attitude") <= 15) {
				if (s_is_offensive_player(pmap)) {
					if (!of_negotiator) {
						for (var i = 0; i < ds_list_size(roster); i++) {
							var pmap2 = ds_list_find_value(roster, i);
							if (ds_map_find_value(pmap2, "attitude") > 30) {
								ds_map_set(pmap2, "attitude", ds_map_find_value(pmap2, "attitude") - irandom(3));
							}
						}
					}
				} else if (!df_negotiator) {
					for (var i = 0; i < ds_list_size(roster); i++) {
						var pmap2 = ds_list_find_value(roster, i);
						if (ds_map_find_value(pmap2, "attitude") > 30) {
							ds_map_set(pmap2, "attitude", ds_map_find_value(pmap2, "attitude") - irandom(3));
						}
					}
				}
			}
		}
	}
}

