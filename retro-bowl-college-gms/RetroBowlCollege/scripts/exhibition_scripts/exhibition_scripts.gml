function btn_click_exhibition_start() {
	slog("btn_click_exhibition_start");
	if ((os_type == 21 || s_is_debug_desktop()) && room == rm_master) {
		slogf("NX: Controller options");
		room_goto(rm_exhibition_options);
		return;
	}
	global.exhibition = true;
	s_create_new_save();
	obj_master.name_conf1 = "AFC";
	obj_master.name_conf2 = "NFC";
	obj_master.op_difficulty = 3;
	obj_master.btn_continue_state = 0;
	s_exhibition_team_management_start();
	room_goto(rm_exhibition);
}

function btn_click_exhibition_exit() {
	if (s_is_multicon()) {
		s_create_message("", s_str("msg_TouchscreenReactivation"), "", s_str("ui_Continue"), s_msg_clear, s_exhibition_exit, global.c_background, 1);
	} else {
		s_exhibition_exit();
	}
	s_multicon_reset();
}

function s_exhibition_exit() {
	s_multicon_reset();
	s_exhibition_team_management_clear();
	obj_master.roster = ds_list_create();
	s_destroy_master();
	room_goto(rm_master);
}

function s_exhibition_lost_two_controllers() {
	s_multicon_reset();
	if (!s_is_paused_or_just_unpaused()) {
		s_pause_toggle(false);
	}
	var msg_lost = s_create_message("", s_str("msg_LostController"), s_str("ui_AssignController"), s_str("ui_Exit"), s_exhibition_assign_lost_controller, s_exhibition_abandon, global.c_background, 1);
	msg_lost.message_id = 10;
}

function s_exhibition_assign_lost_controller() {
	s_msg_clear(10);
	s_multicon_init();
	if (!s_is_multicon()) {
		s_exhibition_lost_two_controllers();
	} else {
		if (s_is_paused_or_just_unpaused()) {
			s_pause_toggle();
		}
		s_multicon_restore_turn();
	}
}

function s_exhibition_abandon() {
	audio_sound_gain(snd_audience_idle, 0, 3000);
	s_exhibition_exit();
}

function s_set_up_uniforms_exhibition() {
	var teamid_away = ds_map_find_value(global.exh_fix, "away_team");
	var teamid_home = ds_map_find_value(global.exh_fix, "home_team");
	slog("Team " + string(teamid_away) + " @ Team " + string(teamid_home));
	obj_master.team[0] = ds_list_find_value(get_ex_teamset_0(), teamid_away);
	obj_master.team[1] = ds_list_find_value(get_ex_teamset_1(), teamid_home);
}

function s_create_exhibition_fixture(_arg0, _arg1) {
	slog("create fixture " + string(_arg0) + " @ " + string(_arg1));
	var fix = ds_map_create();
	ds_map_set(fix, "week", -1);
	ds_map_set(fix, "away_team", _arg0);
	ds_map_set(fix, "home_team", _arg1);
	ds_map_set(fix, "away_score", -1);
	ds_map_set(fix, "home_score", -1);
	return fix;
}

function btn_click_exhibition_controller_0() {
	switch (obj_master.playerteamindex) {
		case -1:
			obj_master.playerteamindex = 1;
			break;
		case 0:
			obj_master.playerteamindex = 1;
			break;
		case 1:
			obj_master.playerteamindex = -1;
			break;
	}
	s_update_exhibition_controllers();
}

function btn_click_exhibition_controller_1() {
	switch (obj_master.playerteamindex) {
		case -1:
			obj_master.playerteamindex = 0;
			break;
		case 0:
			obj_master.playerteamindex = -1;
			break;
		case 1:
			obj_master.playerteamindex = 0;
			break;
	}
	s_update_exhibition_controllers();
}

