function s_increase_player_attribute(_arg0, _arg1) {
	if (s_player_at_max_potential(_arg0)) {
		return;
	}
	switch (_arg1) {
		case 1:
			if (ds_map_find_value(_arg0, "skill") < ds_map_find_value(_arg0, "max_skill")) {
				ds_map_set(_arg0, "skill", ds_map_find_value(_arg0, "skill") + 1);
				ds_map_set_post(_arg0, "skill_points", ds_map_find_value(_arg0, "skill_points") - 1);
			}
			break;
		case 2:
			if (ds_map_find_value(_arg0, "speed") < ds_map_find_value(_arg0, "max_speed")) {
				ds_map_set(_arg0, "speed", ds_map_find_value(_arg0, "speed") + 1);
				ds_map_set_post(_arg0, "skill_points", ds_map_find_value(_arg0, "skill_points") - 1);
			}
			break;
		case 3:
			if (ds_map_find_value(_arg0, "strength") < ds_map_find_value(_arg0, "max_strength")) {
				ds_map_set(_arg0, "strength", ds_map_find_value(_arg0, "strength") + 1);
				ds_map_set_post(_arg0, "skill_points", ds_map_find_value(_arg0, "skill_points") - 1);
			}
			break;
		case 4:
			if (ds_map_find_value(_arg0, "stamina") < ds_map_find_value(_arg0, "max_stamina")) {
				ds_map_set(_arg0, "stamina", ds_map_find_value(_arg0, "stamina") + 1);
				ds_map_set_post(_arg0, "skill_points", ds_map_find_value(_arg0, "skill_points") - 1);
			}
			break;
	}
}

