function s_rookie_age_internal() {
	if (s_is_co_mode()) {
		return 18;
	}
	return 21;
}

function s_max_age_player_internal() {
	if (s_is_co_mode()) {
		return 21;
	}
	return 35;
}

function s_max_age_qb_internal() {
	if (s_is_co_mode()) {
		return 21;
	}
	return 40;
}

function s_get_max_age(_arg0) {
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
	if (ds_map_exists(pmap, "delay_retirement")) {
		max_age += ds_map_find_value(pmap, "delay_retirement");
	}
	return max_age;
}

