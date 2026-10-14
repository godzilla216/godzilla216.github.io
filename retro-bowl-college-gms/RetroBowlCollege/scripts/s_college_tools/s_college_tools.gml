function s_college_set_up_globals() {
	co_stats_tab = 0;
	postseason_chunk_news_last_shown = 0;
}

function s_college_age_index(_arg0) {
	if (_arg0 == s_rookie_age_internal()) {
		return 0;
	}
	if (_arg0 == s_rookie_age_internal() + 1) {
		return 1;
	}
	if (_arg0 == s_rookie_age_internal() + 2) {
		return 2;
	}
	if (_arg0 == s_rookie_age_internal() + 3) {
		return 3;
	}
	return 3;
}

function s_college_age_label(_arg0) {
	var label = s_str("ui_Year") + ":";
	if (_arg0 == s_rookie_age_internal()) {
		label += " " + s_str("ui_Freshman");
	}
	if (_arg0 == s_rookie_age_internal() + 1) {
		label += " " + s_str("ui_Sophomore");
	}
	if (_arg0 == s_rookie_age_internal() + 2) {
		label += " " + s_str("ui_Junior");
	}
	if (_arg0 == s_rookie_age_internal() + 3) {
		label += " " + s_str("ui_Senior");
	}
	return label;
}

function s_college_age_simple(_arg0) {
	var age = ds_map_find_value(_arg0, "age");
	if (age == s_rookie_age_internal()) {
		return s_str("ui_Freshman");
	}
	if (age == s_rookie_age_internal() + 1) {
		return s_str("ui_Sophomore");
	}
	if (age == s_rookie_age_internal() + 2) {
		return s_str("ui_Junior");
	}
	if (age == s_rookie_age_internal() + 3) {
		return s_str("ui_Senior");
	}
	return "N/A";
}

function s_college_age_simple_other(_arg0) {
	var age = ds_map_find_value(_arg0, "age");
	if (age == s_rookie_age_internal()) {
		return s_str("ui_Freshman_other");
	}
	if (age == s_rookie_age_internal() + 1) {
		return s_str("ui_Sophomore_other");
	}
	if (age == s_rookie_age_internal() + 2) {
		return s_str("ui_Junior_other");
	}
	if (age == s_rookie_age_internal() + 3) {
		return s_str("ui_Senior_other");
	}
	return "N/A";
}

function s_college_age_simple_short(_arg0) {
	var age = ds_map_find_value(_arg0, "age");
	if (age == s_rookie_age_internal()) {
		return s_str("ui_Freshman_Short");
	}
	if (age == s_rookie_age_internal() + 1) {
		return s_str("ui_Sophomore_Short");
	}
	if (age == s_rookie_age_internal() + 2) {
		return s_str("ui_Junior_Short");
	}
	if (age == s_rookie_age_internal() + 3) {
		return s_str("ui_Senior_Short");
	}
	return "N/A";
}

function s_college_shorter_season() {
	slogf("College shorter season - co %1", s_is_co_mode());
	if (!s_is_co_mode()) {
		return;
	}
	with (obj_master) {
		last_week_regular = 14;
		first_week_playoffs = 15;
		first_week_postseason = 15;
		year_stagger = s_get_schedule_year_stagger();
	}
}

function s_college_academics_type(_arg0) {
	if (s_is_co_mode() == false) {
		return false;
	}
	if (!instance_exists(obj_master)) {
		return false;
	}
	if (!variable_instance_exists(obj_master, "myteam_id")) {
		return false;
	}
	if (obj_master.myteam_id == -1) {
		return false;
	}
	var tmap = ds_list_find_value(obj_master.teamlist, obj_master.myteam_id);
	if (is_undefined(tmap)) {
		return false;
	}
	if (ds_map_find_value(tmap, "type") == _arg0) {
		return true;
	}
	return false;
}

