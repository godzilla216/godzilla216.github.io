function s_str_int_to_ordinal(_arg0) {
	var last_digit = _arg0 mod 10;
	var last_two_digits = _arg0 mod 100;
	var suffix = "th";
	if (last_two_digits < 11 || last_two_digits > 13) {
		switch (last_digit) {
			case 1:
				suffix = "st";
				break;
			case 2:
				suffix = "nd";
				break;
			case 3:
				suffix = "rd";
				break;
		}
	}
	return string(_arg0) + suffix;
}

