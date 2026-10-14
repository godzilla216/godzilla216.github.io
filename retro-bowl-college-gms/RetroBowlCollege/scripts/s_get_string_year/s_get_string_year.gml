function s_get_string_year(_arg0) {
	var short = _arg0;
	switch (short) {
		case false:
			return s_str("ui_Year") + " " + string(obj_master.year);
			break;
		case true:
			return s_str("sla_Year") + string(obj_master.year);
			break;
	}
}

