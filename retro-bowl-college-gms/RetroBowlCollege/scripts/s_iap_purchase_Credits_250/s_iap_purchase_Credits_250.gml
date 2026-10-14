function s_iap_purchase_Credits_250() {
	if (!os_is_network_connected()) {
		s_msg_clear();
		s_create_message("", s_str("msg_StoreConnect"), s_str("ui_Continue"), "", s_btn_store_exit, "", global.c_background, 1);
		return;
	}
	s_freeze_purchase_buttons();
	switch (os_type) {
		case 4:
			if (extension_stubfunc_real() && global.IAP_Enabled) {
				var _chk = extension_stubfunc_real(global.IAP_PurchaseID[4][0]);
				if (_chk != 0) {
				}
			} else {
				obj_master.alarm[0] = room_speed * 10;
			}
			break;
		case 3:
			if (global.IAP_Enabled) {
				extension_stubfunc_real(global.IAP_PurchaseID[4][0]);
			} else {
				obj_master.alarm[0] = room_speed * 10;
			}
			break;
	}
}

