function s_coach_trait_experience(_arg0) {
	var xpmap = -4;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (s_is_offensive_player(_arg0) == s_is_offensive_player(pmap)) {
				if (!xpmap) {
					xpmap = pmap;
				}
				ds_map_set(pmap, "xp", ds_map_find_value(pmap, "xp_level") * 100);
				ds_map_set(pmap, "xp_gain", round(real(ds_map_find_value(pmap, "xp_gain")) + 10));
			}
		}
	}
	if (xpmap) {
		player_profile = xpmap;
		room_goto(rm_profile_player);
	} else {
		room_goto(rm_frontoffice);
	}
}

