function s_get_defense_attribute(_arg0, _arg1) {
	if (_arg1 == -4) {
		slog2("s_get_defense_attribute. no cur_roster");
		return 0;
	}
	with (obj_master) {
		var rating = 0;
		for (var i = 0; i < ds_list_size(_arg1); i++) {
			var pmap = ds_list_find_value(_arg1, i);
			if (!ds_map_exists(pmap, _arg0)) {
				continue;
			}
			if (!s_is_defensive_player(pmap)) {
				continue;
			}
			if (ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup") == true) {
				continue;
			}
			if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
				rating += s_get_attribute(pmap, _arg0);
			}
		}
		return rating;
	}
}

function s_get_attribute(_arg0, _arg1) {
	if (!_arg0) {
		return 0;
	}
	if (!ds_map_exists(_arg0, _arg1)) {
		return 0;
	}
	switch (_arg1) {
		case "skill":
		case "speed":
		case "strength":
		case "stamina":
			return min(ds_map_find_value(_arg0, _arg1) + s_attribute_buff(_arg0, _arg1), 10);
			break;
		default:
			return ds_map_find_value(_arg0, _arg1);
			break;
	}
	return 0;
}

function s_attribute_buff(_arg0, _arg1) {
	if (!ds_map_exists(_arg0, _arg1)) {
		return 0;
	}
	if (ds_map_find_value(_arg0, "condition") < 0) {
		return 0;
	}
	if (s_is_co_mode()) {
		return 0;
	}
	switch (_arg1) {
		case "skill":
			if (ds_map_find_value(_arg0, "attitude") > 90) {
				return 1;
			}
			break;
		case "speed":
			if (ds_map_find_value(_arg0, "condition") > 99) {
				return 1;
			}
			break;
		case "strength":
			if (ds_map_find_value(_arg0, "attitude") <= 30) {
				return 1;
			}
			break;
		case "stamina":
			if (ds_map_find_value(_arg0, "attitude") <= 15) {
				return 1;
			}
			break;
	}
	return 0;
}

