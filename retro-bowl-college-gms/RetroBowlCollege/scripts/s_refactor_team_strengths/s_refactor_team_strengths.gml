function s_refactor_team_strengths() {
	slog("s_refactor_team_strengths");
	with (obj_master) {
		var sdrop = 0.875;
		if (op_difficulty >= 3 || suppress_difficulty < 0) {
			sdrop = 0.8;
		}
		var sort_teams = ds_list_create();
		ds_list_copy(sort_teams, teamlist);
		sort_teams = s_sort_teams(sort_teams, 2, false);
		for (var conf = 0; conf < 2; conf++) {
			var top_rating = 20;
			if (irandom(2)) {
				top_rating = 19;
			}
			for (var i = 0; i < ds_list_size(sort_teams); i++) {
				var team = ds_list_find_value(sort_teams, i);
				if (ds_map_find_value(team, "conference") != conf) {
					continue;
				}
				if (s_has_reputation_point(team)) {
					continue;
				}
				var rating = ds_map_find_value(team, "offense") + ds_map_find_value(team, "defense");
				repeat (10) {
					if (rating > round(top_rating)) {
						switch (irandom(1)) {
							case 0:
								ds_map_set_post(team, "offense", ds_map_find_value(team, "offense") - 1);
								break;
							case 1:
								ds_map_set_post(team, "defense", ds_map_find_value(team, "defense") - 1);
								break;
						}
					} else if (rating < round(top_rating)) {
						switch (irandom(1)) {
							case 0:
								ds_map_set_post(team, "offense", ds_map_find_value(team, "offense") + 1);
								break;
							case 1:
								ds_map_set_post(team, "defense", ds_map_find_value(team, "defense") + 1);
								break;
						}
					}
					ds_map_set(team, "offense", clamp(ds_map_find_value(team, "offense"), 2, 10));
					ds_map_set(team, "defense", clamp(ds_map_find_value(team, "defense"), 2, 10));
					rating = ds_map_find_value(team, "offense") + ds_map_find_value(team, "defense");
				}
				if (top_rating == 20) {
					top_rating = 19;
				} else {
					top_rating -= sdrop;
				}
			}
		}
		ds_list_destroy(sort_teams);
		sort_teams = -1;
	}
}

