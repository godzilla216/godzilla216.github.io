function s_player_at_max_potential(_arg0) {
	s_round_player_attributes(_arg0);
	if (ds_map_find_value(_arg0, "skill") < ds_map_find_value(_arg0, "max_skill")) {
		return false;
	}
	if (ds_map_find_value(_arg0, "speed") < ds_map_find_value(_arg0, "max_speed")) {
		return false;
	}
	if (ds_map_find_value(_arg0, "strength") < ds_map_find_value(_arg0, "max_strength")) {
		return false;
	}
	if (ds_map_find_value(_arg0, "stamina") < ds_map_find_value(_arg0, "max_stamina")) {
		return false;
	}
	return true;
}

