function s_check_for_injury(_arg0) {
	var pmap = _arg0;
	if (obj_master.year == 1) {
		return false;
	}
	if (obj_master.week == 1) {
		return false;
	}
	if (obj_master.week >= s_get_week_superbowl() - 1) {
		return false;
	}
	if (ds_map_find_value(pmap, "condition") <= -1) {
		return false;
	}
	if (s_count_remaining_fixtures() < 2) {
		return false;
	}
	var trainingreg = obj_master.training_reg_df;
	if (s_is_offensive_player(pmap)) {
		trainingreg = obj_master.training_reg_of;
	}
	if (trainingreg == 1 && irandom(9)) {
		return false;
	}
	if (trainingreg == 2 && irandom(4)) {
		return false;
	}
	if (5 + irandom(s_max_age_qb_internal()) > ds_map_find_value(pmap, "age")) {
		return false;
	}
	var size = ds_list_size(obj_master.roster);
	if (size < 2) {
		return false;
	}
	var num_inj = s_count_injuries();
	var inj_weeks = s_count_injuries_weeks();
	if (num_inj > 2) {
		return false;
	}
	if (obj_master.op_difficulty < 3) {
		if (obj_master.facility_rehab > 6 && num_inj > 1) {
			return false;
		}
		if (size < 7 && num_inj > 1) {
			return false;
		}
	}
	var max_weeks = 11 - floor(obj_master.facility_rehab * 0.5);
	if (inj_weeks >= max_weeks) {
		return false;
	}
	max_weeks = clamp(max_weeks - inj_weeks, 1, 5);
	var inj = 0;
	var con = ds_map_find_value(pmap, "condition");
	var fac = obj_master.facility_rehab;
	var chance_exh = 4;
	var chance_tir = 8;
	var chance_ok = 12;
	if (con <= 20) {
		if (!irandom(chance_exh)) {
			inj = irandom_range(1, max_weeks);
		}
	} else if (con <= 40) {
		if (!irandom(chance_tir)) {
			inj = irandom_range(1, max_weeks - 1);
		}
	} else if (!irandom(chance_ok)) {
		inj = 1 + irandom(1);
	}
	if (inj <= 0) {
		return false;
	}
	if (ds_map_find_value(pmap, "age") > 29) {
		inj += 1;
	}
	inj -= irandom(round(fac * 0.4));
	inj = clamp(inj, 1, 10);
	if (ds_map_find_value(pmap, "position") == 1 && obj_master.year < 3) {
		inj = min(inj, 2);
	}
	var msg = s_str("news_PlayerInjured");
	if (inj == 1) {
		msg = s_str("news_PlayerInjured1");
	}
	msg = s_parse_player_message(msg, pmap);
	msg = string_replace(msg, "$num", inj);
	s_add_news(msg);
	ds_map_set(pmap, "injury_week", obj_master.week);
	ds_map_set(pmap, "condition", -inj);
	return true;
}