function s_update_exhibition_controllers() {
	inst_100797.text = "CPU";
	inst_100798.text = "CPU";
	switch (obj_master.playerteamindex) {
		case -1:
			inst_100797.text = "HUMAN";
			inst_100798.text = "HUMAN";
			break;
		case 0:
			inst_100797.text = "HUMAN";
			break;
		case 1:
			inst_100798.text = "HUMAN";
			break;
	}
	refresh_exh_roster_buttons();
}

function btn_click_ChangeTeamAway() {
	slog("btn_click_ChangeTeamAway");
	global.exh_choosing = 0;
	room_goto(rm_choose_team);
}

function btn_click_ChangeTeamHome() {
	slog("btn_click_ChangeTeamHome");
	global.exh_choosing = 1;
	room_goto(rm_choose_team);
}

function btn_click_Exhibition_Play() {
	slog_master_roster("btn_click_Exhibition_Play");
	slog(roster_short_desc_tag(global.exh_roster_p0, "btn_click_Exhibition_Play Start T0"));
	slog(roster_short_desc_tag(global.exh_roster_p1, "btn_click_Exhibition_Play Start T1"));
	if (s_is_multicon()) {
		if (obj_master.btn_continue_state & player_id) {
			obj_master.btn_continue_state -= player_id;
		} else {
			obj_master.btn_continue_state = obj_master.btn_continue_state | player_id;
		}
		s_set_exhibition_buttons(obj_master.btn_continue_state);
	}
	if (!s_is_multicon() || obj_master.btn_continue_state == 3) {
		with (obj_master) {
			obj_master.op_matchlength = ds_map_find_value(obj_master.map_options, "exh_op_matchlength");
			obj_master.stage = 4;
			if (obj_master.roster != -4) {
				for (var i = 0; i < ds_list_size(roster); i++) {
					ds_map_destroy(ds_list_find_value(roster, i));
				}
				ds_list_clear(roster);
			}
		}
		slog(roster_short_desc_tag(global.exh_roster_p0, "btn_click_Exhibition_Play End T0"));
		slog(roster_short_desc_tag(global.exh_roster_p1, "btn_click_Exhibition_Play End T1"));
		room_goto(rm_match);
	}
}

function s_update_options_exh() {
	slog("s_update_options_exh");
	if (s_is_multicon()) {
		inst_100808.gp_allowed = 1;
		inst_100807.gp_allowed = 1;
		inst_100814.gp_allowed = 1;
		inst_100809.gp_allowed = 1;
		inst_100806.gp_allowed = 1;
	}
	switch (ds_map_find_value(obj_master.map_options, "exh_op_weather")) {
		case 0:
			inst_100808.text = s_str("btn_WeatherRandom");
			break;
		case 1:
			inst_100808.text = s_str("btn_WeatherSun");
			break;
		case 2:
			inst_100808.text = s_str("btn_WeatherRain");
			break;
		case 3:
			inst_100808.text = s_str("btn_WeatherSnow");
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "exh_op_drivedir")) {
		case -1:
			inst_100807.text = s_str("ui_driveLeft");
			break;
		case 0:
			inst_100807.text = s_str("ui_driveBoth");
			break;
		case 1:
			inst_100807.text = s_str("ui_driveRight");
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "exh_op_matchlength")) {
		case -1:
			inst_100809.text = s_str("ui_min1");
			break;
		case 0:
			inst_100809.text = s_str("ui_min2");
			break;
		case 1:
			inst_100809.text = s_str("ui_min3");
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "exh_op_kickoffs")) {
		case false:
		case "false":
			inst_100814.text = s_str("ui_Off");
			break;
		case true:
		case "true":
			inst_100814.text = s_str("ui_On");
			break;
	}
}

