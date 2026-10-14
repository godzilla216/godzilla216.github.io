function btn_click_OptionsSalaryCap() {
	if (ds_map_find_value(obj_master.map_options, "fullversion") == 1) {
		if (s_is_co_mode()) {
			recruitment_credits_toggle_roster_size();
		} else {
			salary_cap_toggle_roster_size();
		}
		s_update_options();
	} else {
		s_create_message("", s_str("msg_NeedUnlimited"), s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
	}
}

function salary_cap_toggle_roster_size() {
	switch (obj_master.salary_cap) {
		case 150:
			obj_master.salary_cap = 200;
			break;
		case 200:
			if (ds_list_size(obj_master.roster) > 10) {
				s_create_message("", s_str("msg_SalaryCheckRoster"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			} else {
				obj_master.salary_cap = 150;
			}
			break;
	}
}

function s_get_roster_cap() {
	if (s_is_co_mode()) {
		switch (obj_master.recruitment_credits_cap) {
			case 50:
				return 10;
			case 60:
				return 12;
		}
	} else {
		switch (obj_master.salary_cap) {
			case 150:
				return 10;
			case 200:
				return 12;
		}
	}
	return 10;
}

