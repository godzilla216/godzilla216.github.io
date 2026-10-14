function s_update_options() {
	slog("s_update_options op_soundfx[" + string(ds_map_find_value(obj_master.map_options, "op_soundfx")) + "]");
	if (global.console_build || 0) {
		inst_100289.visible = false;
	} else if (global.browser) {
		inst_100291.image = spr_cross;
		inst_100302.visible = false;
		inst_100289.visible = false;
		inst_100311.visible = false;
		if (global.poki) {
			inst_100306.text = s_str("ui_ExitGamePoki");
		}
	} else {
		inst_100302.colour = 4235519;
		inst_100295.colour = 4235519;
		inst_100316.colour = 4235519;
		inst_100305.colour = 4235519;
	}
	inst_100293.colour = global.c_background;
	switch (ds_map_find_value(obj_master.map_options, "op_drivedir")) {
		case -1:
			inst_100293.text = s_str("ui_driveLeft");
			break;
		case 0:
			inst_100293.text = s_str("ui_driveBoth");
			break;
		case 1:
			inst_100293.text = s_str("ui_driveRight");
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "op_scanlines")) {
		case true:
		case "true":
			inst_100278.text = s_str("ui_On");
			break;
		case false:
		case "false":
			inst_100278.text = s_str("ui_Off");
			break;
		default:
			slog("op_scanlines=" + ds_map_find_value(obj_master.map_options, "op_scanlines"));
	}
	switch (ds_map_find_value(obj_master.map_options, "op_weather")) {
		case true:
		case "true":
			inst_100295.text = s_str("btn_WeatherOn");
			break;
		case false:
		case "false":
			inst_100295.text = s_str("btn_WeatherOff");
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "op_soundfx")) {
		case 0:
			inst_100297.text = s_str("ui_Off");
			break;
		case 1:
			inst_100297.text = s_str("ui_SoundFX");
			break;
		case 2:
			inst_100297.text = string_hash_to_newline(s_str("ui_SoundFX") + "#& " + s_str("ui_Music"));
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "op_zoom")) {
		case true:
		case "true":
			inst_100298.text = s_str("ui_On");
			break;
		case false:
		case "false":
			inst_100298.text = s_str("ui_Off");
			break;
	}
	switch (obj_master.op_matchlength) {
		case -1:
			inst_100301.text = s_str("ui_min1");
			break;
		case 0:
			inst_100301.text = s_str("ui_min2");
			break;
		case 1:
			inst_100301.text = s_str("ui_min3");
			break;
	}
	switch (obj_master.op_difficulty) {
		case 0:
			inst_100303.text = s_str("ui_Difficulty0");
			break;
		case 1:
			inst_100303.text = s_str("ui_Difficulty1");
			break;
		case 2:
			inst_100303.text = s_str("ui_Difficulty2");
			break;
		case 3:
			inst_100303.text = s_str("ui_Difficulty3");
			break;
		case 4:
			inst_100303.text = s_str("ui_Difficulty4");
			break;
	}
	if (s_is_co_mode()) {
		switch (obj_master.recruitment_credits_cap) {
			case 50:
				inst_100305.text = s_str("ui_Roster10");
				break;
			case 60:
				inst_100305.text = s_str("ui_Roster12");
				break;
		}
		inst_100318.text = "Col: " + string(ds_map_find_value(obj_master.map_options, "co_op_color"));
	} else {
		switch (obj_master.salary_cap) {
			case 150:
				inst_100305.text = s_str("ui_Roster10");
				break;
			case 200:
				inst_100305.text = s_str("ui_Roster12");
				break;
		}
	}
	switch (ds_map_find_value(obj_master.map_options, "op_invert_throw")) {
		case 0:
			inst_100284.text = s_str("ui_Normal");
			break;
		case 1:
			inst_100284.text = s_str("ui_Inverted");
			break;
		case 2:
			inst_100284.text = s_str("ui_AnalogueL");
			break;
		case 3:
			inst_100284.text = s_str("ui_AnalogueR");
			break;
	}
	switch (obj_master.op_autorun) {
		case 0:
			inst_100287.text = s_str("ui_Off");
			break;
		case 1:
			inst_100287.text = s_str("ui_On");
			break;
	}
	switch (ds_map_find_value(obj_master.map_options, "op_kickoffs")) {
		case false:
		case "false":
			inst_100316.text = s_str("ui_Off");
			break;
		case true:
		case "true":
			inst_100316.text = s_str("ui_On");
			break;
	}
	inst_100294.text = "v" + s_get_gm_version();
	if (!obj_master.fr_mode && global.debug) {
		inst_100294.text += "\n" + s_str("ui_Version_Mode") + s_get_data_version_string();
	}
	if (global.browser && ds_map_find_value(obj_master.map_options, "op_soundfx") == 2) {
		slog("- Queueing s_update_music()");
		obj_options.alarm[0] = 30;
	} else {
		s_update_music();
	}
}

function s_get_op_invert_throw() {
	if (!s_is_multicon()) {
		return ds_map_find_value(obj_master.map_options, "op_invert_throw");
	} else {
		return ds_map_find_value(obj_master.map_options, global.gp.id == 2 ? "op_invert_throw_p2" : "op_invert_throw");
	}
}

function s_get_op_autorun() {
	if (!s_is_multicon()) {
		return obj_master.op_autorun;
	} else {
		return global.gp.id == 2 ? obj_master.op_autorun_p2 : obj_master.op_autorun;
	}
}

function btn_click_CollegeToggleColor() {
	var curC = ds_map_find_value(obj_master.map_options, "co_op_color");
	curC += 1;
	if (curC > 3) {
		curC = 0;
	}
	ds_map_set(obj_master.map_options, "co_op_color", curC);
	s_update_options();
	s_update_ui_colours();
}

function s_get_gm_version() {
	switch (os_type) {
		default:
			return "0.8.17.1";
	}
}

function s_update_options_if_present() {
	if (current_room == rm_options) {
		slogf("*** refresh options");
		s_update_options();
	}
}

