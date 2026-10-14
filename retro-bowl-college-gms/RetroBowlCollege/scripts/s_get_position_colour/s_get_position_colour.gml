function s_get_position_colour(_arg0) {
	switch (_arg0) {
		case 1:
		case 5:
		case 3:
		case 2:
		case 4:
			return global.c_offense;
			break;
		case 6:
		case 7:
		case 9:
		case 8:
			return global.c_defense;
			break;
		case 11:
		case 10:
			return global.c_specialteams;
			break;
		case 100:
			return global.c_headcoach;
			break;
		case 101:
			return global.c_defense;
			break;
		case 102:
			return global.c_offense;
			break;
	}
	return global.c_primary;
}

