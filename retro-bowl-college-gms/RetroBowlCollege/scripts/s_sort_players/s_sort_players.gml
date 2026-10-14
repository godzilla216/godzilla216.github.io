function s_sort_players(_arg0, _arg1) {
	if (_arg0 == -4) {
		slog("s_sort_players. no cur_roster");
		return -4;
	}
	var plist = _arg0;
	var sortby = _arg1;
	var sortedlist = ds_list_create();
	slog("s_sort_players count[" + string(ds_list_size(plist)) + "]");
	while (ds_list_size(plist) > 0) {
		var bestplayer = -4;
		var bestrating = 0;
		for (var i = 0; i < ds_list_size(plist); i++) {
			var pmap = ds_list_find_value(plist, i);
			switch (sortby) {
				case 2:
					var rating = s_get_player_rating(pmap);
					if (!bestplayer || rating > bestrating) {
						bestplayer = pmap;
						bestrating = rating;
					} else if (rating == bestrating) {
						var position = ds_map_find_value(pmap, "position");
						if (position < ds_map_find_value(bestplayer, "position")) {
							bestplayer = pmap;
						} else if (position == ds_map_find_value(bestplayer, "position")) {
							var pot = s_get_player_potential(pmap);
							var pot_b = s_get_player_potential(pmap);
							if (pot > pot_b) {
								bestplayer = pmap;
							}
						}
					}
					break;
				case 1:
					var name = ds_map_find_value(pmap, "lname");
					if (!bestplayer || name < ds_map_find_value(bestplayer, "lname")) {
						bestplayer = pmap;
					}
					break;
				case 3:
					var position = ds_map_find_value(pmap, "position");
					if (!bestplayer || position < ds_map_find_value(bestplayer, "position")) {
						bestplayer = pmap;
					} else if (position == ds_map_find_value(bestplayer, "position")) {
						var rating = s_get_player_rating(pmap);
						var rating_b = s_get_player_rating(bestplayer);
						if (rating > rating_b) {
							bestplayer = pmap;
						} else if (rating == rating_b) {
							if (ds_map_exists(pmap, "randnum") && ds_map_exists(bestplayer, "randnum")) {
								if (real(ds_map_find_value(pmap, "randnum")) > real(ds_map_find_value(bestplayer, "randnum"))) {
									bestplayer = pmap;
								}
							}
						}
					}
					break;
				case 4:
					var position = ds_map_find_value(pmap, "position");
					if (s_player_benched(pmap)) {
						position += 100;
					} else if (ds_map_find_value(pmap, "condition") < 0) {
						position += 100;
					} else if (ds_map_exists(pmap, "backup") && ds_map_find_value(pmap, "backup")) {
						position += 100;
					}
					var position_b = 0;
					if (bestplayer) {
						position_b = ds_map_find_value(bestplayer, "position");
						if (s_player_benched(bestplayer) || ds_map_find_value(bestplayer, "condition") < 0 || ds_map_exists(bestplayer, "backup") && ds_map_find_value(bestplayer, "backup")) {
							position_b += 100;
						}
					}
					if (!bestplayer || position < position_b) {
						bestplayer = pmap;
					} else if (position == ds_map_find_value(bestplayer, "position")) {
						var rating = s_get_player_rating(pmap);
						var rating_b = s_get_player_rating(bestplayer);
						if (rating > rating_b) {
							bestplayer = pmap;
						} else if (rating == rating_b) {
							if (ds_map_exists(pmap, "randnum") && ds_map_exists(bestplayer, "randnum")) {
								if (real(ds_map_find_value(pmap, "randnum")) > real(ds_map_find_value(bestplayer, "randnum"))) {
									bestplayer = pmap;
								}
							}
						}
					}
					break;
				case 5:
					var salary = ds_map_find_value(pmap, "salary");
					if (!bestplayer || salary > ds_map_find_value(bestplayer, "salary")) {
						bestplayer = pmap;
					}
					break;
				case 6:
					var award_rating = ds_map_find_value(pmap, "award_rating");
					if (!bestplayer || award_rating > ds_map_find_value(bestplayer, "award_rating")) {
						bestplayer = pmap;
					}
					break;
			}
		}
		ds_list_add(sortedlist, bestplayer);
		var i = ds_list_find_index(plist, bestplayer);
		ds_list_delete(plist, i);
	}
	ds_list_destroy(plist);
	plist = -4;
	return sortedlist;
}

