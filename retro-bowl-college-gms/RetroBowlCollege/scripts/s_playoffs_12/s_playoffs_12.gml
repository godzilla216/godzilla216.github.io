function s_playoffs_12() {
	if (ds_exists(obj_master.playoffs, 2)) {
		if (ds_list_size(obj_master.playoffs) == 11) {
			return true;
		}
	}
	return false;
}

