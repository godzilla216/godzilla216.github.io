function s_get_team_from_tag(_arg0, _arg1, _arg2, _arg3) {
	if (_arg1 == undefined) {
		_arg1 = obj_master.schedule;
	}
	if (_arg2 == undefined) {
		_arg2 = 1;
	}
	if (_arg3 == undefined) {
		_arg3 = -4;
	}
	var src = s_get_tagged_source(_arg0);
	if (src == -4) {
		return -4;
	}
	switch (src.tag) {
		case "tm":
			switch (src.source) {
				case "teams":
					if (_arg2 > 1) {
						return -4;
					}
					return src.key;
				case "pool":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_pool_position(src.key, _arg3);
				case "c_win":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_winner_by_cid(src.key, _arg1);
				case "m_win":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_winner_by_mid(src.key, _arg1);
				case "cnf_win":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_co_conference_winner(src.key);
				case "div_win":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_co_division_winner(src.key);
				case "best_1":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_co_conference_best(src.key, 0);
				case "best_2":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_co_conference_best(src.key, 1);
				case "maj_rank":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_co_subdivision_best(1, src.key);
				case "min_rank":
					if (_arg2 > 1) {
						return -4;
					}
					return s_get_co_subdivision_best(2, src.key);
				case "pbowl":
					if (_arg2 > 2) {
						return -4;
					}
					return s_get_co_prestige_bowl_seed(1, src.key, _arg2);
				case "bowl":
					return s_get_co_bowl_seed(1, src.key, _arg2);
			}
		case "c":
			break;
		case "m":
			break;
	}
	return -4;
}

function s_get_winner_by_cid(_arg0, _arg1) {
	var fix = s_get_fix_by_competition_id(_arg0, _arg1);
	if (fix && s_is_fix_filled(fix)) {
		slogf("found %1 vs %2 (%3:%4)", ds_map_find_value(fix, "home_team"), ds_map_find_value(fix, "away_team"), ds_map_find_value(fix, "home_score"), ds_map_find_value(fix, "away_score"));
		return s_get_fix_winner_id(fix);
	}
	return -1;
}

function s_get_winner_by_mid(_arg0, _arg1) {
	var fix = s_get_fix_by_match_id(_arg0, _arg1);
	if (fix && s_is_fix_filled(fix)) {
		slogf("found %1 vs %2 (%3:%4)", ds_map_find_value(fix, "home_team"), ds_map_find_value(fix, "away_team"), ds_map_find_value(fix, "home_score"), ds_map_find_value(fix, "away_score"));
		return s_get_fix_winner_id(fix);
	}
	return -1;
}

function s_get_co_conference_winner(_arg0) {
	return s_get_co_division_winner(_arg0 + ".0");
}

function s_get_co_division_winner(_arg0) {
	var c = string_split(_arg0, ".");
	if (array_length(c) < 2) {
		return -1;
	}
	if (!s_is_co_postseason()) {
		return -1;
	}
	var comp = s_get_competition_by_conference_division(c[0], c[1]);
	s_competition_update_standings(comp.conference, comp.division);
	if (is_undefined(comp.standings) || !is_array(comp.standings)) {
		return -1;
	}
	return comp.standings[0].uid;
}

function s_get_co_conference_best(_arg0, _arg1) {
	if (!s_is_co_postseason()) {
		return -1;
	}
	var conf = s_get_conference_data(_arg0);
	s_conference_update_standings(conf);
	if (_arg1 >= array_length(conf.standings)) {
		return -1;
	}
	return conf.standings[_arg1].uid;
}

function s_get_co_subdivision_best(_arg0, _arg1) {
	if (!s_is_co_actual_postseason()) {
		return -1;
	}
	s_subdivision_update_rankings(_arg0);
	var td = obj_master.subdiv_data[_arg0].rankings[_arg1 - 1];
	td.seeded = true;
	return td.uid;
}

function s_get_co_bowl_seed(_arg0, _arg1, _arg2) {
	if (!s_is_co_actual_postseason()) {
		return -1;
	}
	s_subdivision_update_rankings(_arg0);
	var tid;
	switch (_arg2) {
		case 1:
			return -1;
		case 2:
			tid = s_get_bowl_seed_first_loop_pool(_arg0, _arg1);
			break;
		case 3:
			tid = s_get_bowl_seed_second_loop_pool(_arg0);
			break;
		case 4:
			tid = s_get_bowl_seed_third_loop_pool(_arg0);
			break;
	}
	if (tid != -4 && tid > -1) {
		return tid;
	}
	return -1;
}

function s_get_co_prestige_bowl_seed(_arg0, _arg1, _arg2) {
	if (s_is_earlier_than(16)) {
		return -1;
	}
	s_subdivision_update_rankings(_arg0);
	s_create_prestige_pool();
	var pbp = s_get_prestige_pool();
	return s_get_team_in_prestige_pool(_arg1, _arg2);
}

