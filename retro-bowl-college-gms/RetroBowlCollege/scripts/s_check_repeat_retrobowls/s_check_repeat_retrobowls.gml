function s_check_repeat_retrobowls() {
	with (obj_master) {
		var conseq = 0;
		var highest_conseq = 0;
		for (var i = 0; i < ds_list_size(history); i++) {
			var map = ds_list_find_value(history, i);
			if (map && ds_map_exists(map, "year") && ds_map_exists(map, "finish")) {
				if (string_count(s_str("finish_SuperBowl"), ds_map_find_value(map, "finish")) > 0) {
					conseq++;
					if (conseq > highest_conseq) {
						highest_conseq = conseq;
					}
				} else {
					highest_conseq = conseq;
					conseq = 0;
				}
			}
		}
		if (highest_conseq > 1) {
			s_complete_achievement("ACH_BACKTOBACK");
		}
		if (highest_conseq > 2) {
			s_complete_achievement("ACH_THREEPEAT");
		}
	}
}

