function s_get_meeting_cost_delay_retirement(_arg0) {
	var pmap = _arg0;
	var years_over = ds_map_find_value(pmap, "age") - s_get_max_age(pmap);
	return 25 + years_over * years_over * 25;
}

