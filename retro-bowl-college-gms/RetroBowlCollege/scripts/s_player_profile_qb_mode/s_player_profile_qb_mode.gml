function s_player_profile_qb_mode() {
	inst_100418.text = string(obj_master.qb_nrg);
	if (s_get_qb_energy() > 99) {
		inst_100421.active = false;
	}
}

