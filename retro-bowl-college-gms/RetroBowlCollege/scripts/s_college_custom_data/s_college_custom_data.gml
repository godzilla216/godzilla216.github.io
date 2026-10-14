function s_custom_data_file_exists(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	var filename = s_get_custom_data_filename(_arg0);
	return file_exists(filename);
}

function s_custom_data_load(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	var filename = s_get_custom_data_filename(_arg0);
	slogf("Loading custom data from %1", filename);
	var cd = s_load_json(filename);
	if (cd == -4) {
		slogf("no custom data file");
		cd = s_custom_data_template();
	}
	return cd;
}

function s_custom_data_file_delete(_arg0) {
	if (!s_is_co_mode() || !s_custom_data_file_exists(_arg0)) {
		return;
	}
	file_delete(s_get_custom_data_filename(_arg0));
}

function s_custom_data_patch() {
	var conferences_base = load_data_to_struct_array(s_get_versioned_path("Conferences_CO.txt"));
	var competitions_base = load_data_to_struct_array(s_get_versioned_path("Competitions_CO.txt"));
	var ccd, ocd, cfd, uid, em;
	slogf("Patching competition data");
	for (var i = 0; i < array_length(obj_master.conferences); i++) {
		ccd = obj_master.conferences[i];
		bcd = conferences_base[i];
		uid = ccd.uid;
		ced = s_get_custom_data_conference(uid);
		if (ced == -4) {
			ccd.name = bcd.name;
			ccd.tla = bcd.tla;
			ccd.div_0_name = bcd.div_0_name;
			ccd.div_1_name = bcd.div_1_name;
			continue;
		}
		ccd.name = ced.name;
		ccd.tla = ced.tla;
		ccd.div_0_name = ced.div_0_name;
		ccd.div_1_name = ced.div_1_name;
	}
	for (var i = 0; i < array_length(obj_master.competitions); i++) {
		ccd = obj_master.competitions[i];
		bcd = competitions_base[i];
		uid = ccd.uid;
		ced = s_get_custom_data_competition(uid);
		em = s_get_editor_mode_data(ccd.editor_mode);
		if (ced == -4 && em == -4) {
			ccd.name = bcd.name;
			ccd.city = bcd.city;
			ccd.state = bcd.state;
			continue;
		}
		if (em != -4 && em.tag == "cpy") {
			bcd = s_get_competition(em.uid);
			ccd.name = bcd.name;
			ccd.city = bcd.city;
			ccd.state = bcd.state;
			continue;
		}
		if (ced != -4) {
			ccd.name = ced.name;
			ccd.city = ced.city;
			ccd.state = ced.state;
		}
		if (em != -4 && em.tag == "ed" && em.mode == "bowls") {
			ccd.prefix = s_get_custom_data_comp_name_prefix(bcd.name, ced);
			ccd.suffix = s_get_custom_data_comp_name_suffix(bcd.name, ced);
			ccd.name = ccd.prefix + " " + ccd.suffix;
			continue;
		}
		if (em != -4 && em.tag == "ed" && em.mode == "finals") {
			ccd.suffix = s_get_custom_data_comp_name_suffix(bcd.name, ced);
			ccd.name = s_get_subdiv_name(em.uid) + " " + ccd.suffix;
			continue;
		}
		if (em != -4 && em.tag == "ed" && em.mode == "conf_champ") {
			cfd = s_get_conference_data(em.uid);
			ccd.suffix = s_get_custom_data_comp_name_suffix(bcd.name, ced);
			ccd.name = cfd.name + " " + ccd.suffix;
			continue;
		}
	}
}

function s_custom_data_update_from_editor(_arg0) {
	switch (_arg0.mode) {
		case "subdiv":
			if (_arg0.fields.name != "") {
				with (obj_master.custom_data) {
					subdivisions[_arg0.uid].name = _arg0.fields.name.text;
					s_set_custom_data_active(true);
				}
			}
			break;
		case "conf":
			var ccd = s_get_or_create_custom_data_conference(_arg0.conf.uid);
			ccd.name = _arg0.fields.name.text;
			ccd.tla = _arg0.fields.tla.text;
			ccd.div_0_name = _arg0.conf.divisions > 1 ? _arg0.fields.div_0_name.text : "N/A";
			ccd.div_1_name = _arg0.conf.divisions > 1 ? _arg0.fields.div_1_name.text : "N/A";
			s_set_custom_data_active(true);
			break;
		case "bowls":
			var ccd = s_get_or_create_custom_data_competition(_arg0.comp.uid);
			ccd.prefix = _arg0.fields.prefix.text;
			ccd.suffix = _arg0.fields.suffix.text;
			ccd.name = string_join(" ", ccd.prefix, ccd.suffix);
			if (_arg0.fields.neutral.state) {
				ccd.city = _arg0.fields.city.text;
				ccd.state = _arg0.fields.state.text;
			} else {
				ccd.city = "";
				ccd.state = "";
			}
			s_set_custom_data_active(true);
			break;
		case "finals":
		case "conf_champ":
			var ccd = s_get_or_create_custom_data_competition(_arg0.comp.uid);
			ccd.name = _arg0.fields.name.text;
			ccd.suffix = _arg0.fields.suffix.text;
			if (_arg0.fields.neutral.state) {
				ccd.city = _arg0.fields.city.text;
				ccd.state = _arg0.fields.state.text;
			} else {
				ccd.city = "";
				ccd.state = "";
			}
			s_set_custom_data_active(true);
			break;
	}
}

