function s_opposite_aim(_arg0) {
	slog("Direc = " + string(direc));
	var dir = _arg0;
	while (dir < 0) {
		dir += 360;
	}
	while (dir > 359) {
		dir -= 360;
	}
	switch (obj_controller.drivedir) {
		case -1:
			if (dir > 280 || dir < 80) {
				return true;
			}
			break;
		case 1:
			if (dir > 100 && dir < 260) {
				return true;
			}
			break;
	}
}

