function s_fire_coach(_arg0) {
	var coach = _arg0;
	with (obj_master) {
		if (ds_map_find_value(coach, "trait") == 5) {
			fans = clamp(fans - 10, 0, 100);
		}
		if (ds_map_find_value(coach, "trait") == 7) {
			s_adjust_team_morale(-10, 0);
		}
		ds_list_delete(stafflist, ds_list_find_index(stafflist, coach));
		ds_map_destroy(coach);
		coach = -1;
	}
}

