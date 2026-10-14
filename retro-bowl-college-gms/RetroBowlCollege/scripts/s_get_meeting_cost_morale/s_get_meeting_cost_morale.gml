function s_get_meeting_cost_morale(_arg0) {
	switch (s_get_attitude_icon(ds_map_find_value(_arg0, "attitude"))) {
		case 0:
			return 4;
			break;
		case 1:
			return 3;
			break;
		case 2:
			return 3;
			break;
		case 3:
			return 2;
			break;
		case 4:
			return 2;
			break;
		case 5:
			return 1;
			break;
		case 6:
			return 1;
			break;
	}
	return 99;
}

