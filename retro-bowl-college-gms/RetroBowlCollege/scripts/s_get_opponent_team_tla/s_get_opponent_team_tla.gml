function s_get_opponent_team_tla() {
	with (obj_controller) {
		var map = team[!human_team ? 1 : 0];
		if (ds_exists(map, 1) && ds_map_exists(map, "tla")) {
			return ds_map_find_value(map, "tla");
		}
	}
	return "0";
}

