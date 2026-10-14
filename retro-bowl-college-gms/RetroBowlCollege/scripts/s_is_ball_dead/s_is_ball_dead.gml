function s_is_ball_dead() {
	with (global.master_ball) {
		is_dead = false;
		switch (state) {
			case 9:
			case 10:
				if (holder) {
					switch (holder.facing) {
						case -1:
							if (x >= 2300) {
								is_dead = true;
							}
							return is_dead;
							break;
						case 1:
							if (x <= 300) {
								is_dead = true;
							}
							return is_dead;
							break;
					}
				}
			case 18:
			case 19:
			case 0:
			case 2:
			case 3:
			case 5:
			case 13:
				is_dead = false;
				break;
			case 4:
			case 6:
			case 7:
			case 8:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 17:
			case 20:
			case 21:
				is_dead = true;
				break;
		}
		return is_dead;
	}
}

