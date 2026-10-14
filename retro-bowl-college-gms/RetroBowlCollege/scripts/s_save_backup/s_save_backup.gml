function s_save_backup() {
	if (os_browser == -1) {
		slog("s_save_backup");
		var save_name = s_get_savename();
		var backup_name = "backup_" + save_name;
		if (file_exists(backup_name)) {
			file_delete(backup_name);
		}
		file_copy(save_name, backup_name);
		s_nx_commit();
	}
}

