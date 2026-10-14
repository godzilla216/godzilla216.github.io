function s_award_sb_rings() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_exists(pmap, "rings")) {
				ds_map_set(pmap, "rings", ds_map_find_value(pmap, "rings") + 1);
			} else {
				ds_map_set(pmap, "rings", 1);
			}
		}
		var oc = s_get_staff(102);
		var dc = s_get_staff(101);
		if (oc) {
			if (ds_map_exists(oc, "rings")) {
				ds_map_set(oc, "rings", ds_map_find_value(oc, "rings") + 1);
			} else {
				ds_map_set(oc, "rings", 1);
			}
		}
		if (dc) {
			if (ds_map_exists(dc, "rings")) {
				ds_map_set(dc, "rings", ds_map_find_value(dc, "rings") + 1);
			} else {
				ds_map_set(dc, "rings", 1);
			}
		}
	}
}

