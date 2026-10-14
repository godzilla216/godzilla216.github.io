function s_is_in_the_clear() {
	if (global.master_ball.holder != other.id) {
		return false;
	}
	switch (facing) {
		case -1:
			with (obj_player) {
				if (offense != other.offense && x < other.x) {
					return false;
				}
			}
			break;
		case 1:
			with (obj_player) {
				if (offense != other.offense && x > other.x) {
					return false;
				}
			}
			break;
	}
	return true;
}

