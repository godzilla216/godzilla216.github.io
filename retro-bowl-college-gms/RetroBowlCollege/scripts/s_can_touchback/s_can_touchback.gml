function s_can_touchback() {
	with (global.master_ball) {
		if (!holder) {
			return false;
		}
		if (x > 300 && x < 2300) {
			return false;
		}
		if (y < 132 || y > 468) {
			return false;
		}
		if (holder.x > 300 && holder.x < 2300) {
			return false;
		}
		if (holder.y < 132 || holder.y > 468) {
			return false;
		}
		if (holder.goaldist < 1000) {
			return false;
		}
		switch (obj_controller.drivedir) {
			case -1:
				if (holder.min_x != -1 && holder.min_x < 2300) {
					return false;
				}
				break;
			case 1:
				if (holder.max_x != -1 && holder.max_x > 300) {
					return false;
				}
				break;
		}
		return true;
	}
	return false;
}

