function s_clear_storelist() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(storelist); i++) {
			ds_map_destroy(ds_list_find_value(storelist, i));
			ds_list_set(storelist, i, -1);
		}
		ds_list_clear(storelist);
	}
}

