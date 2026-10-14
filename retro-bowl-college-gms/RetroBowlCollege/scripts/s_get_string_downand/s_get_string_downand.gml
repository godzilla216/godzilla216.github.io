function s_get_string_downand() {
	var txt = "";
	switch (down) {
		case 1:
			txt = s_str("down_1and");
			break;
		case 2:
			txt = s_str("down_2and");
			break;
		case 3:
			txt = s_str("down_3and");
			break;
		case 4:
			txt = s_str("down_4and");
			break;
		default:
			return "";
	}
	if (x_yards < 300 || x_yards > 2300) {
		txt += " " + s_str("Goal");
	} else if (yards < 1) {
		txt += " " + s_str("Inches");
	} else {
		txt += " " + string(round(yards));
	}
	return txt;
}