function s_college_correct_new_player(_arg0) {
	if (obj_master.co_mode == 0) {
		return;
	}
	slog2("s_college_correct_new_player");
	var origPG = ds_map_find_value(_arg0, "percent_grade");
	var minPG = 79 + s_my_team_academics();
	var maxPG = ds_map_find_value(_arg0, "max_percent_grade");
	ds_map_set(_arg0, "percent_grade", irandom_range(minPG, maxPG));
	s_refresh_suspended(_arg0, false);
	slog("Player grade corrected [" + string(origPG) + "]->[" + string(ds_map_find_value(_arg0, "percent_grade")) + "] (aca:" + string(s_my_team_academics()) + ", range:" + string(minPG) + "|" + string(maxPG) + ")");
	ds_map_set(_arg0, "face_set", 2);
	var tmap = s_get_team_by_id(obj_master.myteam_id);
	if (is_undefined(tmap) == false) {
		if (ds_map_find_value(tmap, "type") == "HBU" || ds_map_find_value(tmap, "type") == "Ivy" || ds_map_find_value(tmap, "type") == "0") {
			if (irandom(1) == 0) {
				ds_map_set(_arg0, "face_set", 1);
			}
		}
		if (ds_map_find_value(tmap, "type") == "HBU" || ds_map_find_value(tmap, "type") == "Religious") {
			switch (ds_map_find_value(tmap, "type")) {
				case "HBU":
					if (irandom(9)) {
						ds_map_set(_arg0, "skin", 0);
					}
					break;
				case "Religious":
					if (irandom(3)) {
						ds_map_set(_arg0, "skin", 2);
					}
					break;
			}
			var fgrid = obj_master.face_grid_L;
			switch (ds_map_find_value(_arg0, "skin")) {
				case 2:
					fgrid = obj_master.face_grid_L;
					break;
				case 1:
					fgrid = obj_master.face_grid_M;
					break;
				case 0:
					fgrid = obj_master.face_grid_D;
					break;
			}
			if (ds_grid_get_min(fgrid, 0, 0, ds_grid_width(fgrid), ds_grid_height(fgrid)) == 1) {
				slog("Clearing face grid");
				ds_grid_clear(fgrid, 0);
			}
			s_choose_face(_arg0, fgrid);
			slog("Player face corrected. For institution[" + ds_map_find_value(tmap, "name") + "|" + ds_map_find_value(tmap, "type") + "] -> Picked new face using skin color[" + string(ds_map_find_value(_arg0, "skin")) + "] and face set[" + string(ds_map_find_value(_arg0, "face_set")) + "]");
		} else {
			slog("Player face corrected. For institution[" + ds_map_find_value(tmap, "name") + "|" + ds_map_find_value(tmap, "type") + "] -> Changed face set to [" + string(ds_map_find_value(_arg0, "face_set")) + "]");
		}
		slog("Player hobby corrected for institution");
		ds_map_set(_arg0, "hobby", s_get_random_hobby());
		ds_map_set(_arg0, "curriculum_vitae", "");
		var grad_year = obj_master.start_year + obj_master.year - (ds_map_find_value(_arg0, "age") - s_rookie_age_internal());
		s_add_cv_entry_from_key(_arg0, "cv_GradHighSchool", grad_year);
		if (ds_map_find_value(_arg0, "walk_on") == 1) {
			s_add_cv_entry_from_key(_arg0, "cv_WalkOnJoinTeamB");
			s_add_cv_entry_from_key(_arg0, "cv_WalkOnJoinTeamA");
		} else {
			s_add_cv_entry_from_key(_arg0, "cv_JoinTeam", grad_year);
		}
		ds_map_set(_arg0, "curriculum_interest", s_str(s_get_random_cv_entry(_arg0, "cv_LameInterest")));
	} else {
		slog("Player face corrected. No institution data -> Changed face set to [" + string(ds_map_find_value(_arg0, "face_set")) + "]");
	}
}

function s_get_random_hobby() {
	var insititutionType = "Unknown";
	var tmap = ds_list_find_value(obj_master.teamlist, obj_master.myteam_id);
	if (is_undefined(tmap) == false) {
		var teamType = ds_map_find_value(tmap, "type");
		if (teamType != "0") {
			insititutionType = teamType;
		} else {
			insititutionType = "Unspecified";
		}
	}
	var shortlist = ds_list_create();
	for (var i = 1; i < ds_list_size(obj_master.hobbies); i++) {
		var study = ds_list_find_value(obj_master.hobbies, i);
		var weight = ds_map_find_value(study, insititutionType);
		for (var w = 0; w < weight; w++) {
			ds_list_add(shortlist, ds_map_find_value(study, "uid"));
		}
	}
	var num = ds_list_size(shortlist);
	var index = irandom_range(0, num - 1);
	var chosenUID = ds_list_find_value(shortlist, index);
	slog("s_get_random_hobby for insitution type[" + string(insititutionType) + "] (num:" + string(num) + ") selected @index[" + string(index) + "] (" + string(chosenUID) + ")" + ds_map_find_value(s_get_hobby_from_uid(chosenUID), "Society"));
	ds_list_destroy(shortlist);
	return chosenUID;
}

function s_get_hobby_name(_arg0, _arg1) {
	var uid = ds_map_find_value(_arg0, "hobby");
	var hobby = s_get_hobby_from_uid(uid);
	if (_arg1) {
		if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal() && uid >= 1000) {
			return s_str("ui_FraternityRush");
		}
	}
	return ds_map_find_value(hobby, "Society");
}

function s_get_hobby_from_uid(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.hobbies); i++) {
		var hobby = ds_list_find_value(obj_master.hobbies, i);
		if (ds_map_find_value(hobby, "uid") == _arg0) {
			return hobby;
		}
	}
	return undefined;
}

function s_is_player_hobby_fraternity(_arg0) {
	return ds_map_find_value(_arg0, "hobby") >= 1000;
}

function s_get_random_study_subject(_arg0) {
	var insititutionType = "Unknown";
	var tmap = ds_list_find_value(obj_master.teamlist, obj_master.myteam_id);
	if (is_undefined(tmap) == false) {
		var teamType = ds_map_find_value(tmap, "type");
		if (teamType != "0") {
			insititutionType = teamType;
		} else {
			insititutionType = "Unspecified";
		}
	}
	var shortlist = ds_list_create();
	for (var i = 0; i < ds_list_size(obj_master.majorminor); i++) {
		var study = ds_list_find_value(obj_master.majorminor, i);
		if (ds_map_find_value(study, "uid") == _arg0) {
			continue;
		}
		var weight = ds_map_find_value(study, insititutionType);
		for (var w = 0; w < weight; w++) {
			ds_list_add(shortlist, ds_map_find_value(study, "uid"));
		}
	}
	var num = ds_list_size(shortlist);
	var index = irandom_range(0, num - 1);
	var chosenUID = ds_list_find_value(shortlist, index);
	ds_list_destroy(shortlist);
	return chosenUID;
}

