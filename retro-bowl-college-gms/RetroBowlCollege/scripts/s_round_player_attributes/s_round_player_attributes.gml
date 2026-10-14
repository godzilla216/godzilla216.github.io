function s_round_player_attributes(_arg0) {
	ds_map_set(_arg0, "skill", round(ds_map_find_value(_arg0, "skill")));
	ds_map_set(_arg0, "speed", round(ds_map_find_value(_arg0, "speed")));
	ds_map_set(_arg0, "strength", round(ds_map_find_value(_arg0, "strength")));
	ds_map_set(_arg0, "stamina", round(ds_map_find_value(_arg0, "stamina")));
	ds_map_set(_arg0, "max_skill", round(ds_map_find_value(_arg0, "max_skill")));
	ds_map_set(_arg0, "max_speed", round(ds_map_find_value(_arg0, "max_speed")));
	ds_map_set(_arg0, "max_strength", round(ds_map_find_value(_arg0, "max_strength")));
	ds_map_set(_arg0, "max_stamina", round(ds_map_find_value(_arg0, "max_stamina")));
}

