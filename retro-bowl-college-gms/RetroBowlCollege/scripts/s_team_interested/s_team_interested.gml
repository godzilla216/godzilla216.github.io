function s_team_interested(_arg0) {
	if (global.debug || global.jefebuild) {
		return true;
	}
	with (obj_master) {
		if (qb_mode) {
			return s_qb_mode_team_interested(_arg0);
		}
		var teamrating = s_get_team_offense_with_reputation_boost(_arg0) + s_get_team_defense_with_reputation_boost(_arg0);
		slog("s_team_interested: " + ds_map_find_value(_arg0, "name"));
		slog("coach_rating: " + string(coach_rating));
		slog("team_rating: " + string(teamrating));
		if (real(ds_map_find_value(_arg0, "uid")) == myteam_id) {
			return false;
		}
		if (coach_rating < teamrating) {
			return false;
		}
		if (year < 3 && real(ds_map_find_value(_arg0, "uid")) == favourite_team_id) {
			return false;
		}
		random_set_seed(year + coach_rating + real(ds_map_find_value(_arg0, "uid")));
		if (!irandom(3)) {
			return false;
		}
	}
	return true;
}

function s_qb_mode_team_interested(_arg0) {
	var teamrating = (s_get_team_offense_with_reputation_boost(_arg0) + s_get_team_defense_with_reputation_boost(_arg0)) / 2;
	var myrating = 10;
	with (obj_master) {
		if (real(ds_map_find_value(_arg0, "uid")) == myteam_id) {
			return false;
		}
		if (myrating < teamrating) {
			return false;
		}
		if (year < 3 && real(ds_map_find_value(_arg0, "uid")) == favourite_team_id) {
			return false;
		}
		if (ds_list_find_index(list_teams_rejected, real(ds_map_find_value(_arg0, "uid"))) > -1) {
			return false;
		}
		random_set_seed(year + myrating + real(ds_map_find_value(_arg0, "uid")));
		if (!irandom(3)) {
			return false;
		}
	}
	return true;
}