function s_create_prestige_pool() {
	var pbp = s_get_prestige_pool();
	if (array_length(pbp) > 0) {
		return;
	}
	var confs = [];
	var comps = obj_master.competitions;
	var tag, fix, at, ht, wt;
	slogf("\n*** CREATE PRESTIGE POOL");
	for (var i = 0; i < array_length(comps); i++) {
		tag = string_split(comps[i].pool_cfg, ":");
		if (array_length(tag) > 2 && tag[0] == "pbp" && tag[1] == "inc" && tag[2] == "w") {
			fix = s_get_fix_by_competition_id(comps[i].uid);
			if (s_is_fix_played(fix)) {
				wt = s_get_fix_winner_id(fix);
				array_push(confs, tag[3]);
				s_prestige_pool_add(wt, 1, true);
				slogf("Adding conf champ winner: %1 ", wt);
			}
		}
	}
	confs = array_unique(confs);
	for (var i = 0; i < array_length(comps); i++) {
		tag = string_split(comps[i].pool_cfg, ":");
		if (array_length(tag) > 2 && tag[0] == "pbp" && tag[1] == "exc" && tag[2] == "sd") {
			fix = s_get_fix_by_competition_id(comps[i].uid);
			if (fix != -4 && s_is_fix_filled(fix)) {
				at = s_get_fix_away_team_id(fix);
				ht = s_get_fix_home_team_id(fix);
				s_prestige_pool_add(at, 1, false, false);
				s_prestige_pool_add(ht, 1, false, false);
				slogf("Adding and/or unselecting top ranked teams: %1 %2", at, ht);
			}
		}
	}
	var pt, bt = -4;
	for (var i = 0; i < array_length(comps); i++) {
		tag = string_split(comps[i].pool_cfg, ":");
		if (array_length(tag) > 2 && tag[0] == "pbp" && tag[1] == "best" && tag[2] == "w") {
			fix = s_get_fix_by_competition_id(comps[i].uid);
			if (fix != -4 && s_is_fix_played(fix)) {
				wt = s_get_fix_winner_id(fix);
				pt = s_get_struct_in_array_by_uid(pbp, wt);
				if (pt == -4 && (bt == -4 || bt != -4 && s_get_ranking_pos_data(s_get_team_by_id(bt)).pos > s_get_ranking_pos_data(s_get_team_by_id(wt)).pos)) {
					bt = wt;
				}
			}
		}
	}
	if (bt != -4) {
		s_prestige_pool_add(bt, 2, true);
		slogf("Adding additional champ team: %1", bt);
	}
	s_prestige_pool_fill_per_rank(8);
	array_sort(pbp, s_prestige_pool_sort_order_ranking);
	s_prestige_pool_list();
	slogf("Conferences:\n%1", confs);
	slogf("Prestige bowls pool:\n%1", pbp);
}

function s_prestige_pool_sort_order_ranking(_arg0, _arg1) {
	return _arg0.order * 10000 + _arg0.rank - (_arg1.order * 10000 + _arg1.rank);
}

function s_prestige_pool_list() {
	var pbp = s_get_prestige_pool();
	var pt;
	slogf("\n***PRESTIGE POOL LIST");
	for (var i = 0; i < array_length(pbp); i++) {
		pt = pbp[i];
		if (!pt.selectable) {
			continue;
		}
		slogf("%1:\t%2\torder:%3\trank:%4\tcid:%5 w:%6", i, s_get_team_name_by_id(pt.uid), pt.order, pt.rank, pt.conf_uid, pt.conf_win);
	}
}

function s_prestige_pool_add(_arg0, _arg1, _arg2, _arg3) {
	if (_arg3 == undefined) {
		_arg3 = true;
	}
	var pbp = s_get_prestige_pool();
	var team = s_get_struct_in_array_by_uid(pbp, _arg0);
	if (team == -4) {
		var td = s_get_team_by_id(_arg0);
		array_push(pbp, {
			uid: _arg0,
			order: _arg1,
			conf_uid: real(ds_map_find_value(td, "conference")),
			rank: s_get_ranking_pos_data(td).pos,
			conf_win: _arg2,
			selectable: _arg3
		});
		return true;
	} else {
		if (!_arg3) {
			team.selectable = _arg3;
		}
		return false;
	}
}

function s_get_prestige_pool() {
	return obj_master.subdiv_data[1].prestige_pool;
}

function s_get_team_in_prestige_pool(_arg0, _arg1) {
	var pbp = s_get_prestige_pool();
	var pt, rt;
	for (var i = 0; i < array_length(pbp); i++) {
		pt = pbp[i];
		if (pt.selectable && (pt.conf_uid == _arg0 || _arg1 == 2)) {
			pt.selectable = false;
			rt = s_get_struct_in_array_by_uid(obj_master.subdiv_data[1].rankings, pt.uid);
			rt.seeded = true;
			return pt.uid;
		}
	}
	return -1;
}

