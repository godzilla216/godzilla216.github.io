function s_save_options() {
	slog("saving options...");
	if (os_is_paused()) {
		return;
	}
	with (obj_master) {
		ds_map_set(map_options, "my_version", global.g_version);
		ds_map_secure_save(map_options, global.g_optionsave);
	}
	s_nx_commit();
}

