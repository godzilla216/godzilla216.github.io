function s_get_meeting_cost_condition(_arg0) {
	var cost = (100 - ds_map_find_value(_arg0, "condition")) / 5;
	return clamp(round(cost), 1, 100);
}

