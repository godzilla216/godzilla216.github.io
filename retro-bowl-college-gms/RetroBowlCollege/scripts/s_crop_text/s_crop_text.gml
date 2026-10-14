function s_crop_text(_arg0, _arg1) {
	var txt = _arg0;
	var maxchars = _arg1;
	var len = string_length(txt);
	var doublenewline = string_pos("##", txt);
	var bonus = "";
	if (doublenewline != 0) {
		bonus = string_copy(txt, doublenewline, len);
		txt = string_copy(txt, 1, doublenewline);
		len = string_length(txt);
	}
	var pos = maxchars;
	var p = 0;
	while (p < len - maxchars) {
		for (p = pos; p > pos - 10; p--) {
			var foundspace = false;
			if (string_char_at(txt, p) == " ") {
				foundspace = true;
				break;
			}
		}
		if (foundspace) {
			txt = string_insert("\n", txt, p);
		} else {
			p = pos - 1;
			txt = string_insert("-", txt, p++);
			txt = string_insert("\n", txt, p);
		}
		pos = p + maxchars;
		len = string_length(txt);
	}
	txt += bonus;
	return string_hash_to_newline(txt);
}

