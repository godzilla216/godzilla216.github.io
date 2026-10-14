with (obj_input_box) {
	exit;
}
if (global.debug) {
	ds_map_set(obj_master.player_profile, "xp_gain", target - ds_map_find_value(obj_master.player_profile, "xp") - 0.5);
}
