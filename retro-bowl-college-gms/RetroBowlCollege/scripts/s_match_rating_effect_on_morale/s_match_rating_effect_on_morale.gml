function s_match_rating_effect_on_morale() {
	with (obj_master) {
		slog("s_match_rating_effect_on_morale");
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			var rat = s_get_match_rating(pmap);
			if (ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup") == true) {
				ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") - 5, 1, 100));
			} else if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
				slog(ds_map_find_value(pmap, "lname") + " Rating = " + string(rat));
				slog("Attitude was = " + string(ds_map_find_value(pmap, "attitude")));
				var amt = lerp(-5, 2, rat * 0.1);
				slog("Amt = " + string(amt));
				ds_map_set(pmap, "attitude", clamp(ds_map_find_value(pmap, "attitude") + amt, 1, 100));
				slog("Attitude now = " + string(ds_map_find_value(pmap, "attitude")));
			}
		}
	}
}

