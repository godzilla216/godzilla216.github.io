function s_nx_init() {
	switch (os_type) {
		case 21:
			with (obj_master) {
				slog("Init switch save slot");
				nx_player_id = s_nx_get_open_user();
				slogf("User selected: %1 (%2)", switch_accounts_get_nickname(nx_player_id), switch_accounts_is_user_open(nx_player_id));
				switch_save_data_mount(nx_player_id);
			}
			break;
	}
}

function s_nx_commit() {
	switch (os_type) {
		case 21:
			slog("Commit data on switch save slot");
			switch_save_data_commit();
			break;
	}
}

function s_nx_get_open_user() {
	for (var i = 0; i < switch_accounts_get_accounts(); i++) {
		slogf("User %1 is %2", switch_accounts_get_nickname(i), switch_accounts_is_user_open(i));
		if (switch_accounts_is_user_open(i)) {
			return i;
		}
	}
	return -4;
}