function s_force_kick_direction() {
	with (obj_controller) {
		switch (quarter) {
			case 1:
				drivedir = possession == 0 ? 1 : -1;
				break;
			case 2:
				drivedir = possession == 0 ? -1 : 1;
				break;
			case 3:
				drivedir = possession == 0 ? -1 : 1;
				break;
			case 4:
				drivedir = possession == 0 ? 1 : -1;
				break;
			case 5:
				drivedir = possession == 0 ? 1 : -1;
				break;
		}
		if (ds_map_find_value(obj_master.map_options, "exh_op_drivedir") != 0) {
			drivedir = ds_map_find_value(obj_master.map_options, "exh_op_drivedir");
		}
		if (s_is_kickoff(1)) {
			s_switch_drivedirection();
		}
	}
}

function s_count_audibles() {
	with (obj_controller) {
		if (global.exhibition && obj_master.playerteamindex == -1) {
			switch (possession) {
				case 0:
					return audibles;
					break;
				case 1:
					return audibles_p2;
					break;
			}
		} else {
			return audibles;
		}
	}
}

function s_update_audibles(_arg0) {
	with (obj_controller) {
		if (global.exhibition && obj_master.playerteamindex == -1) {
			switch (possession) {
				case 0:
					audibles += _arg0;
					break;
				case 1:
					audibles_p2 += _arg0;
					break;
			}
		} else {
			audibles += _arg0;
		}
	}
}

function s_set_audibles(_arg0) {
	slog("s_set_audibles:" + string(_arg0));
	with (obj_controller) {
		audibles = _arg0;
		audibles_p2 = _arg0;
	}
}

function s_count_timeouts() {
	with (obj_controller) {
		if (global.exhibition && obj_master.playerteamindex == -1) {
			switch (possession) {
				case 0:
					return timeouts;
					break;
				case 1:
					return timeouts_p2;
					break;
			}
		} else {
			return timeouts;
		}
	}
}

function s_update_timeouts(_arg0) {
	with (obj_controller) {
		if (global.exhibition && obj_master.playerteamindex == -1) {
			switch (possession) {
				case 0:
					timeouts += _arg0;
					break;
				case 1:
					timeouts_p2 += _arg0;
					break;
			}
		} else {
			timeouts += _arg0;
		}
	}
}

function s_set_timeouts(_arg0) {
	slog("s_set_timeouts:" + string(_arg0));
	with (obj_controller) {
		timeouts = _arg0;
		timeouts_p2 = _arg0;
	}
}

function s_set_exhibition_buttons(_arg0) {
	inst_100802.visible = false;
	inst_100802.image = spr_arrowR;
	inst_100799.image = spr_arrowR;
	if (s_is_multicon()) {
		inst_100802.visible = true;
		inst_100802.player_id = 1;
		inst_100793.gp_allowed = 1;
		inst_100785.gp_allowed = 1;
		inst_100796.gp_allowed = 1;
		inst_100791.gp_allowed = 1;
		inst_100802.gp_allowed = 1;
		inst_100790.gp_allowed = 1;
		inst_100793.active = true;
		inst_100785.active = true;
		inst_100796.active = true;
		inst_100791.active = true;
		inst_100790.active = true;
		inst_100799.player_id = 2;
		inst_100794.gp_allowed = 2;
		inst_100792.gp_allowed = 2;
		inst_100799.gp_allowed = 2;
		inst_100794.active = true;
		inst_100792.active = true;
		if (_arg0 & 1) {
			inst_100802.image = spr_tick;
			inst_100793.active = false;
			inst_100785.active = false;
			inst_100796.active = false;
			inst_100791.active = false;
			inst_100790.active = false;
		}
		if (_arg0 & 2) {
			inst_100799.image = spr_tick;
			inst_100794.active = false;
			inst_100792.active = false;
		}
	}
}

function btn_click_exhibition_switch_start() {
	if (room == rm_exhibition_options && s_is_multicon_wanted()) {
		s_create_message("", s_str("msg_TouchscreenDeactivation"), s_str("ui_Continue"), s_str("ui_Back"), s_exhibition_controller_check_continue, s_msg_clear, global.c_background, 1);
		return;
	}
	btn_click_exhibition_start();
}

