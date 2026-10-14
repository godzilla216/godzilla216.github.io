function recruitment_credits_cap_total() {
	return obj_master.recruitment_credits_cap + obj_master.boost_recruitment_credits_cap;
}

function can_fit_recruitment_credits(_arg0) {
	var max_rc = recruitment_credits_cap_total();
	var new_total = obj_master.recruitment_credits + _arg0;
	if (new_total <= max_rc) {
		return true;
	} else {
		return false;
	}
}

function recruitment_credits_space() {
	return recruitment_credits_cap_total() - obj_master.recruitment_credits;
}

function recruitment_credits_add(_arg0) {
	var max_rc = recruitment_credits_cap_total();
	var old = obj_master.recruitment_credits;
	obj_master.recruitment_credits += _arg0;
	if (obj_master.recruitment_credits > max_rc) {
		obj_master.recruitment_credits = max_rc;
	}
	if (obj_master.recruitment_credits < 0) {
		obj_master.recruitment_credits = 0;
	}
	var dif = obj_master.recruitment_credits - old;
	if (dif > 0) {
		obj_master.rc_season_earned += dif;
		obj_master.rc_lifetime_earned += dif;
	} else if (dif < 0) {
		obj_master.rc_season_spent += dif;
		obj_master.rc_lifetime_spent += dif;
	}
}

function recruitment_credits_toggle_roster_size() {
	switch (obj_master.recruitment_credits_cap) {
		case 50:
			obj_master.recruitment_credits_cap = 60;
			break;
		case 60:
			if (ds_list_size(obj_master.roster) > 10) {
				s_create_message("", s_str("msg_SalaryCheckRoster"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			} else if (obj_master.recruitment_credits > 50 + obj_master.boost_recruitment_credits_cap) {
				var maxRC = 50 + obj_master.boost_recruitment_credits_cap;
				var msg = s_str("msg_SalaryCheckAmount");
				msg = string_replace(msg, "$num", string(maxRC));
				s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			} else {
				obj_master.recruitment_credits_cap = 50;
			}
			break;
	}
}

function recruitment_credits_button_click_boost() {
	if (100 > obj_master.coach_credit) {
		var msg = s_str("msg_BoostSalaryNoCredit");
		msg = string_replace(msg, "$num", string(recruitment_credits_cap_total() + 30));
		msg = string_replace(msg, "$cost", string(100));
		s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else {
		var msg = s_str("msg_BoostSalaryCap");
		msg = string_replace(msg, "$num", string(recruitment_credits_cap_total() + 30));
		msg = string_replace(msg, "$cost", string(100));
		s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_boost_recruitment_credits, global.c_background, 1);
	}
}

function btn_response_boost_recruitment_credits() {
	s_msg_clear();
	with (obj_master) {
		boost_recruitment_credits_cap += 30;
		coach_credit -= 100;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
	}
	room_goto(rm_frontoffice);
}

