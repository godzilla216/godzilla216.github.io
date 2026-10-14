function s_clear_playoff_fixtures() {
	if (ds_exists(obj_master.playoffs, 2)) {
		for (var i = 0; i < ds_list_size(obj_master.playoffs); i++) {
			ds_map_destroy(ds_list_find_value(obj_master.playoffs, i));
			ds_list_set(obj_master.playoffs, i, -1);
		}
		ds_list_clear(obj_master.playoffs);
	}
}

