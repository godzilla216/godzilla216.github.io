function s_round_to_decimal(_arg0, _arg1) {
	var mult = power(10, _arg1);
	return floor(_arg0 * mult) / mult;
}

