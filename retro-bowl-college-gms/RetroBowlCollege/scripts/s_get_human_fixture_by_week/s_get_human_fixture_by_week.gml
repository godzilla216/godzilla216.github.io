function s_get_human_fixture_by_week(_arg0) {
	with (obj_master) {
		for (var f = 0; f < ds_list_size(fixturelist); f++) {
			var fix = ds_list_find_value(fixturelist, f);
			if (fix && !is_undefined(ds_map_find_value(fix, "week")) && real(ds_map_find_value(fix, "week")) == _arg0) {
				return fix;
			}
		}
	}
	return -4;
}

