function s_get_team_winpct(_arg0) {
	var tmap = _arg0;
	var wins = real(ds_map_find_value(tmap, "wins"));
	var losses = real(ds_map_find_value(tmap, "losses"));
	var ties = real(ds_map_find_value(tmap, "ties"));
	var games = real(wins + losses + ties);
	if (games > 0) {
		return (wins + ties * 0.5) / games;
	}
	return 0;
}

