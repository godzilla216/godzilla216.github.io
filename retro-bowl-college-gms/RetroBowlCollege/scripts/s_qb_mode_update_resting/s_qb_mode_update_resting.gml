function s_qb_mode_update_resting() {
	if (obj_master.qb_mode) {
		var pmap = s_get_qb_pmap();
		ds_map_set(pmap, "resting", 0);
		if (s_qb_mode_benched_status() != 0) {
			ds_map_set(pmap, "resting", 1);
		}
	}
}

