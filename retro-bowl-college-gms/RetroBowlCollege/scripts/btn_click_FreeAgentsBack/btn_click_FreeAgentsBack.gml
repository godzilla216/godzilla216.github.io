function btn_click_FreeAgentsBack() {
	slog("btn_click_FreeAgentBack");
	with (obj_master) {
		slog("FreeAgents=" + string(ds_list_size(freeagentlist)));
		slog("TradeList=" + string(ds_list_size(tradelist)));
		if (ds_list_size(freeagentlist) > 0) {
			var msg = s_str("msg_ClearFreeAgent");
			if (ds_list_size(freeagentlist) > 1) {
				msg = s_str("msg_ClearFreeAgents");
			}
			s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_clearfreeagents, global.c_background, 1);
			return;
		} else if (ds_list_size(tradelist) > 0) {
			var msg = s_str("msg_ClearTradeOffer");
			s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_clearfreeagents, global.c_background, 1);
			return;
		}
	}
	room_goto(rm_home);
}

