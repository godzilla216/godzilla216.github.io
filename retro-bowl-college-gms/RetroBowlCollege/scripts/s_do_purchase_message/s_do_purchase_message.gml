function s_do_purchase_message() {
	switch (os_type) {
		case 4:
			if (global.IAP_Enabled && extension_stubfunc_real()) {
				var msg = s_str("msg_PurchaseUnlock");
				msg = string_replace(msg, "$price", global.IAP_PurchaseID[0][1]);
				s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
			} else {
				global.IAP_Enabled = false;
				obj_master.alarm[0] = room_speed * 10;
				s_create_message("", s_str("msg_StoreConnect_Unlock"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			}
			break;
		case 3:
			if (global.IAP_Enabled) {
				var msg = s_str("msg_PurchaseUnlock");
				msg = string_replace(msg, "$price", global.IAP_PurchaseID[0][1]);
				s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
			} else {
				obj_master.alarm[0] = room_speed * 10;
				s_create_message("", s_str("msg_StoreConnect_Unlock"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			}
			break;
	}
}