function s_exhibition_controller_check_continue() {
	s_multicon_init();
	s_msg_clear();
	if (s_is_multicon()) {
		s_set_multicon_touch(false);
		btn_click_exhibition_start();
	}
}

function btn_click_exhibition_controllers() {
	s_toggle_multicon_wanted();
	btn_exhibition_controllers_refresh();
}

function btn_exhibition_controllers_refresh() {
	with (inst_100823) {
		text = s_str(s_is_multicon_wanted() ? "ui_Controllers_Double" : "ui_Controllers_Single");
	}
}

function rm_exhibition_options_create() {
	s_multicon_reset();
	btn_exhibition_controllers_refresh();
}

function s_exh_teamswap_allowed() {
	return ds_map_find_value(obj_master.map_options, "fullversion") == 1;
}

function get_ex_teamset_0() {
	return global.exh_teamlist_p0 != -4 ? global.exh_teamlist_p0 : obj_master.teamlist;
}

function get_ex_teamset_1() {
	return global.exh_teamlist_p1 != -4 ? global.exh_teamlist_p1 : obj_master.teamlist;
}

function get_ex_uniform_file(_arg0) {
	if (_arg0 != -1) {
		var custom_name = "uniforms_custom_" + string(_arg0) + ".txt";
		if (file_exists(custom_name)) {
			return custom_name;
		}
	}
	return s_uniforms_default_file();
}

function btn_click_ExhibitionLoadUniformsA() {
	btn_click_ExhibitionLoadUniforms(1, s_load_save_team_exhibitionA);
}

function btn_click_ExhibitionLoadUniformsB() {
	btn_click_ExhibitionLoadUniforms(2, s_load_save_team_exhibitionB);
}

function btn_click_ExhibitionLoadUniformsC() {
	btn_click_ExhibitionLoadUniforms(3, s_load_save_team_exhibitionC);
}

function btn_click_ExhibitionLoadUniformsD() {
	btn_click_ExhibitionLoadUniforms(4, s_load_save_team_exhibitionD);
}

function btn_click_ExhibitionLoadUniformsE() {
	btn_click_ExhibitionLoadUniforms(5, s_load_save_team_exhibitionE);
}

function btn_click_ExhibitionLoadUniforms(_arg0, _arg1) {
	if (s_exh_teamswap_allowed() == false) {
		s_create_message("", s_str("msg_ExhibitionCantCopyUniforms"), "", s_str("ui_Confirm"), s_msg_clear, s_msg_clear, global.c_background, 1);
		return;
	}
	slog("btn_click_ExhibitionLoadUniforms [" + string(_arg0) + "]");
	var str = string_replace(s_str("msg_ExhibitionCopyUniforms"), "$num", _arg0);
	s_create_message("", str, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, _arg1, global.c_background, 1);
}

function s_get_save_from_number(_arg0) {
	switch (_arg0) {
		case 1:
			return global.g_savename1;
		case 2:
			return global.g_savename2;
		case 3:
			return global.g_savename3;
		case 4:
			return global.g_savename4;
		case 5:
			return global.g_savename5;
	}
}

function s_load_save_team_exhibitionA() {
	s_load_save_team_exhibition(1, global.g_savename1);
}

function s_load_save_team_exhibitionB() {
	s_load_save_team_exhibition(2, global.g_savename2);
}

function s_load_save_team_exhibitionC() {
	s_load_save_team_exhibition(3, global.g_savename3);
}

function s_load_save_team_exhibitionD() {
	s_load_save_team_exhibition(4, global.g_savename4);
}

function s_load_save_team_exhibitionE() {
	s_load_save_team_exhibition(5, global.g_savename5);
}

