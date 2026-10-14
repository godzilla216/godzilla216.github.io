function s_iap_purchase_FullVersion() {
	if (!os_is_network_connected()) {
		s_msg_clear();
		s_create_message("", s_str("msg_StoreConnect"), s_str("ui_Continue"), "", s_btn_store_exit, "", global.c_background, 1);
		return;
	}
	s_freeze_purchase_buttons();
	switch (os_type) {
		case 4:
			if (extension_stubfunc_real() && global.IAP_Enabled) {
				var _chk = extension_stubfunc_real(global.IAP_PurchaseID[0][0]);
				if (_chk != 0) {
				}
			} else {
				obj_master.alarm[0] = room_speed * 10;
			}
			break;
		case 3:
			if (global.IAP_Enabled) {
				extension_stubfunc_real(global.IAP_PurchaseID[0][0]);
			} else {
				obj_master.alarm[0] = room_speed * 10;
			}
			break;
		case 1:
		case 0:
			if (s_is_debug_desktop()) {
				slog("receipt for: rb_full_version");
				if (!ds_map_find_value(obj_master.map_options, "fullversion")) {
					obj_master.coach_credit += 25;
					ds_map_set(obj_master.map_options, "op_weather", 1);
					ds_map_set(obj_master.map_options, "op_replays", 1);
					ds_map_set(obj_master.map_options, "op_kickoffs", 1);
					audio_play_sound(snd_purchase, 1, false);
				}
				ds_map_set(obj_master.map_options, "fullversion", 1);
				s_savegame();
				s_unfreeze_purchase_buttons();
			}
			break;
	}
}