function s_get_study_subject_from_uid(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.majorminor); i++) {
		var subject = ds_list_find_value(obj_master.majorminor, i);
		if (ds_map_find_value(subject, "uid") == _arg0) {
			return subject;
		}
	}
	return undefined;
}

function s_get_study_subject_name_from_uid(_arg0) {
	var subject = s_get_study_subject_from_uid(_arg0);
	return ds_map_find_value(subject, "Subject");
}

function s_get_minor_name(_arg0, _arg1) {
	var uid = ds_map_find_value(_arg0, "minor");
	var subject = s_get_study_subject_from_uid(uid);
	if (_arg1 == false) {
		return ds_map_find_value(subject, "Subject");
	}
	var age = ds_map_find_value(_arg0, "age");
	var unveiled = false;
	var Y1 = s_rookie_age_internal();
	var Y2 = s_rookie_age_internal() + 1;
	var Y3 = s_rookie_age_internal() + 2;
	var Y4 = s_rookie_age_internal() + 3;
	switch (ds_map_find_value(_arg0, "subject_reveal")) {
		case 0:
			break;
		case 1:
			if (age >= Y4) {
				unveiled = true;
			}
			break;
		case 2:
			break;
		case 3:
			if (age >= Y3) {
				unveiled = true;
			}
			break;
		case 4:
			if (age >= Y4) {
				unveiled = true;
			}
			break;
	}
	if (unveiled) {
		return ds_map_find_value(subject, "Subject");
	}
	return s_str("ui_Undeclared");
}

function s_get_major_name(_arg0, _arg1) {
	var uid = ds_map_find_value(_arg0, "major");
	var subject = s_get_study_subject_from_uid(uid);
	if (_arg1 == false) {
		return ds_map_find_value(subject, "Subject");
	}
	var age = ds_map_find_value(_arg0, "age");
	var unveiled = false;
	var Y1 = s_rookie_age_internal();
	var Y2 = s_rookie_age_internal() + 1;
	var Y3 = s_rookie_age_internal() + 2;
	var Y4 = s_rookie_age_internal() + 3;
	switch (ds_map_find_value(_arg0, "subject_reveal")) {
		case 0:
			if (age >= Y4) {
				unveiled = true;
			}
			break;
		case 1:
			if (age >= Y4) {
				unveiled = true;
			}
			break;
		case 2:
			if (age >= Y3) {
				unveiled = true;
			}
			break;
		case 3:
			if (age >= Y3) {
				unveiled = true;
			}
			break;
		case 4:
			if (age >= Y3) {
				unveiled = true;
			}
			break;
	}
	if (unveiled) {
		return ds_map_find_value(subject, "Subject");
	}
	return s_str("ui_Undeclared");
}

function s_get_study_info(_arg0) {
	return "M:" + s_get_major_name(_arg0, false) + " / m:" + s_get_minor_name(_arg0, false) + " Subject reveal #" + string(ds_map_find_value(_arg0, "subject_reveal"));
}

function s_get_random_trait() {
	var num = ds_list_size(obj_master.traits);
	var trait = ds_list_find_value(obj_master.traits, irandom_range(0, num - 1));
	return ds_map_find_value(trait, "uid");
}

function s_get_trait_name(_arg0) {
	var uid = ds_map_find_value(_arg0, "trait");
	var trait = s_get_trait_from_uid(uid);
	return ds_map_find_value(trait, "name");
}

function s_get_trait_from_uid(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.traits); i++) {
		var trait = ds_list_find_value(obj_master.traits, i);
		if (ds_map_find_value(trait, "uid") == _arg0) {
			return trait;
		}
	}
	return undefined;
}

function s_get_random_hometown() {
	var num = ds_list_size(obj_master.cities);
	var city = ds_list_find_value(obj_master.cities, irandom_range(0, num - 1));
	return ds_map_find_value(city, "uid");
}

function s_get_hometown_name(_arg0) {
	var uid = ds_map_find_value(_arg0, "hometown");
	var city = s_get_hometown_from_uid(uid);
	return ds_map_find_value(city, "city") + ", " + ds_map_find_value(city, "state");
}

function s_get_only_hometown_name(_arg0) {
	var uid = ds_map_find_value(_arg0, "hometown");
	var city = s_get_hometown_from_uid(uid);
	return ds_map_find_value(city, "city");
}

function s_get_only_state_name(_arg0) {
	var uid = ds_map_find_value(_arg0, "hometown");
	var city = s_get_hometown_from_uid(uid);
	return ds_map_find_value(city, "state");
}

function s_get_hometown_from_uid(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.cities); i++) {
		var city = ds_list_find_value(obj_master.cities, i);
		if (ds_map_find_value(city, "uid") == _arg0) {
			return city;
		}
	}
	return undefined;
}

function s_pick_rand_epilogue_uid(_arg0) {
	var list = ds_list_create();
	for (var i = 0; i < ds_list_size(obj_master.epilogue); i++) {
		var entry = ds_list_find_value(obj_master.epilogue, i);
		if (ds_map_find_value(entry, "token") == _arg0) {
			ds_list_add(list, ds_map_find_value(entry, "uid"));
		}
	}
	var res = -4;
	if (ds_list_size(list) > 0) {
		var pick = irandom_range(0, ds_list_size(list) - 1);
		res = ds_list_find_value(list, pick);
	}
	ds_list_destroy(list);
	return res;
}

