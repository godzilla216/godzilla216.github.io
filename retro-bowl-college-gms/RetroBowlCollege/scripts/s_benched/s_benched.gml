function s_player_benched(_arg0) {
	if (ds_map_find_value(_arg0, "resting")) {
		return true;
	}
	if (s_is_co_mode()) {
		if (ds_map_find_value(_arg0, "suspended")) {
			return true;
		}
	}
	return false;
}

