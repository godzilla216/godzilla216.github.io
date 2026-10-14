switch (bound_type) {
	case 0:
		with (obj_player) {
			if (x < other.x) {
				x = other.x;
				hspeed = 0;
			}
		}
		break;
	case 1:
		with (obj_player) {
			if (x > other.x) {
				x = other.x;
				hspeed = 0;
			}
		}
		break;
	case 2:
		with (obj_player) {
			if (y < other.y) {
				y = other.y;
				vspeed = 0;
			}
		}
		break;
	case 3:
		with (obj_player) {
			if (y > other.y) {
				y = other.y;
				vspeed = 0;
			}
		}
		break;
}
