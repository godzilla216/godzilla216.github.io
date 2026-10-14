function s_is_on_pitch_xy(_arg0, _arg1, _arg2) {
	var cx = _arg0;
	var cy = _arg1;
	var include_endzone = _arg2;
	if (cy < 132) {
		return false;
	}
	if (cy > 468) {
		return false;
	}
	if (cx > 300 && cx < 2300) {
		return true;
	}
	if (include_endzone) {
		if (cx > 90 && cx < 2510) {
			return true;
		}
	}
	return false;
}