function s_load_save_team_exhibition(_arg0, _arg1) {
	s_msg_clear();
	slog("s_load_save_team_exhibition [" + string(_arg0) + "(" + _arg1 + ")] for player[" + string(global.exh_choosing) + "]");
	if (global.exh_choosing == 0) {
		global.exh_teamset_p0 = _arg0;
	} else if (global.exh_choosing == 1) {
		global.exh_teamset_p1 = _arg0;
	}
	ini_open(_arg1);
	var cur_teamlist = ds_list_create();
	var teamsize = ini_read_real("savegame", "teamlist", 0);
	for (var m = 0; m < teamsize; m++) {
		var map = ds_map_create();
		ds_map_read(map, ini_read_string("savegame", "teamlist_" + string(m), ""));
		ds_list_add(cur_teamlist, map);
	}
	var cur_roster = ds_list_create();
	var roster_size = ini_read_real("savegame", "roster", 0);
	for (var r = 0; r < roster_size; r++) {
		var pmap = ds_map_create();
		ds_map_read(pmap, ini_read_string("savegame", "roster_" + string(r), ""));
		if (s_is_player_pmap_corrupt(pmap)) {
			ds_map_destroy(pmap);
			pmap = -1;
			continue;
		}
		ds_list_add(cur_roster, pmap);
	}
	var name_conf1 = ini_read_string("savegame", "name_conf1", s_str("conf_AFC"));
	var name_conf2 = ini_read_string("savegame", "name_conf2", s_str("conf_NFC"));
	var load_teamid = ini_read_real("savegame", "myteam_id", -1);
	slog("name_conf1[" + name_conf1 + "] name_conf2[" + name_conf2 + "]");
	ini_close();
	if (global.exh_choosing == 0) {
		global.exh_teamlist_p0 = s_exhibition_wipe_list(global.exh_teamlist_p0);
		global.exh_teamlist_p0 = cur_teamlist;
		global.exh_confAFC_p0 = name_conf1;
		global.exh_confNFC_p0 = name_conf2;
		global.exh_teamId_p0 = load_teamid;
		global.exh_roster_p0 = cur_roster;
		slog("test: Team 0 in loaded teams is [" + ds_map_find_value(s_get_team_by_id_internal(0, global.exh_teamlist_p0), "name") + "]");
	} else if (global.exh_choosing == 1) {
		global.exh_teamlist_p1 = s_exhibition_wipe_list(global.exh_teamlist_p1);
		global.exh_teamlist_p1 = cur_teamlist;
		global.exh_confAFC_p1 = name_conf1;
		global.exh_confNFC_p1 = name_conf2;
		global.exh_teamId_p1 = load_teamid;
		global.exh_roster_p1 = cur_roster;
		slog("test: Team 0 in loaded teams is [" + ds_map_find_value(s_get_team_by_id_internal(0, global.exh_teamlist_p1), "name") + "]");
	}
	var filename = "uniforms_custom_" + string(_arg0) + ".txt";
	if (file_exists(filename)) {
		var file = file_text_open_read(filename);
		var keys = s_split_string(file_text_read_string(file));
		file_text_readln(file);
		while (!file_text_eof(file)) {
			var values = s_split_string(file_text_read_string(file));
			file_text_readln(file);
			var uid = values[0];
			var tmap = s_get_team_by_id_internal(uid, cur_teamlist);
			ds_map_set(tmap, "name", values[1]);
			ds_map_set(tmap, "tla", values[2]);
		}
		file_text_close(file);
	}
	s_refresh_exhibition_team_load_buttons();
}