function s_prestige_pool_force_one_per_conf(_arg0) {
	var pbp = s_get_prestige_pool();
	var count = 0;
	var loser = -4;
	var pt, team_uid;
	for (var i = 0; i < array_length(pbp); i++) {
		pt = pbp[i];
		if (pt.selectable && pt.conf_uid == _arg0) {
			if (pt.conf_win == false) {
				loser = pt;
			}
			count++;
		}
	}
	if (count == 1) {
		slogf("conf %1 exactly one team", _arg0);
		return;
	}
	if (count == 0) {
		var pos = 0;
		while (count == 0) {
			team_uid = s_get_co_conference_best(_arg0, pos++);
			if (team_uid > 0) {
				pt = s_get_struct_in_array_by_uid(pbp, team_uid);
				if (pt == -4) {
					slogf("conf %1 zero teams added %2", _arg0, team_uid);
					s_prestige_pool_add(team_uid, 1, false);
					count++;
				}
			} else {
				break;
			}
		}
	}
}

function s_prestige_pool_fill_per_rank(_arg0) {
	if (_arg0 < 1) {
		return;
	}
	var pbp = s_get_prestige_pool();
	var td;
	with (obj_master.subdiv_data[1]) {
		for (var i = 0; i < array_length(rankings); i++) {
			if (_arg0 < 1) {
				return;
			}
			td = rankings[i];
			pt = s_get_struct_in_array_by_uid(pbp, td.uid);
			if (pt == -4) {
				slogf("fill per rank added %1", td.uid);
				s_prestige_pool_add(td.uid, 3, false);
				_arg0--;
			}
		}
	}
}

function s_get_bowl_seed_first_loop_pool(_arg0, _arg1) {
	var pool = [];
	if (_arg1 < 0) {
		return -4;
	}
	var td;
	with (obj_master.subdiv_data[_arg0]) {
		for (var i = 0; i < array_length(rankings); i++) {
			td = rankings[i];
			if (td.cnf_id == _arg1 && td.wins >= 6 && !td.seeded) {
				array_push(pool, td);
			}
		}
	}
	array_sort(pool, s_co_teams_data_sort_conf_wins_losses);
	return s_get_first_team_data(pool);
}

function s_get_bowl_seed_second_loop_pool(_arg0) {
	var pool = [];
	var td;
	with (obj_master.subdiv_data[_arg0]) {
		for (var i = 0; i < array_length(rankings); i++) {
			td = rankings[i];
			if (!td.seeded && td.wins >= 6) {
				array_push(pool, td);
			}
		}
	}
	array_sort(pool, s_co_teams_data_sort_rank);
	return s_get_first_team_data(pool);
}

function s_get_bowl_seed_third_loop_pool(_arg0) {
	var pool = [];
	var td;
	with (obj_master.subdiv_data[_arg0]) {
		for (var i = 0; i < array_length(rankings); i++) {
			td = rankings[i];
			if (!td.seeded) {
				array_push(pool, td);
			}
		}
		slogf("loop 3 rankings has %1 teams - pool %2 teams", array_length(rankings), array_length(pool));
	}
	array_sort(pool, s_co_teams_data_sort_wins_rank);
	return s_get_first_team_data(pool);
}

function s_get_first_team_data(_arg0) {
	if (array_length(_arg0) > 0) {
		_arg0[0].seeded = true;
		return _arg0[0].uid;
	}
	return -4;
}

function s_get_competition_pool(_arg0) {
	slogf("\n*** Create competition pool\n%1", _arg0);
	var pool = { tier: 1, num: 0, rankings: -4, list: [] };
	var st, v;
	var steps = string_split(_arg0, ";");
	for (var is = 0; is < array_length(steps); is++) {
		st = string_split(steps[is], ":");
		switch (string_trim(st[0])) {
			case "tier":
				pool.tier = real(st[1]);
				s_subdivision_update_rankings(pool.tier);
				pool.rankings = obj_master.subdiv_data[pool.tier].rankings;
				slogf("Source tier %1 - %2 teams", pool.tier, array_length(pool.rankings));
				break;
			case "num":
				pool.num = real(st[1]);
				slogf("Pool wanted size: %1", pool.num);
				break;
			case "tm":
				if (array_length(st) < 3) {
					st[2] = -4;
				}
				slogf("Pool teams: %1 from %2", st[1], st[2]);
				s_competition_pool_team(pool, st[1], st[2]);
				break;
			case "sort":
				slogf("Pool sorting by rank position");
				array_sort(pool.list, s_co_teams_data_sort_rank_pos);
				break;
			case "rnd":
				v = string_split(st[1], "-");
				slogf("Pool randomise: %1 - %2 in 1 - %3", v[0], v[1], array_length(pool.list));
				array_shuffle_ext(pool.list, real(v[0]) - 1, real(v[1]) - real(v[0]) + 1);
				break;
		}
	}
	var td;
	for (var i = 0; i < array_length(pool.list); i++) {
		td = pool.list[i];
		slogf("%1.\t%2 rp:%3", i, td.name, s_get_ranking_pos_data(td.team).pos);
	}
	return pool.list;
}

