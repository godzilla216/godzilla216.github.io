function s_get_team_name_by_seed(_arg0, _arg1, _arg2) {
	slog("s_get_team_name_by_seed");
	var conf = _arg0;
	var seed = _arg1;
	var tla = _arg2;
	var team = s_get_team_by_seed(conf, seed);
	switch (tla) {
		case false:
			return ds_map_find_value(team, "name");
			break;
		case true:
			return ds_map_find_value(team, "tla");
			break;
	}
}

