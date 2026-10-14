function s_get_store_player_by_position(_arg0, _arg1) {
	var pos = _arg0;
	var page = _arg1;
	with (obj_master) {
		var count = 0;
		for (var i = 0; i < ds_list_size(storelist); i++) {
			var pmap = ds_list_find_value(storelist, i);
			if (ds_map_find_value(pmap, "position") == pos) {
				count++;
				if (count == page) {
					return pmap;
				}
			}
		}
	}
	return -4;
}

