function s_get_random_coach() {
	with (obj_master) {
		return ds_list_find_value(stafflist, irandom(ds_list_size(stafflist) - 1));
	}
}

