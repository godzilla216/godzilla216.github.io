function s_strP(_arg0) {
	var key = _arg0;
	var txt = ds_map_find_value(obj_master.stringmap, key);
	if (!is_undefined(txt)) {
		txt = string_hash_to_newline(txt);
		if (string_count("$", txt) > 0) {
			txt = s_parse_string(txt);
		}
	} else {
		txt = "!";
	}
	return txt;
}

