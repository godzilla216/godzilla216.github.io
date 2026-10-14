if (ds_exists(async_load, 1)) {
	slog("Async_System: " + string(ds_map_find_value(async_load, "event_type")));
	switch (ds_map_find_value(async_load, "event_type")) {
		case "audio_system_status":
			if (!global.browser) {
				exit;
			}
			s_update_music();
			break;
	}
	s_gamepad_async();
}
