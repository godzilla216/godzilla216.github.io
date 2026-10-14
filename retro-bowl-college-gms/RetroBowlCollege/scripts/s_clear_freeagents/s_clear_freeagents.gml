function s_clear_freeagents() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(tradelist); i++) {
			ds_map_destroy(ds_list_find_value(tradelist, i));
			ds_list_set(tradelist, i, -1);
		}
		for (var i = 0; i < ds_list_size(freeagentlist); i++) {
			var pmap = ds_list_find_value(freeagentlist, i);
			if (ds_exists(pmap, 1) && ds_map_exists(pmap, "hof") && ds_map_find_value(pmap, "hof") == true) {
				ds_map_set(pmap, "team_leave_reason", "cut");
				ds_list_add(hoflist, pmap);
			} else {
				ds_map_destroy(ds_list_find_value(freeagentlist, i));
				ds_list_set(freeagentlist, i, -1);
			}
		}
		ds_list_clear(tradelist);
		ds_list_clear(freeagentlist);
	}
	s_savegame();
}

