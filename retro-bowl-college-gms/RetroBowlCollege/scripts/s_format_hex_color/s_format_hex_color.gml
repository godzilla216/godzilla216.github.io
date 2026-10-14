function s_format_hex_color(_arg0) {
	slog("s_format_hex_color");
	var col = _arg0;
	col = string_lettersdigits(col);
	col = string_upper(col);
	col = string_replace_all(col, "G", "0");
	col = string_replace_all(col, "H", "0");
	col = string_replace_all(col, "I", "0");
	col = string_replace_all(col, "J", "0");
	col = string_replace_all(col, "K", "0");
	col = string_replace_all(col, "L", "0");
	col = string_replace_all(col, "M", "0");
	col = string_replace_all(col, "N", "0");
	col = string_replace_all(col, "O", "0");
	col = string_replace_all(col, "P", "0");
	col = string_replace_all(col, "Q", "0");
	col = string_replace_all(col, "R", "0");
	col = string_replace_all(col, "S", "0");
	col = string_replace_all(col, "T", "0");
	col = string_replace_all(col, "U", "0");
	col = string_replace_all(col, "V", "0");
	col = string_replace_all(col, "W", "0");
	col = string_replace_all(col, "X", "0");
	col = string_replace_all(col, "Y", "0");
	col = string_replace_all(col, "Z", "0");
	while (string_length(col) < 6) {
		col += "0";
	}
	if (col == "FF0000") {
		col = "FA0000";
	}
	if (col == "00FF00") {
		col = "00FA00";
	}
	if (col == "0000FF") {
		col = "0000FA";
	}
	if (col == "FF00FF") {
		col = "FA00FA";
	}
	if (col == "FFFF00") {
		col = "FAFA00";
	}
	if (col == "800000") {
		col = "850000";
	}
	if (col == "008000") {
		col = "008500";
	}
	if (col == "000080") {
		col = "000085";
	}
	if (col == "8080FF") {
		col = "8080FA";
	}
	if (col == "808080") {
		col = "858080";
	}
	return "$" + col;
}

