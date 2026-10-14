function s_reset_player_meetings() {
	with (obj_master) {
		for (var i = 0; i < ds_list_size(roster); i++) {
			var pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "meetingdone", 0);
		}
	}
}

