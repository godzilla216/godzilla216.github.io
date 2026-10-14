function s_parse_string(_arg0) {
	_arg0 = string_replace(_arg0, "$random_argument", s_str("argument_" + string(irandom_range(1, 14))));
	_arg0 = string_replace(_arg0, "$random_class", s_str("class_" + string(irandom_range(1, 8))));
	_arg0 = string_replace(_arg0, "$aan_random_class", s_str("aan_class_" + string(irandom_range(1, 8))));
	_arg0 = string_replace(_arg0, "$teamname", ds_map_find_value(obj_master.myteam, "name"));
	_arg0 = string_replace(_arg0, "$teamdivision", ds_map_find_value(obj_master.myteam, "conference") + " " + ds_map_find_value(obj_master.myteam, "division"));
	return _arg0;
}

