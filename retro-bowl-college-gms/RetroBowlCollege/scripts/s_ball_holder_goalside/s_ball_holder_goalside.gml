function s_ball_holder_goalside() {
	var my_x = x;
	with (global.master_ball) {
		if (holder == -4) {
			return false;
		}
		switch (holder.facing) {
			case 1:
				if (holder.x > my_x + 5) {
					return true;
				}
				break;
			case -1:
				if (holder.x < my_x - 5) {
					return true;
				}
				break;
		}
	}
	return false;
}

