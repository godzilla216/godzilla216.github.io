function s_sim_stat_increment(_arg0, _arg1, _arg2) {
	if (_arg0 && !s_player_benched(_arg0) && !ds_map_find_value(_arg0, "backup") && ds_map_find_value(_arg0, "condition") >= 0) {
		ds_map_set(_arg0, _arg1, ds_map_find_value(_arg0, _arg1) + _arg2);
	}
}

function s_sim_stat_update(_arg0, _arg1, _arg2) {
	if (_arg0 && !s_player_benched(_arg0) && !ds_map_find_value(_arg0, "backup") && ds_map_find_value(_arg0, "condition") >= 0) {
		ds_map_set(_arg0, _arg1, _arg2);
	}
}

function s_sim_stat_touchdown(_arg0, _arg1) {
	if (_arg0 == 1) {
		slog("s_sim_stat_touchdown RUN: " + string(_arg1));
	} else {
		slog("s_sim_stat_touchdown PASS: " + string(_arg1));
	}
	_arg1 = clamp(_arg1, 1, 100);
	var pmap = s_get_random_player_by_position(false, 4);
	if (_arg0 == 1) {
		pmap = s_get_random_player_by_position(false, 2);
	} else {
		if (_arg1 < 30) {
			if (!irandom(3)) {
				pmap = s_get_random_player_by_position(false, 3);
			} else if (!random(4)) {
				pmap = s_get_random_player_by_position(false, 2);
			}
		}
		if (!pmap) {
			pmap = s_get_random_player_by_position(false, 4);
		}
	}
	if (pmap) {
		if (_arg0 == 1) {
			ds_map_set(pmap, "stat_rush_attempts", ds_map_find_value(pmap, "stat_rush_attempts") + irandom_range(1, 2));
			ds_map_set(pmap, "stat_rush_touchdowns", ds_map_find_value(pmap, "stat_rush_touchdowns") + 1);
			ds_map_set(pmap, "stat_rush_yards", ds_map_find_value(pmap, "stat_rush_yards") + _arg1);
		} else {
			ds_map_set(pmap, "stat_attempts", ds_map_find_value(pmap, "stat_attempts") + irandom_range(1, 2));
			ds_map_set(pmap, "stat_touchdowns", ds_map_find_value(pmap, "stat_touchdowns") + 1);
			ds_map_set(pmap, "stat_yards", ds_map_find_value(pmap, "stat_yards") + _arg1);
		}
		if (_arg1 > ds_map_find_value(pmap, "stat_longest")) {
			s_sim_stat_update(pmap, "stat_longest", _arg1);
		}
	}
	if (!obj_master.qb_mode) {
		var qb = s_get_qb_pmap();
		if (qb && !s_player_benched(qb) && !ds_map_find_value(qb, "backup") && ds_map_find_value(qb, "condition") >= 0) {
			ds_map_set(qb, "stat_attempts", ds_map_find_value(qb, "stat_attempts") + 1);
			ds_map_set(qb, "stat_complete", ds_map_find_value(qb, "stat_complete") + 1);
			ds_map_set(qb, "stat_touchdowns", ds_map_find_value(qb, "stat_touchdowns") + 1);
			ds_map_set(qb, "stat_yards", ds_map_find_value(qb, "stat_yards") + _arg1);
			ds_map_set(qb, "stat_attempts", ds_map_find_value(qb, "stat_attempts") + irandom_range(1, 2));
			ds_map_set(qb, "stat_complete", min(ds_map_find_value(qb, "stat_complete") + irandom_range(0, 2), ds_map_find_value(qb, "stat_attempts")));
			if (_arg1 > ds_map_find_value(qb, "stat_longest")) {
				s_sim_stat_update(qb, "stat_longest", _arg1);
			}
		}
	}
	pmap = s_get_random_player_by_position(false, 5);
	if (pmap && irandom(1)) {
		ds_map_set(pmap, "stat_tackles", ds_map_find_value(pmap, "stat_tackles") + 1);
	}
}

