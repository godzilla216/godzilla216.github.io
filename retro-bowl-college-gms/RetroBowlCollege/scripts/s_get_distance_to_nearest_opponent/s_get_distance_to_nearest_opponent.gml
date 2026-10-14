function s_get_distance_to_nearest_opponent() {
	var nearest = 1000;
	with (obj_player) {
		if (offense != other.offense && !dead) {
			var val = point_distance(x, y, other.x, other.y);
			if (val < nearest) {
				nearest = val;
			}
		}
	}
	return nearest;
}

