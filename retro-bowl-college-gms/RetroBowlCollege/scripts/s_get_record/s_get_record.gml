function s_get_record(_arg0) {
	var map_id = _arg0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(records); i++) {
			var map = ds_list_find_value(records, i);
			if (ds_exists(map, 1)) {
				if (ds_map_exists(map, "tag") && ds_map_find_value(map, "tag") == map_id) {
					return map;
				}
			}
		}
		return -4;
	}
}

