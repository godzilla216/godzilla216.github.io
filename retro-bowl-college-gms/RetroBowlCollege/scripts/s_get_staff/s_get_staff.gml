function s_get_staff(_arg0) {
	with (obj_master) {
		if (_arg0 == 100) {
			if (boss_profile != -4) {
				ds_map_destroy(boss_profile);
				boss_profile = -4;
			}
			boss_profile = s_create_headcoach_pmap();
			return boss_profile;
		} else {
			for (var i = 0; i < ds_list_size(stafflist); i++) {
				var pmap = ds_list_find_value(stafflist, i);
				if (ds_map_find_value(pmap, "position") == _arg0) {
					return pmap;
				}
			}
		}
	}
	return -4;
}

