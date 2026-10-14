with (obj_input_box) {
	exit;
}
if (global.debug) {
	if (ds_map_exists(obj_master.player_profile, "opoy")) {
		ds_map_set(obj_master.player_profile, "opoy", ds_map_find_value(obj_master.player_profile, "opoy") + 1);
	} else {
		ds_map_set(obj_master.player_profile, "opoy", 1);
	}
}
