function s_create_tradelist(_arg0) {
	with (obj_master) {
		while (ds_list_size(tradelist) < _arg0) {
			var pmap = s_create_player(s_get_required_position(false), irandom_range(s_rookie_age_internal() + 1, 40), 1, 10);
			do {
				ds_map_set(pmap, "teamid", s_get_random_team_id());
			} until (!!(ds_map_find_value(pmap, "teamid") != obj_master.myteam_id));
			ds_list_add(tradelist, pmap);
		}
		tradelist = s_sort_players(tradelist, 2);
	}
}

