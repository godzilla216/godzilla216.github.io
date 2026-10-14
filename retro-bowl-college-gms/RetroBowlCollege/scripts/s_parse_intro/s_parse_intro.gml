function s_parse_intro(_arg0) {
	if (global.gamepad) {
		if (os_type != 21 && !is_undefined(ds_map_find_value(obj_master.stringmap, _arg0 + "_gp_xb"))) {
			_arg0 += "_gp_xb";
		} else if (!is_undefined(ds_map_find_value(obj_master.stringmap, _arg0 + "_gp"))) {
			_arg0 += "_gp";
		}
	}
	_arg0 = s_str(_arg0);
	with (obj_master) {
		var oc = s_get_staff(102);
		var dc = s_get_staff(101);
		_arg0 = string_replace_all(_arg0, "$teamname", ds_map_find_value(myteam, "name"));
		_arg0 = string_replace_all(_arg0, "$coachname_of", ds_map_find_value(oc, "fname") + " " + ds_map_find_value(oc, "lname"));
		_arg0 = string_replace_all(_arg0, "$coachname_df", ds_map_find_value(dc, "fname") + " " + ds_map_find_value(dc, "lname"));
	}
	return string_hash_to_newline(_arg0);
}