function s_sim_stat_pass(_arg0) {
	slog("s_sim_stat_pass: " + string(_arg0));
	_arg0 = round(_arg0 * random_range(0.7, 1));
	var pmap = s_get_random_player_by_position(false, 4);
	if (_arg0 < 35) {
		var te = s_get_random_player_by_position(false, 3);
		if (te && ds_map_find_value(te, "stat_yards") == 0 && !irandom(3)) {
			pmap = te;
		} else if (!irandom(3)) {
			pmap = s_get_random_player_by_position(false, 3);
		} else if (!random(3)) {
			pmap = s_get_random_player_by_position(false, 2);
		}
		if (!pmap) {
			pmap = s_get_random_player_by_position(false, 4);
		}
	}
	if (pmap) {
		var rat = s_get_player_rating(pmap);
		if (ds_map_find_value(pmap, "position") == 4) {
			_arg0 += irandom(rat * 2);
		}
		_arg0 = clamp(_arg0, 1, 100);
		ds_map_set(pmap, "stat_attempts", ds_map_find_value(pmap, "stat_attempts") + irandom_range(1, 2));
		ds_map_set(pmap, "stat_yards", ds_map_find_value(pmap, "stat_yards") + _arg0);
		if (_arg0 > ds_map_find_value(pmap, "stat_longest")) {
			s_sim_stat_update(pmap, "stat_longest", _arg0);
		}
	}
	if (!obj_master.qb_mode) {
		var qb = s_get_qb_pmap();
		if (qb && !s_player_benched(qb) && !ds_map_find_value(qb, "backup") && ds_map_find_value(qb, "condition") >= 0) {
			_arg0 = clamp(_arg0, 1, 100);
			ds_map_set(qb, "stat_attempts", ds_map_find_value(qb, "stat_attempts") + 1);
			ds_map_set(qb, "stat_complete", ds_map_find_value(qb, "stat_complete") + 1);
			ds_map_set(qb, "stat_yards", ds_map_find_value(qb, "stat_yards") + _arg0);
			ds_map_set(qb, "stat_attempts", ds_map_find_value(qb, "stat_attempts") + irandom_range(1, 2));
			ds_map_set(qb, "stat_complete", min(ds_map_find_value(qb, "stat_complete") + irandom_range(0, 2), ds_map_find_value(qb, "stat_attempts")));
			if (_arg0 > ds_map_find_value(qb, "stat_longest")) {
				s_sim_stat_update(qb, "stat_longest", _arg0);
			}
		}
	}
	pmap = s_get_random_player_by_position(false, 5);
	if (pmap && irandom(1)) {
		ds_map_set(pmap, "stat_tackles", ds_map_find_value(pmap, "stat_tackles") + 1);
	}
}

function s_sim_stat_run(_arg0) {
	slog("s_sim_stat_run: " + string(_arg0));
	var pmap = s_get_random_player_by_position(false, 2);
	if (pmap) {
		var rat = s_get_player_rating(pmap);
		_arg0 = round(_arg0 * random_range(0.6, 0.7 + rat * 0.03));
		_arg0 = clamp(_arg0, 1, 100);
		ds_map_set(pmap, "stat_rush_attempts", ds_map_find_value(pmap, "stat_rush_attempts") + irandom_range(2, 3));
		ds_map_set(pmap, "stat_rush_yards", ds_map_find_value(pmap, "stat_rush_yards") + _arg0);
		if (_arg0 > ds_map_find_value(pmap, "stat_rush_longest")) {
			s_sim_stat_update(pmap, "stat_rush_longest", _arg0);
		}
	}
}

function s_sim_stat_fumble() {
	var pmap = -4;
	switch (irandom(4)) {
		case 0:
		case 1:
			pmap = s_get_random_player_by_position(false, 4);
			break;
		case 2:
			pmap = s_get_random_player_by_position(false, 2);
			break;
		case 3:
			pmap = s_get_random_player_by_position(false, 3);
			break;
	}
	if (pmap) {
		if (ds_map_find_value(pmap, "position") == 2) {
			ds_map_set(pmap, "stat_rush_attempts", ds_map_find_value(pmap, "stat_rush_attempts") + 1);
		} else {
			ds_map_set(pmap, "stat_attempts", ds_map_find_value(pmap, "stat_attempts") + 1);
		}
		ds_map_set(pmap, "stat_fumbles", ds_map_find_value(pmap, "stat_fumbles") + 1);
	}
}

function s_sim_stat_interception() {
	var qb = s_get_qb_pmap();
	if (qb && !s_player_benched(qb) && !ds_map_find_value(qb, "backup") && ds_map_find_value(qb, "condition") >= 0) {
		ds_map_set(qb, "stat_attempts", ds_map_find_value(qb, "stat_attempts") + 1);
		ds_map_set(qb, "stat_int", ds_map_find_value(qb, "stat_int") + 1);
	}
}

function s_sim_stat_sack() {
	var qb = s_get_qb_pmap();
	if (qb && !s_player_benched(qb) && !ds_map_find_value(qb, "backup") && ds_map_find_value(qb, "condition") >= 0) {
		ds_map_set(qb, "stat_attempts", ds_map_find_value(qb, "stat_attempts") + 1);
		ds_map_set(qb, "stat_sacks", ds_map_find_value(qb, "stat_sacks") + 1);
	}
}

