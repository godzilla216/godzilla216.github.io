function s_get_team_by_id(_arg0) {
	var team;
	for (var i = 0; i < ds_list_size(obj_master.teamlist); i++) {
		team = ds_list_find_value(obj_master.teamlist, i);
		if (ds_map_find_value(team, "uid") == _arg0) {
			return team;
		}
	}
	team = ds_map_create();
	ds_map_set(team, "uid", -1);
	ds_map_set(team, "name", "-");
	ds_map_set(team, "tla", "-");
	return team;
}

function s_get_team_by_id_internal(_arg0, _arg1) {
	for (var i = 0; i < ds_list_size(_arg1); i++) {
		var team = ds_list_find_value(_arg1, i);
		if (ds_map_find_value(team, "uid") == _arg0) {
			return team;
		}
	}
	var team = ds_map_create();
	ds_map_set(team, "uid", -1);
	ds_map_set(team, "name", "Null Team");
	ds_map_set(team, "tla", "-");
	slog("RETURN DUMMY TEAM!");
	return team;
}