function s_get_epilogue_name(_arg0, _arg1) {
	var fallback = -4;
	for (var i = 0; i < ds_list_size(obj_master.epilogue); i++) {
		var entry = ds_list_find_value(obj_master.epilogue, i);
		if (ds_map_find_value(entry, "token") == _arg0) {
			fallback = entry;
			if (ds_map_find_value(entry, "uid") == _arg1) {
				return ds_map_find_value(entry, "value");
			}
		}
	}
	if (fallback != -4) {
		return ds_map_find_value(fallback, "value");
	}
	return "UNKNOWN";
}

function s_epilogue_tests() {
	if (obj_master.epilogue == -4) {
		return;
	}
	slog("EPILOGUE TESTS");
	var res = "";
	var epi_cutStory = s_pick_epilogue_story("epi_cut");
	slog("epi_cutStory[" + epi_cutStory + "]");
	res = s_epilogue_story_to_str(epi_cutStory);
	slog(res);
	var epi_graduatedStory1 = s_pick_epilogue_story("epi_graduated");
	slog("epi_graduatedStory1[" + epi_graduatedStory1 + "]");
	res = s_epilogue_story_to_str(epi_graduatedStory1);
	slog(res);
	var epi_graduatedStory2 = s_pick_epilogue_story("epi_graduated");
	slog("epi_graduatedStory2[" + epi_graduatedStory2 + "]");
	res = s_epilogue_story_to_str(epi_graduatedStory2);
	slog(res);
}

function s_pick_epilogue_story(_arg0) {
	if (!s_is_co_mode()) {
		return "";
	}
	if (s_college_academics_type("Military")) {
		_arg0 = "epiMilitary_" + string_delete(_arg0, 1, 4);
	}
	var file = file_text_open_read(s_select_override_lang_file());
	if (file == -1) {
		return;
	}
	var list = ds_list_create();
	while (!file_text_eof(file)) {
		var txt = file_text_read_string(file);
		file_text_readln(file);
		if (string_count(_arg0, txt)) {
			var pos = string_pos("\t", txt);
			txt = string_copy(txt, 1, pos - 1);
			ds_list_add(list, txt);
		}
	}
	file_text_close(file);
	var locKey = "";
	if (ds_list_size(list) > 0) {
		var pick = irandom_range(0, ds_list_size(list) - 1);
		locKey = ds_list_find_value(list, pick);
	}
	ds_list_destroy(list);
	if (locKey == "") {
		return "";
	}
	var locStr = s_str(locKey);
	var epi_tokens = ds_list_create();
	for (var i = 0; i < ds_list_size(obj_master.epilogue); i++) {
		var entry = ds_list_find_value(obj_master.epilogue, i);
		if (ds_list_find_index(epi_tokens, ds_map_find_value(entry, "token")) == -1) {
			ds_list_add(epi_tokens, ds_map_find_value(entry, "token"));
		}
	}
	var param = "";
	for (var i = 0; i < ds_list_size(epi_tokens); i++) {
		var tok = ds_list_find_value(epi_tokens, i);
		if (string_pos(tok, locStr) == 0) {
			continue;
		}
		var paramUID = s_pick_rand_epilogue_uid(tok);
		param = "|" + paramUID;
		slog("s_pick_epilogue_story picked for tag[" + _arg0 + "] with token[" + tok + "] the param[" + paramUID + "] which is [" + s_get_epilogue_name(tok, paramUID) + "]");
		break;
	}
	ds_list_destroy(epi_tokens);
	return locKey + param;
}

function s_epilogue_story_to_str(_arg0) {
	if (_arg0 == "") {
		return "";
	}
	var sep_pos = string_pos("|", _arg0);
	if (sep_pos == 0) {
		return s_str(_arg0);
	}
	var locKey = string_copy(_arg0, 1, sep_pos - 1);
	var paramUID = string_copy(_arg0, sep_pos + 1, string_length(_arg0));
	var locStr = s_str(locKey);
	var hc_map = s_get_staff(100);
	if (hc_map) {
		locStr = string_replace_all(locStr, "$headcoachlastname", ds_map_find_value(hc_map, "lname"));
		locStr = string_replace_all(locStr, "$headcoachname", ds_map_find_value(hc_map, "fname") + " " + ds_map_find_value(hc_map, "lname"));
	}
	var epi_tokens = ds_list_create();
	for (var i = 0; i < ds_list_size(obj_master.epilogue); i++) {
		var entry = ds_list_find_value(obj_master.epilogue, i);
		if (ds_list_find_index(epi_tokens, ds_map_find_value(entry, "token")) == -1) {
			ds_list_add(epi_tokens, ds_map_find_value(entry, "token"));
		}
	}
	for (var i = 0; i < ds_list_size(epi_tokens); i++) {
		var tok = ds_list_find_value(epi_tokens, i);
		if (string_pos(tok, locStr) == 0) {
			continue;
		}
		var paramStr = s_get_epilogue_name(tok, real(paramUID));
		locStr = string_replace_all(locStr, "$" + tok, paramStr);
		break;
	}
	ds_list_destroy(epi_tokens);
	return locStr;
}

