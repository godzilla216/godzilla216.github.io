if (!global.mobile_device && !global.browser) {
	ds_map_set(obj_master.player_profile, "xp_gain", target - ds_map_find_value(obj_master.player_profile, "xp"));
}
