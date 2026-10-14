function btn_click_Boost_Salary_Cap() {
	if (s_is_co_mode()) {
		recruitment_credits_button_click_boost();
		return;
	}
	if (100 > obj_master.coach_credit) {
		var msg = s_str("msg_BoostSalaryNoCredit");
		msg = string_replace(msg, "$num", string(obj_master.salary_cap + obj_master.boost_salary_cap + 25));
		msg = string_replace(msg, "$cost", string(100));
		s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
	} else {
		var msg = s_str("msg_BoostSalaryCap");
		msg = string_replace(msg, "$num", string(obj_master.salary_cap + obj_master.boost_salary_cap + 25));
		msg = string_replace(msg, "$cost", string(100));
		s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_boost_salary_cap, global.c_background, 1);
	}
}

