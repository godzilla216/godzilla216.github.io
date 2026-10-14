function s_get_string_state() {
	with (obj_controller) {
		switch (state) {
			case 2:
				return "ACTION";
				break;
			case 1:
				return "COMMENTARY";
				break;
		}
	}
	return "state == OTHER";
}

