function s_get_qb_energy() {
	if (obj_master.qb_mode == 0) {
		return 0;
	}
	var pmap = s_get_qb_pmap();
	if (pmap) {
		return real(ds_map_find_value(pmap, "condition"));
	} else {
		return 0;
	}
}

