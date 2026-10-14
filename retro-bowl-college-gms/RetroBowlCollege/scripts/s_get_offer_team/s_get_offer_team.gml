function s_get_offer_team(_arg0) {
	var pmap = _arg0;
	var team_id = round(obj_master.week + ds_map_find_value(pmap, "skill") + ds_map_find_value(pmap, "strength") + ds_map_find_value(pmap, "stamina") + ds_map_find_value(pmap, "speed") + ds_map_find_value(pmap, "age") + ds_map_find_value(pmap, "attitude")) mod 32;
	if (team_id == obj_master.myteam_id) {
		team_id++;
	}
	if (team_id < obj_master.min_team_id) {
		team_id = obj_master.max_team_id;
	}
	if (team_id > obj_master.max_team_id) {
		team_id = obj_master.min_team_id;
	}
	return s_get_team_by_id(team_id);
}

