function s_add_to_human_fixtures(_arg0, _arg1, _arg2) {
	var map = ds_map_create();
	ds_map_set(map, "week", _arg0);
	ds_map_set(map, "away_team", _arg1);
	ds_map_set(map, "home_team", _arg2);
	ds_map_set(map, "away_score", 0);
	ds_map_set(map, "home_score", 0);
	ds_map_set(map, "human_win", "unplayed");
	ds_list_add(obj_master.fixturelist, map);
}

