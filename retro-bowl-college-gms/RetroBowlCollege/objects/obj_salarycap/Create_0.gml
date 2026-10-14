creation_time = current_time;
if (s_is_co_mode()) {
	title = s_str("ui_ScolarshipFund") + " " + string(obj_master.recruitment_credits) + s_str("sla_Thousand") + " / " + string(recruitment_credits_cap_total()) + s_str("sla_Thousand");
	percent = obj_master.recruitment_credits / recruitment_credits_cap_total() * 100;
} else {
	current_salary = s_get_salary_total();
	max_salary = obj_master.salary_cap + obj_master.boost_salary_cap;
	percent = current_salary / max_salary * 100;
	title = s_str("ui_SalaryCap") + " " + string(current_salary) + "m / " + string(max_salary) + "m";
}
if (percent > 100) {
	percent = 100;
} else {
	colour = global.c_primary;
}