function exh_refresh_roster_from_save(_arg0, _arg1) {
	if (_arg1 == -1) {
		slog("exh_refresh_roster_from_save skipped. Player[" + string(_arg0) + "] has no save loaded");
		return;
	}
	s_msg_clear();
	var save_filename = s_get_save_from_number(_arg1);
	slog("exh_refresh_roster_from_save loading roster from save [" + string(_arg1) + "(" + save_filename + ")] for player[" + string(_arg0) + "]");
	ini_open(save_filename);
	var cur_roster = ds_list_create();
	var roster_size = ini_read_real("savegame", "roster", 0);
	for (var r = 0; r < roster_size; r++) {
		var pmap = ds_map_create();
		ds_map_read(pmap, ini_read_string("savegame", "roster_" + string(r), ""));
		if (s_is_player_pmap_corrupt(pmap)) {
			ds_map_destroy(pmap);
			pmap = -1;
			continue;
		}
		ds_list_add(cur_roster, pmap);
	}
	ini_close();
	if (_arg0 == 0) {
		global.exh_roster_p0 = s_exhibition_wipe_list(global.exh_roster_p0);
		global.exh_roster_p0 = cur_roster;
	} else if (_arg0 == 1) {
		global.exh_roster_p1 = s_exhibition_wipe_list(global.exh_roster_p1);
		global.exh_roster_p1 = cur_roster;
	}
}

function s_load_html_save1_exhibition() {
	s_msg_clear();
	var saveNumber = 1;
	var save_filename = global.g_savename1;
	if (global.exh_choosing == 0 && global.exh_teamId_p0 != -1) {
		return;
	}
	if (global.exh_choosing == 1 && global.exh_teamId_p1 != -1) {
		return;
	}
	slog("s_load_save_team_exhibition [" + string(saveNumber) + "(" + save_filename + ")] for player[" + string(global.exh_choosing) + "]");
	ini_open(save_filename);
	var cur_roster = ds_list_create();
	var roster_size = ini_read_real("savegame", "roster", 0);
	for (var r = 0; r < roster_size; r++) {
		var pmap = ds_map_create();
		ds_map_read(pmap, ini_read_string("savegame", "roster_" + string(r), ""));
		if (s_is_player_pmap_corrupt(pmap)) {
			ds_map_destroy(pmap);
			pmap = -1;
			continue;
		}
		ds_list_add(cur_roster, pmap);
	}
	var load_teamid = ini_read_real("savegame", "myteam_id", -1);
	ini_close();
	if (global.exh_choosing == 0) {
		global.exh_teamset_p0 = saveNumber;
		global.exh_teamId_p0 = load_teamid;
		global.exh_roster_p0 = cur_roster;
	} else if (global.exh_choosing == 1) {
		global.exh_teamset_p1 = saveNumber;
		global.exh_teamId_p1 = load_teamid;
		global.exh_roster_p1 = cur_roster;
	}
}

function btn_click_RestoreAllTeams_ex() {
	s_create_message("", s_str("msg_RestoreAllTeams"), s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_restore_uniforms_all_ex, global.c_background, 1);
}

function s_restore_uniforms_all_ex() {
	s_msg_clear();
	if (global.exh_choosing == 0) {
		global.exh_teamset_p0 = -1;
		global.exh_teamlist_p0 = s_exhibition_wipe_list(global.exh_teamlist_p0);
		global.exh_confAFC_p0 = s_str("conf_AFC");
		global.exh_confNFC_p0 = s_str("conf_NFC");
		global.exh_teamId_p0 = -1;
		global.exh_use_roster_p0 = false;
		global.exh_roster_p0 = s_exhibition_wipe_list(global.exh_roster_p0);
	} else if (global.exh_choosing == 1) {
		global.exh_teamset_p1 = -1;
		global.exh_teamlist_p1 = s_exhibition_wipe_list(global.exh_teamlist_p1);
		global.exh_confAFC_p1 = s_str("conf_AFC");
		global.exh_confNFC_p1 = s_str("conf_NFC");
		global.exh_teamId_p1 = -1;
		global.exh_use_roster_p1 = false;
		global.exh_roster_p1 = s_exhibition_wipe_list(global.exh_roster_p1);
	}
	s_copy_teamnames_from_uniform_file(s_uniforms_default_file());
	s_refresh_exhibition_team_load_buttons();
}

