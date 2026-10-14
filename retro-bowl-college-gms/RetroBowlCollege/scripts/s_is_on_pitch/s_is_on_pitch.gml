function s_is_on_pitch(_arg0) {
	var include_endzone = _arg0;
	if (y < 132) {
		return false;
	}
	if (y > 468) {
		return false;
	}
	if (x > 300 && x < 2300) {
		return true;
	}
	if (include_endzone) {
		if (x > 90 && x < 2510) {
			return true;
		}
	}
	return false;
}

