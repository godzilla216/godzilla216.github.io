function s_create_fixdata(_arg0, _arg1, _arg2, _arg3) {
	slog("create fixture " + string(_arg2) + " @ " + string(_arg3));
	var fix = ds_map_create();
	ds_map_set(fix, "week", _arg1);
	ds_map_set(fix, "away_team", _arg2);
	ds_map_set(fix, "home_team", _arg3);
	ds_map_set(fix, "away_score", -1);
	ds_map_set(fix, "home_score", -1);
	ds_list_add(_arg0, fix);
	if (_arg2 == obj_master.myteam_id || _arg3 == obj_master.myteam_id) {
		s_add_to_human_fixtures(_arg1, _arg2, _arg3);
	}
}