function s_exhibition_team_management_start() {
	s_exhibition_team_management_clear();
	with (obj_master) {
		teamlist = s_exhibition_wipe_list(teamlist);
		teamlist = s_load_teams();
		obj_master.roster = s_exhibition_wipe_list(obj_master.roster);
	}
}

function s_exhibition_team_management_clear() {
	global.exh_teamset_p0 = -1;
	global.exh_confAFC_p0 = s_str("conf_AFC");
	global.exh_confNFC_p0 = s_str("conf_NFC");
	global.exh_teamId_p0 = -1;
	global.exh_use_roster_p0 = false;
	global.exh_teamset_p1 = -1;
	global.exh_confAFC_p1 = s_str("conf_AFC");
	global.exh_confNFC_p1 = s_str("conf_NFC");
	global.exh_teamId_p1 = -1;
	global.exh_use_roster_p1 = false;
	if (!variable_global_exists("exh_roster_p0")) {
		global.exh_roster_p0 = -4;
	}
	if (!variable_global_exists("exh_roster_p1")) {
		global.exh_roster_p1 = -4;
	}
	global.exh_roster_p0 = s_exhibition_wipe_list(global.exh_roster_p0);
	global.exh_roster_p1 = s_exhibition_wipe_list(global.exh_roster_p1);
	if (!variable_global_exists("exh_teamlist_p0")) {
		global.exh_teamlist_p0 = -4;
	}
	if (!variable_global_exists("exh_teamlist_p1")) {
		global.exh_teamlist_p1 = -4;
	}
	global.exh_teamlist_p0 = s_exhibition_wipe_list(global.exh_teamlist_p0);
	global.exh_teamlist_p1 = s_exhibition_wipe_list(global.exh_teamlist_p1);
}

function s_exhibition_wipe_list(_arg0) {
	if (_arg0 == -4) {
		return -4;
	}
	for (var i = 0; i < ds_list_size(_arg0); i++) {
		ds_map_destroy(ds_list_find_value(_arg0, i));
	}
	ds_list_destroy(_arg0);
	_arg0 = -4;
	return -4;
}

function s_refresh_exhibition_team_load_buttons() {
	var saveSlot = global.exh_choosing == 0 ? global.exh_teamset_p0 : global.exh_teamset_p1;
	if (global.exhibition_html_1save) {
		saveSlot = -1;
	}
	slog("s_refresh_exhibition_team_load_buttons for player[" + string(global.exh_choosing) + "] with current teamset[" + string(saveSlot) + "]");
	slog("global.exh_confAFC_p0 [" + global.exh_confAFC_p0 + "]");
	slog("global.exh_confNFC_p0 [" + global.exh_confNFC_p0 + "]");
	slog("global.exh_confAFC_p1 [" + global.exh_confAFC_p1 + "]");
	slog("global.exh_confNFC_p1 [" + global.exh_confNFC_p1 + "]");
	inst_100048.active = true;
	inst_100048.text = s_str("ui_CopySlot1");
	inst_100049.active = true;
	inst_100049.text = s_str("ui_CopySlot2");
	inst_100050.active = true;
	inst_100050.text = s_str("ui_CopySlot3");
	inst_100051.active = true;
	inst_100051.text = s_str("ui_CopySlot4");
	inst_100052.active = true;
	inst_100052.text = s_str("ui_CopySlot5");
	if (!file_exists(global.g_savename1)) {
		inst_100048.active = false;
	}
	if (!file_exists(global.g_savename2)) {
		inst_100049.active = false;
	}
	if (!file_exists(global.g_savename3)) {
		inst_100050.active = false;
	}
	if (!file_exists(global.g_savename4)) {
		inst_100051.active = false;
	}
	if (!file_exists(global.g_savename5)) {
		inst_100052.active = false;
	}
	switch (saveSlot) {
		case 1:
			inst_100048.active = false;
			inst_100048.text = s_str("ui_Current");
			break;
		case 2:
			inst_100049.active = false;
			inst_100049.text = s_str("ui_Current");
			break;
		case 3:
			inst_100050.active = false;
			inst_100050.text = s_str("ui_Current");
			break;
		case 4:
			inst_100051.active = false;
			inst_100051.text = s_str("ui_Current");
			break;
		case 5:
			inst_100052.active = false;
			inst_100052.text = s_str("ui_Current");
			break;
	}
	if (s_exh_teamswap_allowed() == false) {
		inst_100048.colour = 4210752;
		inst_100049.colour = 4210752;
		inst_100050.colour = 4210752;
		inst_100051.colour = 4210752;
		inst_100052.colour = 4210752;
	}
	inst_100047.active = saveSlot != -1;
	inst_100046.text = s_str("ui_SaveSlot" + string(saveSlot));
	with (obj_choose_team) {
		s_update_team_buttons();
	}
}

