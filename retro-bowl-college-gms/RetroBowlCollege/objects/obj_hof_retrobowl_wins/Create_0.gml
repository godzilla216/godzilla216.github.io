function s_hof_retrobowl_wins_franchise_create() {
	var belichick = 0;
	with (obj_master) {
		for (var i = 0; i < ds_list_size(rbhistorylist); i++) {
			var map = ds_list_find_value(rbhistorylist, i);
			if (ds_map_find_value(map, "winner") == "New England" && real(ds_map_find_value(map, "year")) <= 2026 && ds_map_find_value(map, "human") == 0) {
				belichick++;
			}
		}
	}
	retrobowlhof = s_load_retrobowl_hof();
	for (var i = 0; i < ds_list_size(retrobowlhof); i++) {
		var map = ds_list_find_value(retrobowlhof, i);
		if (ds_map_find_value(map, "name") == "B.Belichick") {
			ds_map_set(map, "count", real(ds_map_find_value(map, "count")) + belichick);
		}
	}
	var count = s_count_achievement("ACH_WIN_RETROBOWL1");
	slog("ACH_RETROBOWL1 = " + string(count));
	var map = ds_map_create();
	ds_map_set(map, "count", count);
	ds_map_set(map, "name", "you_" + string_copy(obj_master.fname, 1, 1) + "." + obj_master.lname);
	ds_list_add(retrobowlhof, map);
	retrobowlhof = s_sort_retrobowl_list(retrobowlhof);
}

function s_academic_gpa_limits_create() {
	txt_h = string_hd_height("I");
}

if (s_is_co_mode()) {
	s_academic_gpa_limits_create();
} else {
	s_hof_retrobowl_wins_franchise_create();
}