function s_add_cv_entry_from_key(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = -1;
	}
	if (!s_is_co_mode()) {
		return;
	}
	if (s_college_academics_type("Military")) {
		_arg1 = "cvMilitary_" + string_delete(_arg1, 1, 3);
	}
	slog("s_add_cv_entry_from_key player[" + ds_map_find_value(_arg0, "lname") + "] cv[" + _arg1 + "] previous[" + ds_map_find_value(_arg0, "curriculum_vitae") + "]");
	var award_txt = s_str(s_get_random_cv_entry(_arg0, _arg1));
	award_txt = s_parse_player_message(award_txt, _arg0);
	s_add_cv_entry_direct(_arg0, award_txt, _arg2);
}

function s_add_cv_entry_direct(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = -1;
	}
	if (!s_is_co_mode()) {
		return;
	}
	if (_arg2 == -1) {
		_arg2 = obj_master.start_year + obj_master.year;
	}
	var msg = "";
	if (_arg1 != "") {
		msg = string(_arg2) + "-" + _arg1;
	}
	if (string_length(ds_map_find_value(_arg0, "curriculum_vitae")) > 0) {
		msg = "|" + msg;
	}
	slog("s_add_cv_entry_direct player[" + ds_map_find_value(_arg0, "lname") + "] award_txt[" + _arg1 + "] previous[" + ds_map_find_value(_arg0, "curriculum_vitae") + "]");
	ds_map_set(_arg0, "curriculum_vitae", ds_map_find_value(_arg0, "curriculum_vitae") + msg);
}

function s_get_random_cv_entry(_arg0, _arg1) {
	var res = s_extract_cv_entry_from_pool(_arg0, _arg1);
	if (res != "") {
		slog("s_get_random_cv_entry.1: Existing list [" + string(res) + "]");
		return res;
	}
	slog("Repopulate curriculum vitate tags...");
	var ignore_pattern = "_news";
	s_add_tag_matches_to_list(obj_master.curriculum_tags, _arg1, s_select_lang_file(), ignore_pattern);
	s_add_tag_matches_to_list(obj_master.curriculum_tags, _arg1, s_select_override_lang_file(), ignore_pattern);
	var res = s_extract_cv_entry_from_pool(_arg0, _arg1);
	if (res != "") {
		slog("s_get_random_cv_entry.2: Fresh list [" + string(res) + "]");
		return res;
	}
	slog("s_get_random_cv_entry.3: Failed");
	return "";
}

function s_extract_cv_entry_from_pool(_arg0, _arg1) {
	for (var i = ds_list_size(obj_master.curriculum_tags) - 1; i >= 0; i--) {
		var str = ds_list_find_value(obj_master.curriculum_tags, i);
		if (string_count(_arg1, str)) {
			ds_list_delete(obj_master.curriculum_tags, i);
			return str;
		}
	}
	return "";
}

function s_set_cv_list_from_player(_arg0) {
	for (var i = 0; i < ds_list_size(obj_master.player_cv); i++) {
		ds_map_destroy(ds_list_find_value(obj_master.player_cv, i));
	}
	ds_list_clear(obj_master.player_cv);
	if (ds_map_exists(_arg0, "curriculum_vitae") == false || string_length(ds_map_find_value(_arg0, "curriculum_vitae")) == 0) {
		s_add_cv_list_entry(s_str("ui_No_Awards"));
	} else {
		var cv_string = ds_map_find_value(_arg0, "curriculum_vitae");
		slog("s_set_cv_list_from_player [" + cv_string + "]");
		var achievements = string_split(cv_string, "|");
		for (var i = array_length_1d(achievements) - 1; i >= 0; i--) {
			var achievement_chunks = split_into_chunks(achievements[i], 55);
			for (var j = 0; j < array_length_1d(achievement_chunks); j++) {
				s_add_cv_list_entry(achievement_chunks[j]);
			}
		}
	}
	s_add_cv_list_entry("");
	s_add_cv_list_entry(s_str("cv_InterestsTitle"));
	s_add_cv_list_entry(s_get_hobby_name(_arg0, true));
	s_add_cv_list_entry(ds_map_find_value(_arg0, "curriculum_interest"));
}

function s_add_cv_list_entry(_arg0) {
	var entry_cv = ds_map_create();
	ds_map_set(entry_cv, "tag", "");
	ds_map_set(entry_cv, "description", _arg0);
	ds_map_set(entry_cv, "achieved", 1);
	ds_list_add(obj_master.player_cv, entry_cv);
}

function split_into_chunks(_arg0, _arg1) {
	var chunks = [];
	var start_index = 0;
	while (start_index < string_length(_arg0)) {
		var end_index = start_index + _arg1;
		if (end_index > string_length(_arg0)) {
			end_index = string_length(_arg0);
		} else {
			while (string_char_at(_arg0, end_index) != " " && end_index > start_index) {
				end_index--;
			}
			if (end_index == start_index) {
				end_index = start_index + _arg1;
			}
		}
		var chunk = string_copy(_arg0, start_index + 1, end_index - start_index);
		if (array_length_1d(chunks) > 0) {
			chunk = "     " + chunk;
		}
		chunks[array_length_1d(chunks)] = chunk;
		start_index = end_index;
	}
	return chunks;
}

function btn_response_player_meeting_academic_coaching() {
	s_msg_clear();
	with (obj_master) {
		ds_map_set(player_profile, "meetingdone", 1);
		var meetcost = s_get_meeting_cost_extend_contract(player_profile);
		ds_map_set(map_options, "op_credits_purchased", max(ds_map_find_value(map_options, "op_credits_purchased") - meetcost, 0));
		coach_credit -= meetcost;
		if (coach_credit < 0) {
			coach_credit = 0;
		}
		var newGrade = real(ds_map_find_value(player_profile, "percent_grade")) + 10;
		if (newGrade > 100) {
			newGrade = 100;
		}
		ds_map_set(player_profile, "percent_grade", newGrade);
		s_refresh_suspended(player_profile, false);
		s_clear_party_meter(player_profile);
		s_savegame();
		room_goto(rm_profile_player);
	}
}

