function s_parse_news(_arg0, _arg1, _arg2, _arg3, _arg4) {
	_arg0 = s_str(_arg0);
	if (_arg1) {
		_arg0 = string_replace_all(_arg0, "$teamname1", ds_map_find_value(_arg1, "name"));
	}
	if (_arg2) {
		_arg0 = string_replace_all(_arg0, "$teamname2", ds_map_find_value(_arg2, "name"));
	}
	_arg0 = string_replace_all(_arg0, "$score1", string(_arg3));
	_arg0 = string_replace_all(_arg0, "$score2", string(_arg4));
	_arg0 = string_replace_all(_arg0, "$yourname", obj_master.fname + " " + obj_master.lname);
	_arg0 = string_replace_all(_arg0, "$yourlastname", obj_master.lname);
	_arg0 = string_replace_all(_arg0, "$yourteamname", ds_map_find_value(obj_master.myteam, "tla"));
	return string_hash_to_newline(_arg0);
}

