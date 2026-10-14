function s_remove_player(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = "";
	}
	with (obj_master) {
		if (_arg0 == -4) {
			slog("s_remove_player: Invalid pmap");
			return true;
		}
		if (ds_exists(_arg0, 1) == false) {
			slog("s_remove_player: pmap not a map, direct delete (old version?)");
			var del_index = ds_list_find_index(roster, _arg0);
			if (del_index != -1) {
				ds_list_delete(roster, del_index);
			}
			return true;
		}
		if (ds_map_exists(_arg0, "hof") && ds_map_find_value(_arg0, "hof") == true) {
			slog("s_remove_player[" + string(ds_map_find_value(_arg0, "lname")) + "]: Archived in HoF. Reason[" + _arg1 + "]");
			ds_map_set(_arg0, "team_leave_reason", _arg1);
			ds_map_set(_arg0, "uniform_record", s_extract_uniform_cols_to_record(ds_map_find_value(_arg0, "teamid"), ""));
			if (_arg2 != "") {
				ds_map_set(_arg0, "epilogue", _arg2);
			}
			ds_map_set(_arg0, "class_of", obj_master.start_year + obj_master.year);
			ds_list_add(hoflist, _arg0);
			ds_list_delete(roster, ds_list_find_index(roster, _arg0));
			return false;
		} else {
			slog("s_remove_player[" + string(ds_map_find_value(_arg0, "lname")) + "]: Destroyed. Reason[" + _arg1 + "]");
			ds_list_delete(roster, ds_list_find_index(roster, _arg0));
			ds_map_destroy(_arg0);
			return true;
		}
	}
}

