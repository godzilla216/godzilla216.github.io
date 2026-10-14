function s_sort_teams(_arg0, _arg1, _arg2) {
	var sortedlist = ds_list_create();
	while (ds_list_size(_arg0) > 0) {
		var bestteam = -4;
		var bestpct = -1;
		for (var i = 0; i < ds_list_size(_arg0); i++) {
			var tmap = ds_list_find_value(_arg0, i);
			ds_map_set(tmap, "offense", real(ds_map_find_value(tmap, "offense")));
			ds_map_set(tmap, "defense", real(ds_map_find_value(tmap, "defense")));
			switch (_arg1) {
				case 0:
					var wins = real(ds_map_find_value(tmap, "wins"));
					var losses = real(ds_map_find_value(tmap, "losses"));
					var ties = real(ds_map_find_value(tmap, "ties"));
					var games = wins + losses + ties;
					var winpct = (wins + ties * 0.5) / games;
					winpct = s_round_to_decimal(winpct, 3);
					if (!_arg2) {
						if (!bestteam || wins > real(ds_map_find_value(bestteam, "wins")) || winpct > bestpct) {
							bestteam = tmap;
							bestpct = winpct;
						} else if (winpct == bestpct && obj_master.week > 2) {
							var head2head = s_get_head_to_head(ds_map_find_value(tmap, "uid"), ds_map_find_value(bestteam, "uid"));
							if (head2head == -1) {
								bestteam = tmap;
								bestpct = winpct;
							} else if (head2head == 0) {
								var confdiv = "division";
								if (ds_map_find_value(tmap, "division") != ds_map_find_value(bestteam, "division")) {
									confdiv = "conference";
								}
								var divpct1 = s_get_win_pecentage_by_confdiv(ds_map_find_value(tmap, "uid"), confdiv);
								var divpct2 = s_get_win_pecentage_by_confdiv(ds_map_find_value(bestteam, "uid"), confdiv);
								if (divpct1 > divpct2) {
									bestteam = tmap;
									bestpct = winpct;
								} else if (divpct1 == divpct2) {
									var points1 = s_get_points_season(ds_map_find_value(tmap, "uid"));
									var points2 = s_get_points_season(ds_map_find_value(bestteam, "uid"));
									if (points1 > points2) {
										bestteam = tmap;
										bestpct = winpct;
									} else if (points1 == points2) {
										if (ds_map_find_value(tmap, "uid") > ds_map_find_value(bestteam, "uid")) {
											bestteam = tmap;
											bestpct = winpct;
										}
									}
								}
							}
						}
					} else if (!bestteam || winpct < bestpct || winpct == bestpct && wins < ds_map_find_value(bestteam, "wins")) {
						bestteam = tmap;
						bestpct = winpct;
					} else if (winpct == bestpct && obj_master.week > 2) {
						var head2head = s_get_head_to_head(ds_map_find_value(tmap, "uid"), ds_map_find_value(bestteam, "uid"));
						if (head2head == 1) {
							bestteam = tmap;
							bestpct = winpct;
						} else if (head2head == 0) {
							var confdiv = "division";
							if (ds_map_find_value(tmap, "division") != ds_map_find_value(bestteam, "division")) {
								confdiv = "conference";
							}
							var divpct1 = s_get_win_pecentage_by_confdiv(ds_map_find_value(tmap, "uid"), confdiv);
							var divpct2 = s_get_win_pecentage_by_confdiv(ds_map_find_value(bestteam, "uid"), confdiv);
							if (divpct1 < divpct2) {
								bestteam = tmap;
								bestpct = winpct;
							} else if (divpct1 == divpct2) {
								var points1 = s_get_points_season(ds_map_find_value(tmap, "uid"));
								var points2 = s_get_points_season(ds_map_find_value(bestteam, "uid"));
								if (points1 < points2) {
									bestteam = tmap;
									bestpct = winpct;
								} else if (points1 == points2) {
									if (ds_map_find_value(tmap, "uid") < ds_map_find_value(bestteam, "uid")) {
										bestteam = tmap;
										bestpct = winpct;
									}
								}
							}
						}
					}
					break;
				case 1:
					var name = ds_map_find_value(tmap, "name");
					if (_arg2) {
						if (!bestteam || name < ds_map_find_value(bestteam, "name")) {
							bestteam = tmap;
						}
					} else if (!bestteam || name > ds_map_find_value(bestteam, "name")) {
						bestteam = tmap;
					}
					break;
				case 2:
					var rating = ds_map_find_value(tmap, "offense") + ds_map_find_value(tmap, "defense");
					if (_arg2) {
						if (!bestteam || rating < ds_map_find_value(bestteam, "offense") + ds_map_find_value(bestteam, "defense")) {
							bestteam = tmap;
						}
					} else if (!bestteam || rating > ds_map_find_value(bestteam, "offense") + ds_map_find_value(bestteam, "defense")) {
						bestteam = tmap;
					}
					break;
			}
		}
		ds_list_add(sortedlist, bestteam);
		ds_list_delete(_arg0, ds_list_find_index(_arg0, bestteam));
	}
	ds_list_destroy(_arg0);
	_arg0 = -1;
	return sortedlist;
}

