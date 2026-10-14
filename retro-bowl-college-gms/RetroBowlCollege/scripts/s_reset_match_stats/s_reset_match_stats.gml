function s_reset_match_stats(_arg0) {
	slog("s_reset_match_stats");
	if (obj_master.roster == -4) {
		return;
	}
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "stat_attempts", 0);
			ds_map_set(pmap, "stat_complete", 0);
			ds_map_set(pmap, "stat_yards", 0);
			ds_map_set(pmap, "stat_longest", 0);
			ds_map_set(pmap, "stat_touchdowns", 0);
			ds_map_set(pmap, "stat_fumbles", 0);
			ds_map_set(pmap, "stat_int", 0);
			ds_map_set(pmap, "stat_sacks", 0);
			ds_map_set(pmap, "stat_tackles", 0);
			ds_map_set(pmap, "stat_rush_attempts", 0);
			ds_map_set(pmap, "stat_rush_yards", 0);
			ds_map_set(pmap, "stat_rush_longest", 0);
			ds_map_set(pmap, "stat_rush_touchdowns", 0);
			ds_map_set(pmap, "stat_return_yards", 0);
			ds_map_set(pmap, "stat_return_tds", 0);
			ds_map_set(pmap, "stat_return_longest", 0);
			ds_map_set(pmap, "stat_return_attempts", 0);
			if (ds_map_find_value(pmap, "position") == 10) {
				ds_map_set(pmap, "stat_attempts_XP", 0);
				ds_map_set(pmap, "stat_complete_XP", 0);
			}
			if (_arg0) {
				ds_map_set(pmap, "season_games", 0);
				ds_map_set(pmap, "season_attempts", 0);
				ds_map_set(pmap, "season_complete", 0);
				ds_map_set(pmap, "season_yards", 0);
				ds_map_set(pmap, "season_longest", 0);
				ds_map_set(pmap, "season_touchdowns", 0);
				ds_map_set(pmap, "season_fumbles", 0);
				ds_map_set(pmap, "season_int", 0);
				ds_map_set(pmap, "season_sacks", 0);
				ds_map_set(pmap, "season_tackles", 0);
				ds_map_set(pmap, "season_rush_attempts", 0);
				ds_map_set(pmap, "season_rush_yards", 0);
				ds_map_set(pmap, "season_rush_longest", 0);
				ds_map_set(pmap, "season_rush_touchdowns", 0);
				ds_map_set(pmap, "season_return_yards", 0);
				ds_map_set(pmap, "season_return_tds", 0);
				ds_map_set(pmap, "season_return_longest", 0);
				ds_map_set(pmap, "season_return_attempts", 0);
				if (ds_map_find_value(pmap, "position") == 10) {
					ds_map_set(pmap, "season_attempts_XP", 0);
					ds_map_set(pmap, "season_complete_XP", 0);
				}
			}
		}
	}
}