function s_get_meeting_cost_academic_coaching(_arg0) {
	var pmap = _arg0;
	var grade = ds_map_find_value(pmap, "percent_grade");
	if (grade <= 72) {
		return 4;
	}
	if (grade <= 79) {
		return 3;
	}
	if (grade <= 86) {
		return 2;
	}
	if (grade <= 94) {
		return 1;
	}
	return 0;
}

function s_is_co_mode() {
	return 1;
}

function s_is_co_postseason(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.week;
	}
	return s_is_co_mode() && _arg0 >= obj_master.first_week_postseason;
}

function s_is_co_actual_postseason(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.week;
	}
	return s_is_co_mode() && _arg0 >= obj_master.first_week_postseason + obj_master.extra_weeks_endofseason;
}

function s_get_postseason_chunk(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.week;
	}
	if (_arg0 < obj_master.first_week_postseason) {
		return 0;
	}
	return _arg0 - obj_master.first_week_postseason + 1;
}

function s_is_earlier_than(_arg0) {
	return obj_master.week < _arg0;
}

function s_get_skip_to_week() {
	if (s_is_co_mode()) {
		return obj_master.last_week_regular;
	}
	return 18;
}

function s_is_co_team(_arg0) {
	if (_arg0 && ds_map_find_value(_arg0, "uid") >= 32) {
		return true;
	}
	return false;
}

function s_get_conference_list(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = true;
	}
	var cl = [];
	for (var i = 0; i < array_length(obj_master.conferences); i++) {
		if (obj_master.conferences[i].tier == _arg0) {
			if (!_arg1 || _arg1 && real(obj_master.conferences[i].active)) {
				array_push(cl, obj_master.conferences[i]);
			}
		}
	}
	return cl;
}

function s_get_team_list_by_tier(_arg0) {
	var tl = [];
	for (var i = 0; i < ds_list_size(obj_master.teamlist); i++) {
		var team = ds_list_find_value(obj_master.teamlist, i);
		if (s_get_subdivision(team) == _arg0) {
			array_push(tl, team);
		}
	}
	return tl;
}

function s_get_team_list(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = -4;
	}
	var tl = [];
	for (var i = 0; i < ds_list_size(obj_master.teamlist); i++) {
		var team = ds_list_find_value(obj_master.teamlist, i);
		if (ds_map_find_value(team, "conference") == _arg0 && (ds_map_find_value(team, "division") == _arg1 || _arg1 == -4)) {
			array_push(tl, team);
		}
	}
	return tl;
}

function s_count_joboffers_conference(_arg0) {
	var tl = s_get_team_list(_arg0.uid);
	var count = 0;
	for (var i = 0; i < array_length(tl); i++) {
		if (s_team_interested(tl[i])) {
			count++;
		}
	}
	return count;
}

function s_co_get_year() {
	with (obj_master) {
		return start_year + year;
	}
}

function s_get_my_conference_uid() {
	return ds_map_find_value(obj_master.myteam, "conference");
}

function s_get_my_conference_data() {
	return s_get_struct_in_array_by_uid(obj_master.conferences, s_get_my_conference_uid());
}

function s_get_conference_data(_arg0) {
	return s_get_struct_in_array_by_uid(obj_master.conferences, _arg0);
}

function s_get_my_division() {
	return ds_map_find_value(obj_master.myteam, "division");
}

function s_get_subdivision(_arg0) {
	var conference = s_get_struct_in_array_by_uid(obj_master.conferences, ds_map_find_value(_arg0, "conference"));
	return conference != -4 ? conference.tier : -4;
}

function s_get_team_pct_cnf(_arg0) {
	var wins = real(ds_map_find_value(_arg0, "wins_cnf"));
	var losses = real(ds_map_find_value(_arg0, "losses_cnf"));
	var games = wins + losses;
	if (games > 0) {
		return wins / games;
	}
	return 0;
}

function s_is_independent_team(_arg0) {
	var conf = s_get_conference_data(ds_map_find_value(_arg0, "conference"));
	return s_is_independent_conference(conf);
}

function s_is_independent_conference_id(_arg0) {
	var conf = s_get_conference_data(_arg0);
	return s_is_independent_conference(conf);
}

function s_is_independent_conference(_arg0) {
	if (_arg0 != -4 && _arg0.prestige == 0) {
		return true;
	}
	return false;
}

function s_is_co_bowl_week(_arg0) {
	if (!s_is_co_mode()) {
		return false;
	}
	var fix = s_get_player_schedule_fixture_by_week(_arg0);
	return s_is_co_bowl_fix(fix);
}

function s_is_co_bowl_fix(_arg0) {
	if (!s_is_co_mode() || _arg0 == -4) {
		return false;
	}
	var comp = s_get_competition(ds_map_find_value(_arg0, "cid"));
	if (s_is_co_bowl_comp(comp)) {
		if (is_string(ds_map_find_value(_arg0, "mid")) && ds_map_find_value(_arg0, "mid") != "" && ds_map_find_value(_arg0, "mid") != "1.01") {
			return false;
		}
		return true;
	}
	return false;
}

