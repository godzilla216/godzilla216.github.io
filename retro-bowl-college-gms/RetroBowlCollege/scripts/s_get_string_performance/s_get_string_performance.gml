function s_get_string_performance(_arg0) {
	if (_arg0 > 90) {
		return s_str("rating_Incredible") + "!";
	}
	if (_arg0 > 75) {
		return s_str("rating_Great");
	}
	if (_arg0 > 60) {
		return s_str("rating_Good");
	}
	if (_arg0 > 45) {
		return s_str("rating_Ok");
	}
	if (_arg0 > 30) {
		return s_str("rating_Poor");
	}
	return s_str("rating_Terrible") + "!";
}

