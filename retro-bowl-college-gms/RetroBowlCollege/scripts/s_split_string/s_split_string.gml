function s_split_string(_arg0) {
	if (s_is_co_mode()) {
		return string_split(_arg0, "\t");
	}
	var splitBy = "\t";
	var slot = 0;
	var splits;
	var str2 = "";
	splits[slot] = "";
	for (var i = 1; i < string_length(_arg0) + 1; i++) {
		var currStr = string_copy(_arg0, i, 1);
		if (currStr == splitBy) {
			splits[slot] = str2;
			slot++;
			str2 = "";
		} else {
			str2 += currStr;
			splits[slot] = str2;
		}
	}
	return splits;
}

