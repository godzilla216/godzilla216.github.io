function s_get_playoff_fixture_by_week(_arg0) {
	for (var f = 0; f < ds_list_size(obj_master.playoffs); f++) {
		var fix = ds_list_find_value(obj_master.playoffs, f);
		if (ds_exists(fix, 1) && ds_map_exists(fix, "week")) {
			if (real(ds_map_find_value(fix, "week")) == _arg0) {
				return fix;
			}
		}
	}
	return -4;
}

