function s_get_team_tla_by_id(_arg0) {
	var tmap = ds_list_find_value(obj_master.teamlist, _arg0);
	return ds_map_find_value(tmap, "tla");
}