function refresh_exh_roster_buttons() {
	var p0Human = obj_master.playerteamindex == -1 || obj_master.playerteamindex == 0;
	var p1Human = obj_master.playerteamindex == -1 || obj_master.playerteamindex == 1;
	inst_100803.active = global.exh_use_roster_p0 && p0Human;
	inst_100804.active = global.exh_use_roster_p1 && p1Human;
}

function btn_click_RosterTeamAway() {
	global.exh_choosing = 0;
	obj_master.roster = global.exh_roster_p0;
	slog(roster_short_desc_tag(global.exh_roster_p0, "TO ROSTER ROOM exh_roster_p0"));
	slog(roster_short_desc_tag(global.exh_roster_p1, "TO ROSTER ROOM exh_roster_p1"));
	room_goto(rm_roster);
}

function btn_click_RosterTeamHome() {
	global.exh_choosing = 1;
	obj_master.roster = global.exh_roster_p1;
	slog(roster_short_desc_tag(global.exh_roster_p0, "TO ROSTER ROOM exh_roster_p0"));
	slog(roster_short_desc_tag(global.exh_roster_p1, "TO ROSTER ROOM exh_roster_p1"));
	room_goto(rm_roster);
}

function btn_click_Profile_Back_To_Exhibition() {
	if (global.exh_choosing == 0) {
		global.exh_roster_p0 = obj_master.roster;
	}
	if (global.exh_choosing == 1) {
		global.exh_roster_p1 = obj_master.roster;
	}
	obj_master.roster = -4;
	slog(roster_short_desc_tag(global.exh_roster_p0, "Back to EXH ROOM T0"));
	slog(roster_short_desc_tag(global.exh_roster_p1, "Back to EXH ROOM T1"));
	room_goto(rm_exhibition);
}

function rm_player_profile_exhibition_create() {
	inst_100429.visible = false;
	inst_100427.visible = false;
	inst_100426.visible = false;
	inst_100425.visible = false;
	layer_set_visible(layer_hoftag, false);
}

function rm_roster_exhibition_create() {
	inst_100499.visible = false;
	inst_100493.visible = false;
	inst_100500.visible = false;
	inst_100496.visible = false;
	inst_100491.image = spr_arrowL;
	inst_100491.onClickAction = btn_click_Profile_Back_To_Exhibition;
}

function exhibition_handle_exit_match() {
	slog("exhibition_handle_exit_match");
	obj_controller.team_roster[0] = s_exhibition_wipe_list(obj_controller.team_roster[0]);
	obj_controller.team_roster[1] = s_exhibition_wipe_list(obj_controller.team_roster[1]);
	exh_refresh_roster_from_save(0, global.exh_teamset_p0);
	exh_refresh_roster_from_save(1, global.exh_teamset_p1);
	slog_roster("QUIT team_roster[0]", 0);
	slog_roster("QUIT team_roster[1]", 1);
	slog(roster_short_desc_tag(global.exh_roster_p0, "QUIT exh_roster_p0"));
	slog(roster_short_desc_tag(global.exh_roster_p1, "QUIT exh_roster_p1"));
}

