function s_get_salary_cap_space() {
	with (obj_master) {
		return salary_cap + boost_salary_cap - s_get_salary_total();
	}
}

