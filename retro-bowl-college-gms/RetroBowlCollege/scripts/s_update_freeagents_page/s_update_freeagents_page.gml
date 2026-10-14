function s_update_freeagents_page() {
	slog("s_update_freeagents");
	with (obj_player_profile) {
		instance_destroy();
	}
	var list = obj_master.freeagentlist;
	var size = ds_list_size(list);
	if (size < 1) {
		slog("tradeoffer");
		list = obj_master.tradelist;
		size = ds_list_size(list);
		inst_100123.text = s_str("ui_TradeOffer");
	}
	var gap = 4;
	var max_roster = s_get_roster_cap();
	var cards_per_row = max_roster / 2;
	if (size <= 10) {
		cards_per_row = 5;
		gap = 8;
	}
	if (size <= 8) {
		cards_per_row = 4;
	}
	if (size <= 6) {
		cards_per_row = 3;
	}
	var px = round(g_pBuiltIn.room_width * 0.5);
	var py = round(g_pBuiltIn.room_height * 0.49);
	var pw = sprite_get_width(spr_box_64x80) + gap;
	if (size > cards_per_row) {
		py -= 44;
		px -= (cards_per_row - 1) * pw * 0.5;
	} else {
		px -= (size - 1) * (pw * 0.5);
	}
	for (var i = 0; i < size; i++) {
		profile[i] = instance_create_layer(0, 0, "Instances", obj_player_profile);
		profile[i].pmap = ds_list_find_value(list, i);
		profile[i].x = px - pw * 0.5;
		profile[i].y = py - profile[0].sprite_height * 0.5;
		px += pw;
		if (i == cards_per_row - 1) {
			var sz = size - cards_per_row;
			px = g_pBuiltIn.room_width * 0.5;
			px -= (sz - 1) * (pw * 0.5);
			py += 88;
		}
	}
	if (s_is_co_mode()) {
		inst_100128.visible = false;
	}
}

