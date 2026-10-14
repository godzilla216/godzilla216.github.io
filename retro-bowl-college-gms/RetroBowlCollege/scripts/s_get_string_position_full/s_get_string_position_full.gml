function s_get_string_position_full(_arg0) {
	switch (_arg0) {
		case 1:
			return s_str("position_QB");
			break;
		case 5:
			return s_str("position_OL");
			break;
		case 3:
			return s_str("position_TE");
			break;
		case 2:
			return s_str("position_RB");
			break;
		case 4:
			return s_str("position_WR");
			break;
		case 6:
			return s_str("position_DL");
			break;
		case 7:
			return s_str("position_LB");
			break;
		case 9:
		case 8:
			return s_str("position_DB");
			break;
		case 11:
			return s_str("position_KP");
			break;
		case 10:
			return s_str("position_KK");
			break;
		case 100:
			return s_str("position_STAFF_HC");
			break;
		case 101:
			return s_str("position_STAFF_DF");
			break;
		case 102:
			return s_str("position_STAFF_OF");
			break;
	}
}

