function s_load_profile_uni(_arg0) {
	if (_arg0 && _arg0.pmap != -4) {
		slog("s_load_profile_uni: " + ds_map_find_value(_arg0.pmap, "fname") + ds_map_find_value(_arg0.pmap, "lname"));
		var tid = -1;
		if (ds_map_exists(_arg0.pmap, "teamid") && ds_map_find_value(_arg0.pmap, "teamid") > -1) {
			tid = ds_map_find_value(_arg0.pmap, "teamid");
		} else if (ds_list_find_index(obj_master.stafflist, _arg0.pmap) > -1) {
			tid = obj_master.myteam_id;
		} else if (_arg0.pmap == obj_master.boss_profile) {
			tid = obj_master.myteam_id;
		} else {
			slog("NOT FOUND");
		}
		if (tid > -1) {
			var uniform = instance_create_layer(0, 0, "Instances", obj_uniform);
			uniform.visible = false;
			s_load_uniform_file2(tid, uniform, 0, "");
			with (_arg0) {
				s_set_up_uniform_profile(uniform);
			}
		}
	}
}