function s_is_co_bowl_comp(_arg0) {
	if (!s_is_co_mode()) {
		return false;
	}
	if (!_arg0) {
		return false;
	}
	if (is_string(_arg0.city) && _arg0.city != "") {
		return true;
	}
	return false;
}

function s_get_object_data(_arg0) {
	return {
	object: _arg0.object_index,
	sprite: _arg0.sprite_index,
	layer: _arg0.layer,
	x: _arg0.x,
	y: _arg0.y,
	xs: _arg0.image_xscale,
	ys: _arg0.image_yscale,
	w: _arg0.sprite_width,
	h: _arg0.sprite_height
};
}

function s_get_map(_arg0, _arg1, _arg2) {
	if (_arg0 == -4) {
		return _arg2;
	}
	if (ds_exists(_arg0, 1) == false) {
		return _arg2;
	}
	var value = ds_map_find_value(_arg0, _arg1);
	if (is_undefined(value)) {
		return _arg2;
	}
	return value;
}

function s_get_map_real(_arg0, _arg1, _arg2) {
	if (_arg0 == -4) {
		return _arg2;
	}
	if (ds_exists(_arg0, 1) == false) {
		return _arg2;
	}
	var value = ds_map_find_value(_arg0, _arg1);
	if (is_undefined(value)) {
		return _arg2;
	}
	return real(value);
}

function s_map_swap(_arg0, _arg1, _arg2) {
	if (_arg0 == -4) {
		return;
	}
	var temp = ds_map_find_value(_arg0, _arg1);
	ds_map_set(_arg0, _arg1, ds_map_find_value(_arg0, _arg2));
	ds_map_set(_arg0, _arg2, temp);
}

function s_get_save_slot() {
	return ds_map_find_value(obj_master.map_options, "saveslot");
}

function s_get_week_name(_arg0, _arg1) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.week;
	}
	if (_arg1 == undefined) {
		_arg1 = false;
	}
	var chunk = s_get_postseason_chunk(_arg0);
	if (_arg1) {
		switch (chunk) {
			case 0:
				return s_strf("W%1", _arg0);
			case 1:
			case 2:
				return s_strf("ES%1", chunk);
			default:
				return s_strf("PS%1", chunk - 2);
		}
	} else {
		switch (chunk) {
			case 0:
				return s_strf("%1 %2", s_str("ui_Week"), _arg0);
			case 1:
			case 2:
				return s_strf("%1 %2", s_str("ui_SeasonEnd"), chunk);
			default:
				return s_strf("%1 %2", s_str("ui_Postseason"), chunk - 2);
		}
	}
}

function s_get_my_conference_division_string(_arg0, _arg1, _arg2) {
	if (_arg2 == undefined) {
		_arg2 = false;
	}
	slog("s_get_my_conference_division_string conferences size: " + string(array_length_1d(obj_master.conferences)));
	var conference = s_get_struct_in_array_by_uid(obj_master.conferences, _arg0);
	if (conference == -4) {
		slog("error! conference not found! for _conference " + string(_arg0) + " and _division " + string(_arg1));
	}
	var cnf_name = _arg2 ? conference.tla : conference.name;
	if (conference.divisions < 2) {
		return cnf_name;
	}
	if (_arg1 == 0) {
		return cnf_name + " " + conference.div_0_name;
	} else {
		return cnf_name + " " + conference.div_1_name;
	}
}

function s_get_fix_competition_string(_arg0) {
	if (_arg0 == -4) {
		return -4;
	}
	return s_get_competition_string(ds_map_find_value(_arg0, "cid"));
}

function s_get_competition_string(_arg0) {
	var comp = s_get_competition(_arg0);
	if (comp != -4) {
		return s_strf("%1 %2", s_co_get_year(), comp.name);
	}
	return -4;
}

function s_get_fix_location_string(_arg0) {
	var comp = s_get_competition(ds_map_find_value(_arg0, "cid"));
	if (s_is_co_bowl_fix(_arg0)) {
		return s_strfl("%1, %2", comp.city, comp.state);
	}
	if (ds_map_find_value(_arg0, "home_team") == -1) {
		return "";
	}
	return s_str("tla_at") + " " + s_get_team_name_by_id(ds_map_find_value(_arg0, "home_team"));
}

function s_get_my_subdivision_string(_arg0) {
	return s_get_subdiv_name(_arg0.tier);
}

function s_get_subdiv_name(_arg0) {
	if (s_custom_data_exists()) {
		return s_get_custom_data_subdivision(_arg0).name;
	}
	switch (real(_arg0)) {
		case 1:
			return s_str("ui_Major");
		case 2:
			return s_str("ui_Minor");
	}
	return "N/A";
}

function s_joboffers_string(_arg0) {
	switch (_arg0) {
		case 0:
			return s_str("ui_NoOffers");
		case 1:
			return s_str("ui_OneOffer");
		default:
			return string(_arg0) + " " + s_str("ui_Offers");
	}
}

function s_get_pct_string(_arg0) {
	var pct_s = string_format(_arg0, 0, 3);
	pct_s = string_replace(pct_s, "0.", ".");
	return pct_s;
}

function s_get_comp_level_str(_arg0) {
	switch (real(_arg0)) {
		case 1:
			return s_str("ui_TheFinal");
		case 2:
			return s_str("ui_TheSemiFinals");
		case 3:
			return s_str("ui_TheQuarterFinals");
		case 4:
			return s_str("ui_Round2");
		case 5:
			return s_str("ui_Round1");
	}
	return "-";
}

