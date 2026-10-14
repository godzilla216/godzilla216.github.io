function s_set_up_purchase_ids() {
	slog("s_set_up_purchase_ids");
	global.credits_20 = "credits_20";
	global.credits_50 = "credits_50";
	global.credits_100 = "credits_100";
	global.credits_250 = "credits_250";
	global.credits_25 = "credits_25";
	global.credits_75 = "credits_75";
	global.rb_full_version = "rb_full_version";
	if (s_is_co_mode()) {
		global.credits_20 = "college_credits_500";
		global.credits_50 = "college_credits_50";
		global.credits_100 = "college_credits_100";
		global.credits_250 = "college_credits_250";
		global.credits_25 = "college_credits_25";
		global.credits_75 = "college_credits_75";
		global.rb_full_version = "college_full_version";
	}
	slog("s_set_up_purchase_ids... using style (credits_20)->(" + string(global.credits_20) + ")");
	global.IAP_PurchaseID[0][0] = global.rb_full_version;
	global.IAP_PurchaseID[1][0] = global.credits_20;
	global.IAP_PurchaseID[2][0] = global.credits_50;
	global.IAP_PurchaseID[3][0] = global.credits_100;
	global.IAP_PurchaseID[4][0] = global.credits_250;
	global.IAP_PurchaseID[5][0] = global.credits_25;
	global.IAP_PurchaseID[6][0] = global.credits_75;
	for (var i = 1; i < 4; i++) {
		global.IAP_PurchaseID[0][i] = "";
		global.IAP_PurchaseID[1][i] = "";
		global.IAP_PurchaseID[2][i] = "";
		global.IAP_PurchaseID[3][i] = "";
		global.IAP_PurchaseID[4][i] = "";
		global.IAP_PurchaseID[5][i] = "";
		global.IAP_PurchaseID[6][i] = "";
	}
}

