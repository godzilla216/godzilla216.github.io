function s_tackle_failure() {
	if (comm_defender) {
		switch (ds_map_find_value(comm_defender, "position")) {
			case 6:
				ds_map_set(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") - 4);
				break;
			case 7:
				ds_map_set(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") - 3);
				break;
			case 9:
			case 8:
				ds_map_set(comm_defender, "stat_tackles", ds_map_find_value(comm_defender, "stat_tackles") - 2);
				break;
		}
		if (ds_map_find_value(comm_defender, "stat_tackles") < 0) {
			ds_map_set(comm_defender, "stat_tackles", 0);
		}
	}
}

