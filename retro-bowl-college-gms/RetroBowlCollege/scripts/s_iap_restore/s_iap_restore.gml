function s_iap_restore() {
	switch (os_type) {
		case 4:
			break;
		case 3:
			if (!os_is_network_connected()) {
				s_msg_clear();
				s_create_message("", s_str("msg_StoreConnect"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
				return;
			} else {
				alarm[1] = room_speed * 4;
				s_freeze_purchase_buttons();
				extension_stubfunc_real();
			}
			break;
	}
}

