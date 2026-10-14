function s_is_defensive_player(_arg0) {
	var pmap = _arg0;
	switch (ds_map_find_value(pmap, "position")) {
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 10:
			return false;
		case 6:
		case 7:
		case 8:
		case 9:
			return true;
	}
	return false;
}

