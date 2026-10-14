function s_iap_init() {
	slog("_s_iap_init__________________");
	switch (os_type) {
		case 4:
			slog("s_iap_android");
			global.CurrentTokens = ds_list_create();
			global.CurrentProducts = ds_list_create();
			var _init = extension_stubfunc_real();
			if (_init == -1) {
				slog("ERROR - Billing API Has Not Connected!");
				obj_master.alarm[0] = room_speed * 10;
			}
			break;
		case 3:
			slog("s_iap_init: ios");
			if (!global.IAP_Enabled && extension_stubfunc_real()) {
				slog("ios_iap_IsAuthorisedForPayment == true");
				extension_stubfunc_real(global.IAP_PurchaseID[0][0]);
				extension_stubfunc_real(global.IAP_PurchaseID[1][0]);
				extension_stubfunc_real(global.IAP_PurchaseID[2][0]);
				extension_stubfunc_real(global.IAP_PurchaseID[3][0]);
				extension_stubfunc_real(global.IAP_PurchaseID[4][0]);
				extension_stubfunc_real(global.IAP_PurchaseID[5][0]);
				extension_stubfunc_real(global.IAP_PurchaseID[6][0]);
				extension_stubfunc_real();
			} else {
				slog("ios_iap_IsAuthorisedForPayment == false");
				obj_master.alarm[0] = room_speed * 10;
			}
			break;
	}
}

