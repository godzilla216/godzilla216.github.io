function s_set_up_qb_pmap() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (ds_map_find_value(pmap, "position") == 1) {
				ds_map_set(pmap, "fname", fname);
				ds_map_set(pmap, "lname", lname);
				ds_map_set(pmap, "age", 21);
				ds_map_set(pmap, "skill", 1);
				ds_map_set(pmap, "speed", 1);
				ds_map_set(pmap, "strength", 1);
				ds_map_set(pmap, "stamina", 1);
				ds_map_set(pmap, "max_skill", 10);
				ds_map_set(pmap, "max_speed", 10);
				ds_map_set(pmap, "max_strength", 10);
				ds_map_set(pmap, "max_stamina", 10);
				ds_map_set(pmap, "contract", 2);
				ds_map_set(pmap, "attitude", 50);
				ds_map_set(pmap, "salary", s_get_new_salary(pmap));
				ds_map_set(pmap, "xp", 0);
				ds_map_set(pmap, "xp_level", 1);
				ds_map_set(pmap, "condition", 100);
				ds_map_set(pmap, "skin", my_skin);
				ds_map_set(pmap, "face_x", myface_x);
				ds_map_set(pmap, "face_y", myface_y);
				return;
			}
		}
	}
}

