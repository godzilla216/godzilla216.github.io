function s_check_record(_arg0, _arg1, _arg2, _arg3, _arg4) {
	if (obj_master.gamepractice) {
		return;
	}
	if (global.exhibition) {
		return;
	}
	var map = s_get_record(_arg0);
	if (ds_exists(map, 1) && ds_map_exists(map, "stat") && _arg1 > ds_map_find_value(map, "stat")) {
		if (ds_map_find_value(map, "stat") > 0 && current_room == rm_match && instance_exists(obj_ball)) {
			global.replay_do = true;
			s_notification(s_str("ui_NewRecord") + "!", s_str(ds_map_find_value(map, "tag")));
		}
		ds_map_set(map, "stat", _arg1);
		if (_arg2 != "") {
			ds_map_set(map, "qbname", _arg2);
		}
		if (_arg3 != "") {
			ds_map_set(map, "playername", _arg3);
		}
		ds_map_set(map, "year", obj_master.year);
		ds_map_set(map, "week", obj_master.week);
		ds_map_set(map, "team", ds_map_find_value(obj_master.myteam, "tla"));
		if (_arg4 != "") {
			ds_map_set(map, "opponent", _arg4);
		}
	}
}

