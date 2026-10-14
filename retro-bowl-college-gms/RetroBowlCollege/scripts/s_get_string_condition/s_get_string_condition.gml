function s_get_string_condition(_arg0) {
	var con = _arg0;
	if (con <= -1) {
		return s_str("condition_0") + " (" + string(abs(con)) + ")";
	} else if (con <= 20) {
		return s_str("condition_1");
	} else if (con <= 40) {
		return s_str("condition_2");
	} else if (con <= 60) {
		return s_str("condition_3");
	} else if (con <= 80) {
		return s_str("condition_4");
	} else if (con <= 99) {
		return s_str("condition_5");
	} else {
		return s_str("condition_6");
	}
}

