function s_get_nearest_opponent_by_position(_arg0, _arg1) {
	if (_arg0.tackling) {
		return _arg0.tackling;
	}
	var pos = _arg1;
	var lowest, lowest_val;
	lowest = -4;
	lowest_val = -1;
	with (obj_player) {
		if (offense == _arg0.offense) {
			continue;
		}
		if (pos < 0 && position == abs(pos)) {
			continue;
		}
		if (pos > 0 && position != pos) {
			continue;
		}
		if (!dead && tackling == -4) {
			var val = point_distance(x, y, _arg0.x, _arg0.y);
			if (lowest == -4 || val < lowest_val) {
				lowest = id;
				lowest_val = val;
			}
		}
	}
	return lowest;
}

