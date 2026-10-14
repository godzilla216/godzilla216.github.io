function s_get_division_winner(_arg0, _arg1) {
	var conf = _arg0;
	var division = _arg1;
	var teams_div = ds_list_create();
	for (var i = 0; i < ds_list_size(obj_master.teamlist); i++) {
		var team = ds_list_find_value(obj_master.teamlist, i);
		if (real(ds_map_find_value(team, "conference")) == conf && real(ds_map_find_value(team, "division")) == division) {
			ds_list_add(teams_div, team);
		}
	}
	teams_div = s_sort_teams(teams_div, 0, false);
	var team = ds_list_find_value(teams_div, 0);
	ds_list_destroy(teams_div);
	teams_div = -1;
	return team;
}

