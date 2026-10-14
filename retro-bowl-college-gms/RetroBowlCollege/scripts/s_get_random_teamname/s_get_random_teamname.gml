function s_get_random_teamname(_arg0) {
	with (obj_master) {
		var tmap = -4;
		if (_arg0) {
			tmap = ds_list_find_value(teamlist, s_get_random_team_id());
		} else {
			do {
				tmap = ds_list_find_value(teamlist, s_get_random_team_id());
			} until (!!(tmap != myteam));
		}
		return ds_map_find_value(tmap, "name");
	}
}

function s_get_random_team_id() {
	if (s_is_co_mode()) {
		return irandom_range(obj_master.min_team_id, obj_master.max_team_id);
	} else {
		return irandom(obj_master.max_team_id);
	}
}

