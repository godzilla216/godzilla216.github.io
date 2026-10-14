function s_get_attitude_icon(_arg0) {
	if (_arg0 <= 15) {
		return 0;
	}
	if (_arg0 <= 30) {
		return 1;
	}
	if (_arg0 <= 45) {
		return 2;
	}
	if (_arg0 <= 60) {
		return 3;
	}
	if (_arg0 <= 75) {
		return 4;
	}
	if (_arg0 <= 90) {
		return 5;
	}
	return 6;
}

function s_attitude_reduce_step(_arg0) {
	if (_arg0 <= 15) {
		return 15;
	}
	if (_arg0 <= 30) {
		return 15;
	}
	if (_arg0 <= 45) {
		return 30;
	}
	if (_arg0 <= 60) {
		return 45;
	}
	if (_arg0 <= 75) {
		return 60;
	}
	if (_arg0 <= 90) {
		return 75;
	}
	return 90;
}

