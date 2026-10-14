function s_lastname_already_on_roster(_arg0) {
	for (var r = 0; r < ds_list_size(obj_master.roster); r++) {
		var pmap = ds_list_find_value(obj_master.roster, r);
		if (ds_map_find_value(pmap, "lname") == _arg0) {
			return true;
		}
	}
	for (var r = 0; r < ds_list_size(obj_master.stafflist); r++) {
		var pmap = ds_list_find_value(obj_master.stafflist, r);
		if (ds_map_find_value(pmap, "lname") == _arg0) {
			return true;
		}
	}
	return false;
}

