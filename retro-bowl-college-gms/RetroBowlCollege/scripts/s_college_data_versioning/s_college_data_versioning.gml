function s_get_versioned_path(_arg0, _arg1) {
	if (_arg0 == undefined) {
		_arg0 = "";
	}
	if (_arg1 == undefined) {
		_arg1 = global.g_m.data_version;
	}
	if (is_undefined(_arg1)) {
		_arg1 = s_get_build_data_version();
	}
	var path = "v" + string(_arg1) + "/" + _arg0;
	slogf("Versioned path: %1", path);
	return path;
}

function s_is_newer_data_available() {
	if (variable_instance_exists(global.g_m, "data_version") && !is_undefined(global.g_m.data_version)) {
		if (s_get_build_data_version() > global.g_m.data_version) {
			return true;
		}
	}
	return false;
}

function s_is_team_active_in_new_data(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.myteam_id;
	}
	var new_data = load_data_to_struct_array(s_get_versioned_path("Teams_CO.txt", s_get_build_data_version()));
	var team = s_get_struct_in_array_by_uid(new_data, _arg0);
	slog(team);
	if (team != -4) {
		return real(team.active);
	}
	return false;
}

function s_get_build_data_version(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = false;
	}
	if (!_arg0 && s_is_debug_desktop()) {
		return 2;
	}
	return 2;
}

function s_get_build_year_offset(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = false;
	}
	if (!_arg0 && s_is_debug_desktop()) {
		return 0;
	}
	return 0;
}

function s_get_data_version_string() {
	if (!s_is_co_mode()) {
		return "";
	}
	return s_strf(" v%1 yo%2", obj_master.data_version, obj_master.year_offset);
}

function s_reset_to_version(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = 0;
	}
	slogf("*** Data reset - Save slot %3 Version: %1 Year offset: %2", _arg0, _arg1, s_get_save_slot());
	with (global.g_m) {
		data_version = _arg0;
		year_offset = _arg1;
		teamlist = s_data_upgrade_teams(_arg0);
	}
	s_savegame();
	s_destroy_master();
	instance_create_layer(0, 0, "Instances", obj_master, { data_upgraded: true });
}

function s_data_upgrade_teams(_arg0) {
	var new_teams = ds_list_create();
	s_load_teams_data(new_teams, "Teams.txt");
	s_load_teams_data(new_teams, s_get_versioned_path("Teams_CO.txt", _arg0));
	var ot, nt;
	with (global.g_m) {
		for (var t = 0; t < ds_list_size(new_teams); t++) {
			nt = ds_list_find_value(new_teams, t);
			ot = s_get_team_by_id(ds_map_find_value(nt, "uid"));
			if (real(ds_map_find_value(ot, "uid")) == ds_map_find_value(nt, "uid")) {
				slogf("%1 team %2", ds_map_find_value(nt, "uid"), ds_map_find_value(nt, "name"));
				ds_map_set(nt, "reputation", ds_map_find_value(ot, "reputation"));
			}
		}
	}
	return new_teams;
}

function s_offer_data_upgrade() {
	if (!s_is_co_mode()) {
		return false;
	}
	if (!s_is_newer_data_available()) {
		return false;
	}
	slogf("*** DATA UPGRADE AVAILABLE");
	if (s_is_team_active_in_new_data()) {
		slogf("*** my team is active in new data");
		with (obj_player_profile) {
			instance_destroy();
		}
		s_create_message("", s_str("msg_NewSeasonScheduleAvailable"), s_str("ui_Yes"), s_str("ui_No"), s_data_upgrade_offer_accept, s_data_upgrade_offer_deny, global.c_background, 1);
		return true;
	}
	slogf("*** my team is not active in new data");
	return false;
}

function s_data_upgrade_offer_deny() {
	s_college_draft_new_season_loading();
}

function s_data_upgrade_offer_accept() {
	s_reset_to_version(s_get_build_data_version(), s_get_build_year_offset());
}

