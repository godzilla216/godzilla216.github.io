function s_set_rewarded_route() {
	with (obj_playerOF) {
		if (path_exists(my_route) && !te_blocking && position != 1) {
			if (!irandom(4)) {
				if (pmap && ds_map_find_value(pmap, "attitude") > 99) {
					continue;
				} else {
					rewarded_route = true;
					return;
				}
			}
		}
	}
}

