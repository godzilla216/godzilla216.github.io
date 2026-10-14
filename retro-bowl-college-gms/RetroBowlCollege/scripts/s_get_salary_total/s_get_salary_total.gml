function s_get_salary_total() {
	var total = 0;
	for (var r = 0; r < ds_list_size(obj_master.roster); r++) {
		var pmap = ds_list_find_value(obj_master.roster, r);
		if (pmap) {
			if (!ds_map_exists(pmap, "salary")) {
				ds_map_set(pmap, "salary", 0);
			}
			total += real(ds_map_find_value(pmap, "salary"));
		}
	}
	return total;
}

