function s_get_savename() {
	with (obj_master) {
		var slot = ds_map_find_value(map_options, "saveslot");
		if (slot == 5) {
			return global.g_savename5;
		}
		if (slot == 4) {
			return global.g_savename4;
		}
		if (slot == 3) {
			return global.g_savename3;
		}
		if (slot == 2) {
			return global.g_savename2;
		}
		return global.g_savename1;
	}
}

