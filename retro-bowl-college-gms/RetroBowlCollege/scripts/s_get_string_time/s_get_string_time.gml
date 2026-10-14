function s_get_string_time(_arg0, _arg1) {
	var mins = string(_arg0);
	var secs = string(_arg1);
	if (string_length(secs) < 2) {
		return mins + ":0" + secs;
	}
	return mins + ":" + secs;
}

