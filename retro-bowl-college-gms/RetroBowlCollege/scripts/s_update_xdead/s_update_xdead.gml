function s_update_xdead() {
	ydead = round(y);
	xdead = round(x);
	var is_qb = false;
	if (holder && (holder.position == 1 || holder.qb_rushing)) {
		is_qb = true;
	}
	if (holder && !is_qb) {
		if (holder.min_x == -1) {
			holder.min_x = global.master_ball.x;
		}
		if (holder.max_x == -1) {
			holder.max_x = global.master_ball.x;
		}
		switch (obj_controller.drivedir) {
			case -1:
				xdead = holder.min_x;
				if (state == 6) {
					xdead = 300;
				}
				if (!holder.offense) {
					xdead = holder.max_x;
					if (state == 6) {
						xdead = 2300;
					}
				}
				break;
			case 1:
				xdead = holder.max_x;
				if (state == 6) {
					xdead = 2300;
				}
				if (!holder.offense) {
					xdead = holder.min_x;
					if (state == 6) {
						xdead = 300;
					}
				}
				break;
		}
	}
}

