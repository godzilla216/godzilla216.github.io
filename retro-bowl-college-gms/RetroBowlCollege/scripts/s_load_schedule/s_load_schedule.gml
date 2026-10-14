function s_load_schedule() {
	if (s_is_co_mode()) {
		return s_load_college_schedule();
	}
	var list = ds_list_create();
	var filename = "Schedule17.txt";
	var file = file_text_open_read(filename);
	var keys = s_split_string(file_text_read_string(file));
	file_text_readln(file);
	while (!file_text_eof(file)) {
		var map = ds_map_create();
		var values = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		for (var i = 0; i < array_length_1d(keys); i++) {
			ds_map_add(map, keys[i], real(values[i]));
		}
		if (real(ds_map_find_value(map, "year")) - 1 == (obj_master.year + obj_master.year_stagger) mod 12) {
			ds_list_add(list, map);
		} else {
			ds_map_destroy(map);
			map = -1;
		}
	}
	file_text_close(file);
	return list;
}

function s_load_college_schedule() {
	var list = ds_list_create();
	var filename = s_get_versioned_path("Schedule_CO.txt");
	if (!variable_instance_exists(obj_master, "competitions")) {
		return list;
	}
	var data = load_data_to_struct_array(filename);
	var data_years = s_get_schedule_data_years(data);
	var selected_year = (global.g_m.year + global.g_m.year_stagger - 1) mod data_years + 1;
	var si;
	slogf("*** LOAD COLLEGE SCHEDULE - YEAR %1\nyears available: %2 year stagger: %3 selected year: %4", global.g_m.year, data_years, global.g_m.year_stagger, selected_year);
	for (var i = 0; i < array_length(data); i++) {
		si = data[i];
		if (si.year == selected_year) {
			var map = ds_map_create();
			ds_map_set(map, "year", real(si.year));
			ds_map_set(map, "week", real(si.week));
			ds_map_set(map, "away_team", real(si.away_team));
			ds_map_set(map, "home_team", real(si.home_team));
			ds_map_set(map, "away_score", real(si.away_score));
			ds_map_set(map, "home_score", real(si.home_score));
			ds_map_set(map, "cid", s_get_competition_id_from_fix(map));
			ds_list_add(list, map);
		}
	}
	s_reset_competitions_and_subdivisions_pools_and_rankings();
	var comp;
	for (var i = 0; i < array_length(obj_master.competitions); i++) {
		comp = obj_master.competitions[i];
		s_competition_reset_standings(comp);
		if (real(comp.active)) {
			slogf("*** generate schedule for competition %1", comp.name);
			s_schedule_generation(comp, list, obj_master.year);
		} else {
			slogf("*** ignoring deactivated competition %1", comp.name);
		}
	}
	return list;
}

function s_get_schedule_data_years(_arg0) {
	var max_year = 1;
	for (var i = 0; i < array_length(_arg0); i++) {
		max_year = max(real(_arg0[i].year), max_year);
	}
	return max_year;
}

function s_get_schedule_year_stagger() {
	if (!s_is_co_mode()) {
		return irandom(12);
	}
	switch (global.g_m.data_version) {
		case 1:
			return 0;
		default:
			return 5;
	}
}

function s_get_fix_type(_arg0) {
	var type = s_get_map_real(_arg0, "type", 0);
	if (type == 0) {
		type = s_calc_fix_type(_arg0).type;
		if (type != 0) {
			ds_map_set(_arg0, "type", type);
		}
	}
	return type;
}

function s_calc_fix_type(_arg0, _arg1, _arg2, _arg3) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	if (_arg1 == undefined) {
		_arg1 = -4;
	}
	if (_arg2 == undefined) {
		_arg2 = -4;
	}
	if (_arg3 == undefined) {
		_arg3 = obj_master.week;
	}
	var ft = { type: 0, ac: -4, hc: -4 };
	if (_arg0 != -4) {
		_arg1 = s_get_team_by_id(ds_map_find_value(_arg0, "away_team"));
		_arg2 = s_get_team_by_id(ds_map_find_value(_arg0, "home_team"));
		_arg3 = s_get_map_real(_arg0, "week", 0);
	}
	if (_arg0 != -4 && !s_is_fix_filled(_arg0) || _arg3 > obj_master.last_week_regular) {
		return ft;
	}
	ft.ac = s_get_conference_data(s_get_map_real(_arg1, "conference", 0));
	ft.hc = s_get_conference_data(s_get_map_real(_arg2, "conference", 0));
	if (ft.ac.tier != ft.hc.tier) {
		ft.type = 3;
		return ft;
	}
	if (ft.ac.uid != ft.hc.uid) {
		ft.type = 2;
		return ft;
	}
	ft.type = 1;
	return ft;
}

function s_get_fix_type_string(_arg0) {
	var ft = s_calc_fix_type(_arg0);
	return s_create_fix_type_string(ft);
}

function s_get_fix_type_string_by_values(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = obj_master.week;
	}
	var ft = s_calc_fix_type(-4, _arg0, _arg1, _arg2);
	return s_create_fix_type_string(ft);
}

function s_create_fix_type_string(_arg0) {
	switch (_arg0.type) {
		case 1:
			return s_str_u("ui_ConferenceGame");
		case 2:
			return s_str_u("ui_NonConferenceGame");
		case 3:
			return s_strfl("%1 v %2", string_upper(s_get_subdiv_name(_arg0.ac.tier)), string_upper(s_get_subdiv_name(_arg0.hc.tier)));
	}
	return "";
}

function s_list_schedule_fix_type() {
	with (obj_master) {
		var fix;
		slogf("\n*** SCHEDULE FIX TYPES");
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			slogf("fix: %1 week: %2 type: %3", i, ds_map_find_value(fix, "week"), s_get_fix_type_string(fix));
		}
	}
}