function s_get_comp_level_str_plain(_arg0) {
	switch (real(_arg0)) {
		case 1:
			return s_str("ui_Final");
		case 2:
			return s_str("ui_SemiFinal");
		case 3:
			return s_str("ui_QuarterFinal");
		case 4:
			return s_str("ui_Round2");
		case 5:
			return s_str("ui_Round1");
	}
	return "-";
}

function s_get_difficulty_str(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = obj_master.op_difficulty;
	}
	return s_str(s_strfl("ui_Difficulty%1", _arg0));
}

function s_is_ps_chunk_filled(_arg0) {
	with (obj_master) {
		var fix;
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			if (real(ds_map_find_value(fix, "week")) == _arg0 && !s_is_fix_filled(fix)) {
				return false;
			}
		}
	}
	return true;
}

function s_is_week_played(_arg0) {
	_arg0 = real(_arg0);
	with (obj_master) {
		var fix;
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			if (real(ds_map_find_value(fix, "week")) == _arg0 && !s_is_fix_played(fix)) {
				return false;
			}
		}
	}
	return true;
}

function s_is_human_in_week(_arg0) {
	_arg0 = real(_arg0);
	with (obj_master) {
		var fix;
		for (var i = 0; i < ds_list_size(schedule); i++) {
			fix = ds_list_find_value(schedule, i);
			if (real(ds_map_find_value(fix, "week")) == _arg0 && s_is_human_fix(fix)) {
				return true;
			}
		}
	}
	return false;
}

function s_is_human_fix(_arg0) {
	var id1, id2;
	with (obj_master) {
		id1 = real(ds_map_find_value(_arg0, "away_team"));
		id2 = real(ds_map_find_value(_arg0, "home_team"));
		if (id1 == myteam_id || id2 == myteam_id) {
			return true;
		}
	}
	return false;
}

function s_get_next_college_human_fixture() {
	var fix, next_fix = -4;
	for (var f = 0; f < ds_list_size(obj_master.fixturelist); f++) {
		fix = ds_list_find_value(obj_master.fixturelist, f);
		if (fix && ds_map_find_value(fix, "human_win") == "unplayed") {
			if (next_fix == -4 || next_fix != -4 && real(ds_map_find_value(fix, "week")) < real(ds_map_find_value(next_fix, "week"))) {
				next_fix = fix;
			}
		}
	}
	return next_fix;
}

function s_update_week_done() {
	global.g_m.week_done = s_is_week_played(global.g_m.week);
}

function s_is_week_done(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = false;
	}
	if (_arg0) {
		s_update_week_done();
	}
	return global.g_m.week_done;
}

function s_is_fix_played(_arg0) {
	return !(real(ds_map_find_value(_arg0, "away_score")) < 0 || real(ds_map_find_value(_arg0, "home_score")) < 0);
}

function s_is_fix_filled(_arg0) {
	return !(real(ds_map_find_value(_arg0, "away_team")) < 0 || real(ds_map_find_value(_arg0, "home_team")) < 0);
}

function s_is_fix_on_neutral_ground(_arg0) {
	var comp = s_get_competition(s_get_map_real(_arg0, "cid", -1));
	if (comp == -4) {
		return false;
	}
	if (is_string(comp.city) && comp.city != "") {
		return true;
	}
	return false;
}

function s_season_competitions_done() {
	return s_is_week_played(s_get_last_schedule_week());
}

function s_get_fix_away_team_id(_arg0) {
	if (_arg0 != -4) {
		return real(ds_map_find_value(_arg0, "away_team"));
	}
	return -1;
}

function s_get_fix_home_team_id(_arg0) {
	if (_arg0 != -4) {
		return real(ds_map_find_value(_arg0, "home_team"));
	}
	return -1;
}

function s_get_fix_by_competition_id(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = obj_master.schedule;
	}
	var fix;
	for (var i = 0; i < ds_list_size(_arg1); i++) {
		fix = ds_list_find_value(_arg1, i);
		if (ds_map_find_value(fix, "cid") == _arg0) {
			return fix;
		}
	}
	return -4;
}

function s_get_fix_by_match_id(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = obj_master.schedule;
	}
	var fix;
	for (var i = 0; i < ds_list_size(_arg1); i++) {
		fix = ds_list_find_value(_arg1, i);
		if (ds_map_find_value(fix, "mid") == _arg0) {
			return fix;
		}
	}
	return -4;
}

function s_get_fix_winner_id(_arg0) {
	if (!s_is_fix_played(_arg0)) {
		return -1;
	}
	return real(ds_map_find_value(_arg0, "away_score")) > real(ds_map_find_value(_arg0, "home_score")) ? real(ds_map_find_value(_arg0, "away_team")) : real(ds_map_find_value(_arg0, "home_team"));
}

function s_get_fix_by_week_and_teams(_arg0, _arg1, _arg2, _arg3) {
	var fix;
	for (var i = 0; i < ds_list_size(_arg0); i++) {
		fix = ds_list_find_value(_arg0, i);
		if (ds_map_find_value(fix, "week") == _arg1 && s_get_fix_away_team_id(fix) == _arg2 && s_get_fix_home_team_id(fix) == _arg3) {
			return fix;
		}
	}
	return -4;
}

