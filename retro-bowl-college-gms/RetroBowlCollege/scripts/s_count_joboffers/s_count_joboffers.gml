function s_count_joboffers() {
	slog("Count job offers");
	with (obj_master) {
		if (year == 1) {
			return 0;
		}
		var count = 0;
		for (var t = 0; t < ds_list_size(teamlist); t++) {
			if (s_team_interested(ds_list_find_value(teamlist, t))) {
				count++;
			}
		}
		random_set_seed(current_time);
		return count;
	}
}

