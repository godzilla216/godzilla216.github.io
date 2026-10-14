function s_get_string_week_short(_arg0) {
	if (_arg0 == 0) {
		_arg0 = obj_master.week;
	}
	if (_arg0 < obj_master.first_week_playoffs) {
		return s_str("tla_Week") + " " + string(_arg0);
	}
	if (s_playoffs_12()) {
		if (_arg0 == obj_master.first_week_playoffs) {
			return s_get_string_conference(0) + " " + s_str("tla_WildCard") + " 1";
		} else if (_arg0 == obj_master.first_week_playoffs + 1) {
			return s_get_string_conference(0) + " " + s_str("tla_WildCard") + " 2";
		} else if (_arg0 == obj_master.first_week_playoffs + 2) {
			return s_get_string_conference(1) + " " + s_str("tla_WildCard") + " 1";
		} else if (_arg0 == obj_master.first_week_playoffs + 3) {
			return s_get_string_conference(1) + " " + s_str("tla_WildCard") + " 2";
		} else if (_arg0 == obj_master.first_week_playoffs + 4) {
			return s_get_string_conference(0) + " " + s_str("tla_PlayOff") + " 1";
		} else if (_arg0 == obj_master.first_week_playoffs + 5) {
			return s_get_string_conference(0) + " " + s_str("tla_PlayOff") + " 2";
		} else if (_arg0 == obj_master.first_week_playoffs + 6) {
			return s_get_string_conference(1) + " " + s_str("tla_PlayOff") + " 1";
		} else if (_arg0 == obj_master.first_week_playoffs + 7) {
			return s_get_string_conference(1) + " " + s_str("tla_PlayOff") + " 2";
		} else if (_arg0 == obj_master.first_week_playoffs + 8) {
			return s_get_string_conference(0) + " " + s_str("tla_Champion");
		} else if (_arg0 == obj_master.first_week_playoffs + 9) {
			return s_get_string_conference(1) + " " + s_str("tla_Champion");
		} else if (_arg0 == obj_master.first_week_playoffs + 10) {
			return s_str("tla_SuperBowl");
		}
	} else if (_arg0 == obj_master.first_week_playoffs) {
		return s_get_string_conference(0) + " " + s_str("tla_WildCard") + " 1";
	} else if (_arg0 == obj_master.first_week_playoffs + 1) {
		return s_get_string_conference(0) + " " + s_str("tla_WildCard") + " 2";
	} else if (_arg0 == obj_master.first_week_playoffs + 2) {
		return s_get_string_conference(0) + " " + s_str("tla_WildCard") + " 3";
	} else if (_arg0 == obj_master.first_week_playoffs + 3) {
		return s_get_string_conference(1) + " " + s_str("tla_WildCard") + " 1";
	} else if (_arg0 == obj_master.first_week_playoffs + 4) {
		return s_get_string_conference(1) + " " + s_str("tla_WildCard") + " 2";
	} else if (_arg0 == obj_master.first_week_playoffs + 4) {
		return s_get_string_conference(1) + " " + s_str("tla_WildCard") + " 3";
	} else if (_arg0 == obj_master.first_week_playoffs + 6) {
		return s_get_string_conference(0) + " " + s_str("tla_PlayOff") + " 1";
	} else if (_arg0 == obj_master.first_week_playoffs + 7) {
		return s_get_string_conference(0) + " " + s_str("tla_PlayOff") + " 2";
	} else if (_arg0 == obj_master.first_week_playoffs + 8) {
		return s_get_string_conference(1) + " " + s_str("tla_PlayOff") + " 1";
	} else if (_arg0 == obj_master.first_week_playoffs + 9) {
		return s_get_string_conference(1) + " " + s_str("tla_PlayOff") + " 2";
	} else if (_arg0 == obj_master.first_week_playoffs + 10) {
		return s_get_string_conference(0) + " " + s_str("tla_Champion");
	} else if (_arg0 == obj_master.first_week_playoffs + 11) {
		return s_get_string_conference(1) + " " + s_str("tla_Champion");
	} else if (_arg0 == obj_master.first_week_playoffs + 12) {
		return s_str("tla_SuperBowl");
	}
	return s_str("tla_Week") + " " + string(_arg0);
}

