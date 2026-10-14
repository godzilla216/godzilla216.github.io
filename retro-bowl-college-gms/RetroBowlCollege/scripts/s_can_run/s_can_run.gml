function s_can_run() {
	if (dead) {
		return false;
	}
	if (position == 1) {
		return false;
	}
	switch (anim) {
		case 0:
			return true;
			break;
		case 1:
			return true;
			break;
		case 2:
			return true;
			break;
		case 3:
			return false;
			break;
		case 4:
			return false;
			break;
		case 5:
			return false;
			break;
		case 6:
			return false;
			break;
		case 7:
			return true;
			break;
		case 8:
			return false;
			break;
		case 9:
			return true;
			break;
		case 10:
		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
		case 16:
		case 17:
		case 18:
		case 19:
			return false;
			break;
	}
	return false;
}

