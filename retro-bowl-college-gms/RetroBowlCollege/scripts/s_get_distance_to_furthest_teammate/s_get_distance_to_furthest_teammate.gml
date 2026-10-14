function s_get_distance_to_furthest_teammate(_arg0) {
	var furthest = 0;
	with (obj_player) {
		if (offense == _arg0.offense) {
			var val = point_distance(x, y, _arg0.x, _arg0.y);
			if (val > furthest) {
				furthest = val;
			}
		}
	}
	with (obj_dummy) {
		var val = point_distance(x, y, _arg0.x, _arg0.y);
		if (val > furthest) {
			furthest = val;
		}
	}
	return furthest;
}

