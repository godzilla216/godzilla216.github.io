function s_find_gamepad() {
	if (!global.browser) {
		for (var i = 0; i < gamepad_get_device_count(); i++) {
			if (gamepad_is_connected(i)) {
				if (s_gamepad_is_fingerprint_sensor(i)) {
					return;
				}
				slog(gamepad_get_description(i) + " connected (" + string(i) + ")");
				global.gamepad = true;
				global.gp_1.slot = i;
				with (obj_controller) {
					control_alpha = 5;
				}
				s_update_gamepad();
				return;
			}
		}
	}
}

function s_gamepad_is_fingerprint_sensor(_arg0) {
	var str = gamepad_get_description(_arg0);
	if (string_count("uinput-fpc", str) || string_count("uinput-goodix", str)) {
		slog("Ignoring fingerprint sensor");
		return true;
	}
	return false;
}

