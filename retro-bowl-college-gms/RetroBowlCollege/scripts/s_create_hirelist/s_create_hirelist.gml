function s_create_hirelist(_arg0, _arg1) {
	slog("s_create_hirelist");
	var refresh = _arg0;
	var current_of = s_get_staff(102);
	var current_df = s_get_staff(101);
	var of_rat = ds_map_find_value(current_of, "rating");
	var df_rat = ds_map_find_value(current_df, "rating");
	if (_arg1) {
		if (of_rat < 5) {
			of_rat = 5;
		}
		if (df_rat < 5) {
			df_rat = 5;
		}
	}
	with (obj_master) {
		if (refresh) {
			var size = ds_list_size(hirelist);
			if (size) {
				var i = irandom(size - 1);
				ds_map_destroy(ds_list_find_value(hirelist, i));
				ds_list_set(hirelist, i, -1);
				ds_list_delete(hirelist, i);
			}
		}
		while (s_count_hires_by_position(102) < 4) {
			ds_list_add(hirelist, s_create_staff(102, clamp(of_rat + irandom(6), 2, 10)));
		}
		while (s_count_hires_by_position(101) < 4) {
			ds_list_add(hirelist, s_create_staff(101, clamp(df_rat + irandom(6), 2, 10)));
		}
		hirelist = s_sort_hirelist(hirelist);
	}
}

