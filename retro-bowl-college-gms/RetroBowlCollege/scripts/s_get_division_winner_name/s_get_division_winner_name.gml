function s_get_division_winner_name(_arg0, _arg1, _arg2) {
	var conf = _arg0;
	var division = _arg1;
	var tla = _arg2;
	var team = s_get_division_winner(conf, division);
	switch (tla) {
		case false:
			return ds_map_find_value(team, "name");
			break;
		case true:
			return ds_map_find_value(team, "tla");
			break;
	}
}

