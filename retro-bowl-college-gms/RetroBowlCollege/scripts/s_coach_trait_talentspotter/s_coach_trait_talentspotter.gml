function s_coach_trait_talentspotter(_arg0) {
	var smap = _arg0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (s_is_offensive_player(smap) == s_is_offensive_player(pmap)) {
				var current_pot = s_get_player_potential(pmap);
				slog("Player = " + ds_map_find_value(pmap, "lname"));
				slog("s_get_player_potential = " + string(current_pot));
				if (current_pot < 10) {
					while (s_get_player_potential(pmap) <= current_pot) {
						switch (irandom(3)) {
							case 0:
								ds_map_set(pmap, "max_stamina", ds_map_find_value(pmap, "max_stamina") + 1);
								break;
							case 1:
								ds_map_set(pmap, "max_speed", ds_map_find_value(pmap, "max_speed") + 1);
								break;
							case 2:
								ds_map_set(pmap, "max_strength", ds_map_find_value(pmap, "max_strength") + 1);
								break;
							case 3:
								ds_map_set(pmap, "max_skill", ds_map_find_value(pmap, "max_skill") + 1);
								break;
						}
						if (ds_map_find_value(pmap, "max_stamina") > 10) {
							ds_map_set(pmap, "max_stamina", 10);
						}
						if (ds_map_find_value(pmap, "max_speed") > 10) {
							ds_map_set(pmap, "max_speed", 10);
						}
						if (ds_map_find_value(pmap, "max_strength") > 10) {
							ds_map_set(pmap, "max_strength", 10);
						}
						if (ds_map_find_value(pmap, "max_skill") > 10) {
							ds_map_set(pmap, "max_skill", 10);
						}
					}
				}
				slog("now s_get_player_potential = " + string(s_get_player_potential(pmap)));
			}
		}
	}
}

