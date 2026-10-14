function s_get_meeting_cost_extend_contract(_arg0) {
	var pmap = _arg0;
	if (s_is_co_mode()) {
		return s_get_meeting_cost_academic_coaching(pmap);
	}
	var cost = round(s_get_player_rating(pmap) + ds_map_find_value(pmap, "salary") * 0.5);
	cost += 5 * ds_map_find_value(pmap, "contract");
	return cost;
}

