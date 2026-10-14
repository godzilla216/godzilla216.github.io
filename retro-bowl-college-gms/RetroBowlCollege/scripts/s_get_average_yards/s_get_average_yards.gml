function s_get_average_yards(_arg0, _arg1, _arg2) {
	var pmap = _arg0;
	var typ = "stat_";
	switch (_arg1) {
		case 0:
			typ = "stat_";
			break;
		case 1:
			typ = "season_";
			break;
		case 2:
			typ = "career_";
			break;
	}
	if (_arg2) {
		typ += "rush_";
	}
	switch (ds_map_find_value(pmap, "position")) {
		case 2:
		case 3:
		case 4:
			if (ds_map_find_value(pmap, typ + "attempts")) {
				return round(ds_map_find_value(pmap, typ + "yards")) / ds_map_find_value(pmap, typ + "attempts");
			}
			break;
		default:
			if (_arg2) {
				if (ds_map_find_value(pmap, typ + "attempts")) {
					return round(ds_map_find_value(pmap, typ + "yards")) / ds_map_find_value(pmap, typ + "attempts");
				}
			} else if (ds_map_find_value(pmap, typ + "complete")) {
				return round(ds_map_find_value(pmap, typ + "yards")) / ds_map_find_value(pmap, typ + "complete");
			}
			break;
	}
	return 0;
}

