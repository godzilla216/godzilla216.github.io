function s_create_new_stafflist() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(stafflist); i++) {
			ds_map_destroy(ds_list_find_value(stafflist, i));
			ds_list_set(stafflist, i, -1);
		}
		ds_list_clear(stafflist);
		ds_list_add(stafflist, s_create_staff(101, 1));
		ds_list_add(stafflist, s_create_staff(102, 1));
	}
}

