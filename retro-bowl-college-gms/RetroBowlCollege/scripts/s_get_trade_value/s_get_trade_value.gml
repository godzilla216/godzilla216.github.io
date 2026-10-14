function s_get_trade_value(_arg0) {
	var rating = s_get_player_rating(_arg0);
	if (rating >= 8) {
		return 1;
	}
	if (rating >= 4) {
		return 2;
	}
	return 3;
}