function s_custom_data_save() {
	var filename = s_get_custom_data_filename();
	slogf("Saving custom data to %1", filename);
	if (!s_is_custom_data_active()) {
		slogf("Not saving unchanged custom data");
		return;
	}
	s_save_json(filename, obj_master.custom_data);
}

function s_custom_data_delete() {
	var filename = s_get_custom_data_filename();
	if (file_exists(filename)) {
		slogf("Deleting custom data %1", filename);
		file_delete(filename);
	}
}

function s_custom_data_reset() {
	obj_master.custom_data = s_custom_data_template();
}

function s_custom_data_template() {
	var data = {
		version: 1,
		active: 0,
		subdivisions: [{ name: "N/A" }, { name: s_str("ui_Major") }, { name: s_str("ui_Minor") }],
		conferences: [],
		competitions: []
	};
	return data;
}

function s_custom_data_restore() {
	s_custom_data_delete();
	s_custom_data_reset();
	s_custom_data_patch();
}

function s_custom_data_copy_from(_arg0) {
	obj_master.custom_data = s_custom_data_load(_arg0);
	s_custom_data_delete();
	s_custom_data_save();
	s_custom_data_patch();
}

function s_copy_uniforms_from(_arg0) {
	var filename_src = s_strfl("uniforms_custom_%1.txt", _arg0);
	var filename_dst = s_strfl("uniforms_custom_%1.txt", ds_map_find_value(obj_master.map_options, "saveslot"));
	file_delete(filename_dst);
	if (file_exists(filename_src)) {
		file_copy(filename_src, filename_dst);
	}
	s_copy_teamnames_from_uniform_file(filename_dst);
}

function s_college_restore_all_uniforms() {
	var filename = s_strfl("uniforms_custom_%1.txt", ds_map_find_value(obj_master.map_options, "saveslot"));
	if (file_exists(filename)) {
		file_delete(filename);
	}
	s_copy_teamnames_from_uniform_file(s_uniforms_default_file());
}

function s_custom_data_exists() {
	return is_struct(obj_master.custom_data);
}

function s_is_custom_data_active() {
	return is_struct(obj_master.custom_data) && obj_master.custom_data.active;
}

function s_set_custom_data_active(_arg0) {
	obj_master.custom_data.active = _arg0;
}

function s_get_custom_data_subdivision(_arg0) {
	return obj_master.custom_data.subdivisions[_arg0];
}

function s_get_custom_data_conference(_arg0) {
	return s_get_struct_in_array_by_uid(obj_master.custom_data.conferences, _arg0);
}

function s_get_custom_data_competition(_arg0) {
	return s_get_struct_in_array_by_uid(obj_master.custom_data.competitions, _arg0);
}

function s_get_custom_data_filename(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	if (_arg0 == -4) {
		_arg0 = ds_map_find_value(obj_master.map_options, "saveslot");
	}
	return s_strfl("rb_save_%1.json", _arg0);
}

function s_get_or_create_custom_data_conference(_arg0) {
	var ccd = s_get_custom_data_conference(_arg0);
	if (ccd == -4) {
		ccd = { uid: _arg0 };
		array_push(obj_master.custom_data.conferences, ccd);
	}
	return ccd;
}

function s_get_or_create_custom_data_competition(_arg0) {
	var ccd = s_get_custom_data_competition(_arg0);
	if (ccd == -4) {
		ccd = { uid: _arg0 };
		array_push(obj_master.custom_data.competitions, ccd);
	}
	return ccd;
}

function s_get_custom_data_suffix(_arg0) {
	if (_arg0 != -4) {
		return _arg0.suffix;
	} else {
		return s_str("ui_Championship");
	}
}

function s_get_custom_data_comp_name_prefix(_arg0, _arg1) {
	if (_arg1 != -4) {
		return _arg1.prefix;
	} else {
		return array_get(s_get_bowl_split_name(_arg0), 0);
	}
}

function s_get_custom_data_comp_name_suffix(_arg0, _arg1) {
	if (_arg1 != -4) {
		return _arg1.suffix;
	} else {
		return array_get(s_get_bowl_split_name(_arg0), 1);
	}
}

function s_get_bowl_split_name(_arg0) {
	var np = string_split(_arg0, " ", true, 4);
	switch (array_length(np)) {
		case 1:
			array_push(np, "");
			return np;
		case 2:
			return np;
		case 3:
			np[0] = string_join(" ", np[0], np[1]);
			array_delete(np, 1, 1);
			return np;
		default:
			np[0] = string_join(" ", np[0], np[1], np[2]);
			array_delete(np, 1, 2);
			return np;
	}
}

