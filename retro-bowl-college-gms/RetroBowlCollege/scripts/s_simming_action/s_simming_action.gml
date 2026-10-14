function s_simming_action() {
	if (obj_master.qb_mode && s_qb_mode_benched_status() > 0) {
		return true;
	} else {
		return obj_master.sim_action;
	}
}

