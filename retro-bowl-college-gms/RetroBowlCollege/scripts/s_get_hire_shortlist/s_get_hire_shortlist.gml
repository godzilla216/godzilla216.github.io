function s_get_hire_shortlist(_arg0) {
	with (obj_master) {
		var shortlist = ds_list_create();
		var staffpos = _arg0;
		for (var i = 0; i < ds_list_size(hirelist); i++) {
			var pmap = ds_list_find_value(hirelist, i);
			if (ds_map_find_value(pmap, "position") == staffpos) {
				ds_list_add(shortlist, pmap);
			}
		}
		return shortlist;
	}
}

