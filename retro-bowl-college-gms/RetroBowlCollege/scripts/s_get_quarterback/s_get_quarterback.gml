function s_get_quarterback() {
	with (obj_player) {
		if (position == 1) {
			return id;
		}
	}
	return -4;
}

