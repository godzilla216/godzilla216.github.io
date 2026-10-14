function s_hex_string_to_col(_arg0) {
	var input = string(_arg0);
	var result = 0;
	var ZERO = 48;
	var NINE = 57;
	var A = 65;
	var F = 70;
	for (var i = 1; i <= string_length(input); i++) {
		var c = ord(string_char_at(string_upper(input), i));
		result = result << 4;
		if (c >= ZERO && c <= NINE) {
			result += c - ZERO;
		} else if (c >= A && c <= F) {
			result += c - A + 10;
		}
	}
	return result;
}

