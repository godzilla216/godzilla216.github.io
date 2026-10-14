function s_get_max_age_normal(_arg0) {
	var pmap = _arg0;
	var max_age = s_max_age_player_internal();
	switch (ds_map_find_value(pmap, "position")) {
		case 1:
		case 10:
			max_age = s_max_age_qb_internal();
			break;
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
			break;
		case 100:
		case 101:
		case 102:
			max_age = 65;
			break;
	}
	return max_age;
}

