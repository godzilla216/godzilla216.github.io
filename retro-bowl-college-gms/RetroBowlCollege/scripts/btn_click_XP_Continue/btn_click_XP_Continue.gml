function btn_click_XP_Continue() {
	with (obj_master) {
		with (obj_credit) {
			instance_destroy();
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (!s_has_xp_gain(pmap)) {
				ds_map_set(pmap, "xp", round(ds_map_find_value(pmap, "xp") + ds_map_find_value(pmap, "xp_gain")));
				ds_map_set(pmap, "xp_gain", 0);
			}
		}
		for (var i = 0; i < ds_list_size(stafflist); i++) {
			var pmap = ds_list_find_value(stafflist, i);
			if (!s_has_xp_gain(pmap)) {
				ds_map_set(pmap, "xp", round(ds_map_find_value(pmap, "xp") + ds_map_find_value(pmap, "xp_gain")));
				ds_map_set(pmap, "xp_gain", 0);
			}
		}
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			if (s_has_xp_gain(pmap)) {
				player_profile = pmap;
				room_goto(rm_profile_player);
				return;
			}
		}
		for (var i = 0; i < ds_list_size(stafflist); i++) {
			var pmap = ds_list_find_value(stafflist, i);
			if (s_has_xp_gain(pmap)) {
				player_profile = pmap;
				room_goto(rm_profile_staff);
				return;
			}
		}
	}
	if (obj_master.stage == 7) {
		s_play(1);
	} else if (obj_master.player_profile && ds_map_find_value(obj_master.player_profile, "meetingdone") == 1) {
		room_goto(rm_profile_player);
	} else if (obj_master.qb_mode) {
		room_goto(rm_profile_player);
	} else {
		room_goto(rm_frontoffice);
	}
}

