function s_is_backup(_arg0) {
	if (ds_map_exists(_arg0, "backup")) {
		if (ds_map_find_value(_arg0, "backup")) {
			return true;
		}
	}
	return false;
}

