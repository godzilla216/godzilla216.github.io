function s_get_nearest_opponent(_arg0) {
	if (_arg0.tackling) {
		return _arg0.tackling;
	}
	var lowest, lowest_val;
	lowest = -4;
	lowest_val = -1;
	with (obj_player) {
		if (!dead && offense != _arg0.offense && tackling == -4) {
			var val = point_distance(x, y, _arg0.x, _arg0.y);
			if (lowest == -4 || val < lowest_val) {
				lowest = id;
				lowest_val = val;
			}
		}
	}
	return lowest;
}

