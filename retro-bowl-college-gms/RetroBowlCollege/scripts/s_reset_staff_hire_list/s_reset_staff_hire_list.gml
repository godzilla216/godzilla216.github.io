function s_reset_staff_hire_list(_arg0) {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(hirelist); i++) {
			ds_map_destroy(ds_list_find_value(hirelist, i));
			ds_list_set(hirelist, i, -1);
		}
		ds_list_clear(hirelist);
		s_create_hirelist(false, _arg0);
		s_savegame();
	}
}

