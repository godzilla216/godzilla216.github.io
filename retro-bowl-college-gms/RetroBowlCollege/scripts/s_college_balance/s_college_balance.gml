function s_college_balance_create_new_roster() {
	for (var i = 0; i < ds_list_size(roster); i++) {
		var pmap = ds_list_find_value(roster, i);
		if (i == 0) {
			ds_map_set(pmap, "age", s_rookie_age_internal() + 2);
		} else if (i == 1) {
			ds_map_set(pmap, "age", s_rookie_age_internal() + 3);
		} else if (i == 2) {
			ds_map_set(pmap, "age", s_rookie_age_internal() + 3);
		} else {
			ds_map_set(pmap, "age", random(1) < 0.5 ? s_rookie_age_internal() : s_rookie_age_internal() + 1);
		}
		slog("Player Age force [" + ds_map_find_value(pmap, "lname") + "] -> [" + string(ds_map_find_value(pmap, "age")) + "]");
		s_refresh_suspended(pmap, false);
	}
}

