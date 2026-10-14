function s_create_freeagent() {
	switch (irandom(2)) {
		case 0:
			var pmap = s_create_player(s_get_required_position(false), s_rookie_age_internal(), 1, 2);
			ds_map_set(pmap, "attitude", irandom_range(15, 90));
			ds_map_set(pmap, "walk_on", 1);
			return pmap;
			break;
		case 1:
			var pmap = s_create_player(s_get_required_position(false), irandom_range(33, 40), 1, 3);
			ds_map_set(pmap, "stamina", 1);
			ds_map_set(pmap, "max_stamina", 1);
			ds_map_set(pmap, "walk_on", 1);
			return pmap;
			break;
		case 2:
			var pmap = s_create_player(s_get_required_position(false), 0, 1, 4);
			ds_map_set(pmap, "attitude", irandom_range(5, 15));
			ds_map_set(pmap, "walk_on", 1);
			return pmap;
			break;
	}
}

