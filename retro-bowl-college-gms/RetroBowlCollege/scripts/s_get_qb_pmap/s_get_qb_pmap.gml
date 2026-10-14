function s_get_qb_pmap() {
	if (instance_exists(obj_controller) && variable_instance_exists(100270, "team_roster")) {
		var this_roster = obj_controller.team_roster[obj_controller.human_team];
		for (var i = 0; i < ds_list_size(this_roster); i++) {
			var pmap = ds_list_find_value(this_roster, i);
			if (ds_map_find_value(pmap, "position") == 1) {
				return pmap;
			}
		}
		return -4;
	}
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 1) {
				return pmap;
			}
		}
	}
}

