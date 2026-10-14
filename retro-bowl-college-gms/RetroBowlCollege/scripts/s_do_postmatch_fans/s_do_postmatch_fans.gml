function s_do_postmatch_fans() {
	with (obj_master) {
		var fixture = s_get_human_fixture_by_week(week);
		var fans_inc = 0;
		if (fixture) {
			fans_inc = facility_stadium - 6;
			if (ds_map_find_value(fixture, "human_win") == "loss") {
				fans_inc -= 10;
			} else if (ds_map_find_value(fixture, "human_win") == "win") {
				fans_inc += 8;
			} else {
				fans_inc -= 3;
			}
			fans_inc += s_count_trait_fanfavorite();
			if (suppress_difficulty < 5) {
				fans_inc--;
			}
			if (suppress_difficulty < 1) {
				fans_inc--;
			}
		}
		fans_inc = clamp(fans_inc, -15, 15);
		fans = clamp(fans + fans_inc, 1, 100);
		fans_done_update = true;
	}
}

function s_get_postmatch_fans_qb() {
	with (obj_master) {
		var fixture = s_get_human_fixture_by_week(week);
		if (fixture) {
			if (ds_map_find_value(fixture, "human_win") == "loss") {
				return -5;
			} else if (ds_map_find_value(fixture, "human_win") == "win") {
				return 3;
			} else {
				return -2;
			}
		}
	}
	return 0;
}

