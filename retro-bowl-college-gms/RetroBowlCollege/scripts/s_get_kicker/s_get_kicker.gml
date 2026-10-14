function s_get_kicker() {
	with (obj_playerOF) {
		if (position == 1) {
			return id;
		}
	}
	return -4;
}

