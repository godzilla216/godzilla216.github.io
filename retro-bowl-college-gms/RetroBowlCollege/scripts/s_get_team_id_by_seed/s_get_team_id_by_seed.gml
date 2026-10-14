function s_get_team_id_by_seed(_arg0, _arg1) {
	slog("s_get_team_id_by_seed");
	var team = !s_is_co_mode() ? s_get_team_by_seed(_arg0, _arg1) : s_get_team_by_seed_co(_arg0, _arg1);
	return ds_map_find_value(team, "uid");
}

