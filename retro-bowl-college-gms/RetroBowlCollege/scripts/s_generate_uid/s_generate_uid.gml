function s_generate_uid(_arg0, _arg1) {
	random_set_seed(_arg0);
	var nums = _arg1;
	var r = "";
	for (var i = 0; i < nums; i++) {
		if (i > 0 && i mod 4 == 0) {
			r += "-";
		}
		r += choose("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
	}
	random_set_seed(current_time);
	return r;
}

