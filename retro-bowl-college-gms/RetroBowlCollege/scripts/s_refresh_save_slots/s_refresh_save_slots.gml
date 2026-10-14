function s_refresh_save_slots() {
	if (file_exists(global.g_savename1)) {
		inst_100012.text = s_get_string_save_details(1, false);
	} else {
		inst_100006.text = s_str("ui_NewGame");
		inst_100009.active = false;
	}
	if (file_exists(global.g_savename2)) {
		inst_100013.text = s_get_string_save_details(2, false);
	} else {
		inst_100007.text = s_str("ui_NewGame");
		inst_100010.active = false;
	}
	if (file_exists(global.g_savename3)) {
		inst_100014.text = s_get_string_save_details(3, false);
	} else {
		inst_100008.text = s_str("ui_NewGame");
		inst_100011.active = false;
	}
	if (file_exists(global.g_savename4)) {
		inst_100017.text = s_get_string_save_details(4, false);
	} else {
		inst_100018.text = s_str("ui_NewGame");
		inst_100016.active = false;
	}
	if (file_exists(global.g_savename5)) {
		inst_100020.text = s_get_string_save_details(5, false);
	} else {
		inst_100021.text = s_str("ui_NewGame");
		inst_100019.active = false;
	}
}

