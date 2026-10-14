function s_create_staff(_arg0, _arg1) {
	var lname = s_get_random_last_name();
	while (s_lastname_already_on_roster(lname)) {
		lname = s_get_random_last_name();
	}
	var pmap = ds_map_create();
	ds_map_set(pmap, "randnum", irandom(999));
	ds_map_set(pmap, "fname", s_get_random_first_name(true));
	ds_map_set(pmap, "lname", lname);
	ds_map_set(pmap, "position", _arg0);
	ds_map_set(pmap, "age", irandom_range(35, 59));
	ds_map_set(pmap, "attitude", irandom_range(40, 100));
	ds_map_set(pmap, "rating", _arg1);
	ds_map_set(pmap, "contract", 2);
	ds_map_set(pmap, "teamid", -1);
	ds_map_set(pmap, "flash_time", 0);
	ds_map_set(pmap, "condition", 100);
	ds_map_set(pmap, "xp", 0);
	ds_map_set(pmap, "xp_level", _arg1);
	ds_map_set(pmap, "xp_gain", 0);
	ds_map_set(pmap, "trait", 0);
	if (_arg1 > 1 && irandom(1)) {
		ds_map_set(pmap, "trait", irandom(9));
	}
	if (ds_map_find_value(pmap, "trait") == 1 && ds_map_find_value(pmap, "age") < 55) {
		ds_map_set(pmap, "trait", 0);
	}
	slog("Created staff member: " + ds_map_find_value(pmap, "fname") + " " + lname + " (" + s_get_string_position_full(_arg0) + ")");
	ds_map_set(pmap, "skin", irandom(1));
	if (ds_map_find_value(pmap, "skin")) {
		ds_map_set(pmap, "skin", 1 + irandom(1));
	}
	var fgrid = obj_master.face_grid_C;
	pmap = s_choose_face(pmap, fgrid);
	if (ds_map_find_value(pmap, "face_x") == 8) {
		ds_map_set(pmap, "fname", s_get_random_first_name(false));
	}
	return pmap;
}

function s_create_headcoach_pmap() {
	var pmap = ds_map_create();
	ds_map_set(pmap, "randnum", irandom(999));
	ds_map_set(pmap, "fname", obj_master.fname);
	ds_map_set(pmap, "lname", obj_master.lname);
	ds_map_set(pmap, "position", 100);
	ds_map_set(pmap, "age", 35 + obj_master.year);
	ds_map_set(pmap, "attitude", round((obj_master.fans + s_get_morale()) / 2));
	ds_map_set(pmap, "rating", ceil(obj_master.coach_rating / 2));
	ds_map_set(pmap, "contract", 9);
	ds_map_set(pmap, "teamid", obj_master.myteam_id);
	ds_map_set(pmap, "flash_time", -9999);
	ds_map_set(pmap, "condition", 100);
	ds_map_set(pmap, "xp", 0);
	ds_map_set(pmap, "xp_level", obj_master.year);
	ds_map_set(pmap, "xp_gain", 0);
	ds_map_set(pmap, "trait", 0);
	slog("Created staff member: " + ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname") + " (" + s_get_string_position_full(100) + ")");
	ds_map_set(pmap, "skin", 1);
	ds_map_set(pmap, "face_x", obj_master.myface_x);
	ds_map_set(pmap, "face_y", obj_master.myface_y);
	return pmap;
}

