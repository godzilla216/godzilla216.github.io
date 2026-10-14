function s_get_required_position(_arg0) {
	var absolute = _arg0;
	if (absolute) {
		for (var i = 1; i < 11; i++) {
			if (!s_position_already_on_roster(i)) {
				return;
			}
		}
	}
	var pos = 0;
	repeat (9) {
		pos = irandom_range(1, 10);
		if (!s_position_already_on_roster(pos)) {
			return pos;
		}
	}
	return pos;
}

function s_get_required_position_no_QB_RB(_arg0) {
	var absolute = _arg0;
	if (absolute) {
		for (var i = 1; i < 11; i++) {
			if (i == 1) {
				continue;
			}
			if (i == 2) {
				continue;
			}
			if (!s_position_already_on_roster(i)) {
				return;
			}
		}
	}
	var pos = 0;
	repeat (9) {
		pos = irandom_range(1, 10);
		if (pos == 1) {
			continue;
		}
		if (pos == 2) {
			continue;
		}
		if (!s_position_already_on_roster(pos)) {
			return pos;
		}
	}
	return pos;
}

