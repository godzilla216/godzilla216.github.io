function btn_response_boost_salary_cap() {
	s_msg_clear();
	with (obj_master) {
		boost_salary_cap += 25;
		coach_credit -= 100;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
	}
	room_goto(rm_frontoffice);
}

