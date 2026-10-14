function s_qb_mode_benched_status() {
	with (obj_master) {
		if (relationship_boss < 15) {
			return 1;
		} else if (s_get_qb_energy() < 40) {
			return 2;
		}
	}
	return 0;
}

