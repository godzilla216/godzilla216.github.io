function s_aim_for_nearest_opponent() {
	if (nearest_opp) {
		jdir = point_direction(x, y, nearest_opp.x, nearest_opp.y);
		jforce = clamp(nearest_opp_dist / 20, 0.5, 1);
	}
	return;
	var lowest, lowest_val;
	lowest = -4;
	lowest_val = -1;
	with (obj_player) {
		if (!dead && offense != other.offense && other.tackling == -4 && tackling == -4) {
			var val = point_distance(x, y, other.x, other.y);
			if (lowest == -4 || val < lowest_val) {
				lowest = id;
				lowest_val = val;
			}
		}
	}
	if (lowest != -4) {
		jdir = point_direction(x, y, lowest.x, lowest.y);
		jforce = clamp(lowest_val / 20, 0.5, 1);
		return;
	}
	jforce = 0;
}