function s_competition_pool_team(_arg0, _arg1, _arg2) {
	var a, td, t1, t2, tr;
	if (_arg2) {
		a = string_split(_arg2, ",");
	}
	switch (_arg1) {
		case "best_win":
			t1 = s_get_competition_winner(a[0]);
			t2 = s_get_competition_winner(a[1]);
			tr = t1.rank_pts >= t2.rank_pts ? t1 : t2;
			s_competition_pool_add_team(_arg0, tr);
			break;
		case "win":
			for (var i = 0; i < array_length(a); i++) {
				tr = s_get_competition_winner(a[i]);
				s_competition_pool_add_team(_arg0, tr);
			}
			break;
		case "excl_any":
			for (var i = 0; i < array_length(a); i++) {
				s_competition_pool_exclude_teams(_arg0, a[i]);
			}
			break;
		case "rank_fill":
			s_competition_pool_fill_from_rankings(_arg0);
			break;
	}
}

function s_get_competition_winner(_arg0) {
	var comp = s_get_competition(_arg0);
	s_competition_update_standings(comp.conference, comp.division);
	if (is_undefined(comp.standings) || !is_array(comp.standings)) {
		return -4;
	}
	return comp.standings[0];
}

function s_competition_pool_fill_from_rankings(_arg0) {
	var td;
	var count = _arg0.num - array_length(_arg0.list);
	for (var i = 0; i < array_length(_arg0.rankings); i++) {
		if (count <= 0) {
			return;
		}
		td = _arg0.rankings[i];
		if (!td.seeded) {
			s_competition_pool_add_team(_arg0, td);
			count--;
		}
	}
}

function s_competition_pool_exclude_teams(_arg0, _arg1) {
	_arg1 = real(_arg1);
	var td, comp;
	for (var i = 0; i < array_length(_arg0.rankings); i++) {
		td = _arg0.rankings[i];
		if (td.seeded) {
			continue;
		}
		comp = s_get_competition_by_conference_division(ds_map_find_value(td.team, "conference"), ds_map_find_value(td.team, "division"));
		if (comp.uid == _arg1) {
			slogf("exclude: %1 in %2:%3", td.name, td.cnf_id, td.div_id);
			td.seeded = true;
		}
	}
}

function s_competition_pool_add_team(_arg0, _arg1) {
	s_competition_pool_rankings_exclude(_arg0.rankings, _arg1.uid);
	array_push(_arg0.list, _arg1);
	slogf(_arg1.name);
}

function s_competition_pool_rankings_exclude(_arg0, _arg1) {
	for (var i = 0; i < array_length(_arg0); i++) {
		if (_arg0[i].uid == _arg1) {
			_arg0[i].seeded = true;
		}
	}
}

function s_get_tagged_source(_arg0) {
	if (_arg0 == -4 || _arg0 == "") {
		return -4;
	}
	var ts = string_split(_arg0, ":");
	return { tag: ts[0], source: ts[1], key: array_length(ts) > 2 ? ts[2] : -4 };
}

function s_get_pool_position(_arg0, _arg1) {
	if (obj_master.week < obj_master.first_week_postseason) {
		return -1;
	}
	var comp = s_get_competition(ds_map_find_value(_arg1, "cid"));
	if (!is_array(comp.pool)) {
		comp.pool = s_get_competition_pool(comp.pool_cfg);
	}
	slogf("get pool position %1", _arg0);
	_arg0 = real(_arg0) - 1;
	if (is_array(comp.pool) && _arg0 < array_length(comp.pool)) {
		return comp.pool[_arg0].uid;
	}
	return -1;
}

function s_competitions_debug_printout() {
	var fix, cid, at, ht;
	slogf("\n*** BOWLS");
	for (var f = 0; f < ds_list_size(obj_master.schedule); f++) {
		fix = ds_list_find_value(obj_master.schedule, f);
		cid = ds_map_find_value(fix, "cid");
		at = ds_map_find_value(fix, "away_team");
		ht = ds_map_find_value(fix, "home_team");
		if (!is_undefined(cid) && cid != -4 && cid < 6000 && cid != 4000) {
			slogf("cid: %1 at: %2 ht: %3", cid, at, ht);
		}
	}
}

