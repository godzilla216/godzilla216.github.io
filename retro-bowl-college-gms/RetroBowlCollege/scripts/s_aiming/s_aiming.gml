function s_aiming() {
	with (global.master_ball) {
		switch (state) {
			case 0:
			case 2:
			case 1:
			case 18:
			case 19:
				return true;
			default:
				return false;
		}
	}
	return false;
}

