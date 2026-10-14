function s_get_ticker_text() {
	obj_master.ticker_count++;
	if (obj_master.ticker_count > 3) {
		obj_master.ticker_count = 0;
	}
	var allowLinks = !(global.console_build || 0);
	switch (obj_master.ticker_count) {
		case 0:
			if (allowLinks) {
				return s_str("msg_TickerTwitter");
				break;
			}
		case 2:
			if (allowLinks) {
				return s_str("msg_TickerReddit");
				break;
			}
		case 1:
		case 3:
			if (allowLinks) {
				if (obj_master.tip_count >= 32 && obj_master.tip_count <= 36) {
					obj_master.tip_count = 1;
				}
			}
			var msg = s_str("tip_" + string(++obj_master.tip_count));
			if (string_count("@", msg)) {
				obj_master.tip_count = 1;
				msg = s_str("tip_1");
			}
			return s_str("ui_Tip") + "! " + msg;
			break;
	}
	return s_get_ticker_text();
}

