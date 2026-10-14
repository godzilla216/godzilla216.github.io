function s_unfreeze_purchase_buttons() {
	slog("s_unfreeze_purchase_buttons");
	with (obj_btn_buy) {
		alarm[0] = -1;
	}
	with (obj_btn_restore) {
		alarm[0] = -1;
	}
}

