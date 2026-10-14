function s_freeze_purchase_buttons() {
	slog("s_freeze_purchase_buttons");
	with (obj_btn_buy) {
		active = false;
		alarm[0] = room_speed * 20;
	}
	with (obj_btn_restore) {
		active = false;
		alarm[0] = room_speed * 20;
	}
}

