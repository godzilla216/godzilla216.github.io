function s_get_team_by_seed(_arg0, _arg1) {
	var div_winner;
	div_winner[0] = s_get_division_winner(_arg0, 0);
	div_winner[1] = s_get_division_winner(_arg0, 1);
	div_winner[2] = s_get_division_winner(_arg0, 2);
	div_winner[3] = s_get_division_winner(_arg0, 3);
	with (obj_master) {
		var teams_conf = ds_list_create();
		if (_arg1 <= 4) {
			ds_list_add(teams_conf, div_winner[0]);
			ds_list_add(teams_conf, div_winner[1]);
			ds_list_add(teams_conf, div_winner[2]);
			ds_list_add(teams_conf, div_winner[3]);
		} else {
			for (var i = 0; i < ds_list_size(teamlist); i++) {
				var team = ds_list_find_value(teamlist, i);
				if (real(ds_map_find_value(team, "conference")) == _arg0) {
					var winner = false;
					if (_arg1 > 4) {
						for (var r = 0; r < 4; r++) {
							if (team == div_winner[r]) {
								winner = true;
								break;
							}
						}
					}
					if (!winner) {
						ds_list_add(teams_conf, team);
					}
				}
			}
		}
		teams_conf = s_sort_teams(teams_conf, 0, false);
		if (_arg1 > 4) {
			_arg1 -= 4;
		}
		var team = ds_list_find_value(teams_conf, _arg1 - 1);
		ds_list_destroy(teams_conf);
		teams_conf = -1;
		return team;
	}
}

function s_get_team_by_seed_co(_arg0, _arg1) {
	with (obj_master) {
		var teams_conf = ds_list_create();
		for (var i = 0; i < ds_list_size(teamlist); i++) {
			var team = ds_list_find_value(teamlist, i);
			if (real(ds_map_find_value(team, "conference")) == _arg0) {
				var winner = false;
				if (!winner) {
					ds_list_add(teams_conf, team);
				}
			}
		}
		teams_conf = s_sort_teams(teams_conf, 0, false);
		var team = ds_list_find_value(teams_conf, _arg1 - 1);
		ds_list_destroy(teams_conf);
		teams_conf = -1;
		return team;
	}
}

function s_get_team_seeding(_arg0) {
	var conf = ds_map_find_value(_arg0, "conference");
	for (var s = 1; s < 8; s++) {
		var s_tmap = s_get_team_by_seed(conf, s);
		if (s_tmap && ds_map_find_value(s_tmap, "uid") == ds_map_find_value(_arg0, "uid")) {
			return s;
		}
	}
	return 8;
}

