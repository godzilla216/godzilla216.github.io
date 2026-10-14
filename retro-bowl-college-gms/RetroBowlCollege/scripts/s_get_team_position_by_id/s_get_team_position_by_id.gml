function s_get_team_position_by_id(_arg0) {
	var tmap = s_get_team_by_id(_arg0);
	var conf = ds_map_find_value(tmap, "conference");
	var division = ds_map_find_value(tmap, "division");
	var teams_div = ds_list_create();
	for (var i = 0; i < ds_list_size(obj_master.teamlist); i++) {
		var team = ds_list_find_value(obj_master.teamlist, i);
		if (real(ds_map_find_value(team, "conference")) == conf && real(ds_map_find_value(team, "division")) == division) {
			ds_list_add(teams_div, team);
		}
	}
	teams_div = s_sort_teams(teams_div, 0, false);
	var retval = 1;
	if (ds_list_find_value(teams_div, 0) == tmap) {
		retval = 1;
	}
	if (ds_list_find_value(teams_div, 1) == tmap) {
		retval = 2;
	}
	if (ds_list_find_value(teams_div, 2) == tmap) {
		retval = 3;
	}
	if (ds_list_find_value(teams_div, 3) == tmap) {
		retval = 4;
	}
	ds_list_destroy(teams_div);
	teams_div = -1;
	return retval;
}

