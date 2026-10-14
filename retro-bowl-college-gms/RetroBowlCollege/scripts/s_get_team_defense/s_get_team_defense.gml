function s_get_team_defense(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = true;
	}
	with (obj_master) {
		if (ds_map_find_value(_arg0, "uid") == myteam_id && !global.exhibition) {
			var rating = s_get_team_defense_from_roster(roster);
			var coordinator = s_get_staff(101);
			if (coordinator) {
				rating += ds_map_find_value(coordinator, "rating");
			}
			rating = round(rating * 0.25);
			rating = clamp(rating, 1, 10);
			ds_map_set(_arg0, "defense", rating);
			return rating;
		} else if (obj_master.op_difficulty == 4) {
			return 10;
		} else if (_arg1) {
			return s_get_team_defense_with_reputation_boost(_arg0);
		} else {
			return real(ds_map_find_value(_arg0, "defense"));
		}
	}
}

function s_get_team_defense_exh(_arg0, _arg1) {
	with (obj_master) {
		if (_arg1 == -4) {
			slog("s_get_team_defense_exh. no cur_roster");
		}
		if (_arg1 != -4 && ds_list_size(_arg1 > 0)) {
			var rating = s_get_team_defense_from_roster(_arg1);
			rating = round(rating * 0.25);
			rating = clamp(rating, 1, 10);
			ds_map_set(_arg0, "defense", rating);
			return rating;
		} else if (obj_master.op_difficulty == 4) {
			return 10;
		} else {
			return real(ds_map_find_value(_arg0, "defense"));
		}
	}
}

function s_get_team_defense_from_roster(_arg0) {
	var rating = 0;
	var pcount = 1;
	for (var i = 0; i < ds_list_size(_arg0); i++) {
		var pmap = ds_list_find_value(_arg0, i);
		if (ds_map_find_value(pmap, "condition") > 0 && !s_player_benched(pmap)) {
			switch (ds_map_find_value(pmap, "position")) {
				case 6:
				case 7:
				case 8:
				case 9:
					pcount++;
					rating += s_get_player_rating(pmap);
					break;
				default:
					break;
			}
		}
	}
	return rating;
}

