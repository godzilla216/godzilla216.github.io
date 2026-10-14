function s_get_string_trade_value(_arg0) {
	var traderound = _arg0;
	if (traderound > 0) {
		return s_str("tla_Round") + " " + string(traderound) + " " + s_str("ui_Pick");
	}
	return s_str("ui_None");
}

