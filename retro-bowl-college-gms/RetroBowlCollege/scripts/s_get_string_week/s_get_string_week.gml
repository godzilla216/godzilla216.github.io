function s_get_string_week(_arg0) {
	var wk = _arg0;
	if (wk == 0) {
		wk = obj_master.week;
	}
	if (wk < obj_master.first_week_playoffs) {
		return s_str("ui_Week") + " " + string(wk);
	}
	if (!s_is_co_mode()) {
		if (s_playoffs_12()) {
			if (wk == obj_master.first_week_playoffs) {
				return s_get_string_conference(0) + " " + s_str("ui_WildCard") + " 1";
			} else if (wk == obj_master.first_week_playoffs + 1) {
				return s_get_string_conference(0) + " " + s_str("ui_WildCard") + " 2";
			} else if (wk == obj_master.first_week_playoffs + 2) {
				return s_get_string_conference(1) + " " + s_str("ui_WildCard") + " 1";
			} else if (wk == obj_master.first_week_playoffs + 3) {
				return s_get_string_conference(1) + " " + s_str("ui_WildCard") + " 2";
			} else if (wk == obj_master.first_week_playoffs + 4) {
				return s_get_string_conference(0) + " " + s_str("ui_PlayOff") + " 1";
			} else if (wk == obj_master.first_week_playoffs + 5) {
				return s_get_string_conference(0) + " " + s_str("ui_PlayOff") + " 2";
			} else if (wk == obj_master.first_week_playoffs + 6) {
				return s_get_string_conference(1) + " " + s_str("ui_PlayOff") + " 1";
			} else if (wk == obj_master.first_week_playoffs + 7) {
				return s_get_string_conference(1) + " " + s_str("ui_PlayOff") + " 2";
			} else if (wk == obj_master.first_week_playoffs + 8) {
				return s_get_string_conference(0) + " " + s_str("ui_Champion");
			} else if (wk == obj_master.first_week_playoffs + 9) {
				return s_get_string_conference(1) + " " + s_str("ui_Champion");
			} else if (wk == obj_master.first_week_playoffs + 10) {
				return s_str("ui_SuperBowl");
			}
		} else if (wk == obj_master.first_week_playoffs) {
			return s_get_string_conference(0) + " " + s_str("ui_WildCard") + " 1";
		} else if (wk == obj_master.first_week_playoffs + 1) {
			return s_get_string_conference(0) + " " + s_str("ui_WildCard") + " 2";
		} else if (wk == obj_master.first_week_playoffs + 2) {
			return s_get_string_conference(0) + " " + s_str("ui_WildCard") + " 3";
		} else if (wk == obj_master.first_week_playoffs + 3) {
			return s_get_string_conference(1) + " " + s_str("ui_WildCard") + " 1";
		} else if (wk == obj_master.first_week_playoffs + 4) {
			return s_get_string_conference(1) + " " + s_str("ui_WildCard") + " 2";
		} else if (wk == obj_master.first_week_playoffs + 5) {
			return s_get_string_conference(1) + " " + s_str("ui_WildCard") + " 3";
		} else if (wk == obj_master.first_week_playoffs + 6) {
			return s_get_string_conference(0) + " " + s_str("ui_PlayOff") + " 1";
		} else if (wk == obj_master.first_week_playoffs + 7) {
			return s_get_string_conference(0) + " " + s_str("ui_PlayOff") + " 2";
		} else if (wk == obj_master.first_week_playoffs + 8) {
			return s_get_string_conference(1) + " " + s_str("ui_PlayOff") + " 1";
		} else if (wk == obj_master.first_week_playoffs + 9) {
			return s_get_string_conference(1) + " " + s_str("ui_PlayOff") + " 2";
		} else if (wk == obj_master.first_week_playoffs + 10) {
			return s_get_string_conference(0) + " " + s_str("ui_Champion");
		} else if (wk == obj_master.first_week_playoffs + 11) {
			return s_get_string_conference(1) + " " + s_str("ui_Champion");
		} else if (wk == obj_master.first_week_playoffs + 12) {
			return s_str("ui_SuperBowl");
		}
	}
	return s_str("ui_Week") + " " + string(wk);
}

