function s_check_record_text(_arg0, _arg1, _arg2) {
	if (global.exhibition) {
		return;
	}
	var map = s_get_record(_arg0);
	if (ds_exists(map, 1) && ds_map_exists(map, "stat") && _arg1 > ds_map_find_value(map, "stat")) {
		ds_map_set(map, "stat", _arg1);
		ds_map_set(map, "stat_text", _arg2);
		ds_map_set(map, "year", obj_master.year);
		ds_map_set(map, "week", obj_master.week);
	}
}

