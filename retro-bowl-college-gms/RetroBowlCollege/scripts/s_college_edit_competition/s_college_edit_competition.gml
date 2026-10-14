function s_rm_edit_competition_init() {
	s_init_rm();
	s_create_title(s_str("ui_Editor"), undefined, true);
	var comp, conf;
	switch (ed_obj) {
		case 1:
			em = { tag: "ed", mode: "subdiv", uid: uid };
			s_editor_create_competition_fields(em);
			break;
		case 2:
			conf = s_get_conference_data(uid);
			if (conf == -4) {
				break;
			}
			em = { tag: "ed", mode: "conf", conf: conf };
			s_editor_create_competition_fields(em);
			break;
		case 3:
			comp = s_get_competition(uid);
			em = s_get_editor_mode_data(comp.editor_mode);
			if (em == -4 || em.tag != "ed") {
				break;
			}
			em.comp = comp;
			s_editor_create_competition_fields(em);
			break;
	}
	btn_cancel = s_create_button(99, 232, { text: s_str("ui_Cancel"), onClickAction: s_btn_edit_comp_cancel, image_xscale: 2.8125 });
	btn_confirm = s_create_button(287, 232, { text: s_str("ui_Confirm"), onClickAction: s_btn_edit_comp_confirm, image_xscale: 2.8125 });
}

function s_btn_edit_comp_confirm() {
	s_custom_data_update_from_editor(global.rm.em);
	s_custom_data_save();
	s_custom_data_patch();
	s_goto_room(rm_editor, s_get_editor_status());
}

function s_btn_edit_comp_cancel() {
	s_goto_room(rm_editor, s_get_editor_status());
}

function s_editor_create_competition_fields(_arg0) {
	var max_chars_subdiv_name = 12;
	var max_chars_conf_name = 12;
	var max_chars_conf_tla = 4;
	var max_chars_conf_division = 6;
	var max_chars_city = 16;
	var max_chars_state = 2;
	var max_chars_bowl_name = 12;
	var max_chars_comp_suffix = 12;
	if (_arg0.tag != "ed") {
		return -4;
	}
	_arg0.fields = {};
	switch (_arg0.mode) {
		case "subdiv":
			s_editor_create_text_field(_arg0.fields, "name", 180, 60, s_get_subdiv_name(_arg0.uid), s_str("ui_Subdivision"), max_chars_subdiv_name);
			break;
		case "conf":
			s_editor_create_text_field(_arg0.fields, "name", 180, 60, _arg0.conf.name, s_str("ui_Conference"), max_chars_conf_name);
			s_editor_create_text_field(_arg0.fields, "tla", 180, 84, _arg0.conf.tla, s_str("ui_ShortName"), max_chars_conf_tla);
			if (real(_arg0.conf.divisions) > 1) {
				s_editor_create_text_field(_arg0.fields, "div_0_name", 180, 112, _arg0.conf.div_0_name, s_str("ui_Divisions"), max_chars_conf_division, undefined, undefined, 19);
				s_editor_create_text_field(_arg0.fields, "div_1_name", 180, 136, _arg0.conf.div_1_name, -4, max_chars_conf_division);
			}
			break;
		case "bowls":
			s_editor_create_text_field(_arg0.fields, "prefix", 180, 60, _arg0.comp.prefix, s_str("ui_BowlName"), max_chars_bowl_name, 105);
			s_editor_create_text_field(_arg0.fields, "suffix", 295, 60, _arg0.comp.suffix, -4, max_chars_bowl_name, 105);
			s_editor_create_location_field(_arg0.fields, 180, 84, _arg0.comp.city, _arg0.comp.state, s_str("ui_Location"), max_chars_city, max_chars_state);
			break;
		case "finals":
		case "conf_champ":
			s_editor_create_partial_text_field(_arg0.fields, "name", "suffix", 180, 60, _arg0, s_str("ui_GameName"), max_chars_comp_suffix);
			s_editor_create_location_field(_arg0.fields, 180, 84, _arg0.comp.city, _arg0.comp.state, s_str("ui_Location"), max_chars_city, max_chars_state);
			break;
	}
}

function s_editor_create_text_field(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9) {
	if (_arg6 == undefined) {
		_arg6 = 10;
	}
	if (_arg7 == undefined) {
		_arg7 = 220;
	}
	if (_arg8 == undefined) {
		_arg8 = -12;
	}
	if (_arg9 == undefined) {
		_arg9 = 8;
	}
	var btn = instance_create_layer(_arg2, _arg3, id.layer, obj_input_box, {
		text: _arg4,
		text_orig: _arg4,
		max_length: _arg6,
		image_xscale: _arg7 / 16,
		validate_script: s_editor_field_validate
	});
	if (_arg5 != -4) {
		s_editor_create_field_label(_arg2, _arg3, _arg5, _arg8, _arg9);
	}
	variable_struct_set(_arg0, _arg1, btn);
}

function s_editor_create_partial_text_field(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9) {
	if (_arg7 == undefined) {
		_arg7 = 10;
	}
	if (_arg8 == undefined) {
		_arg8 = -12;
	}
	if (_arg9 == undefined) {
		_arg9 = 8;
	}
	var cd, prefix, suffix;
	switch (_arg5.mode) {
		case "finals":
			prefix = s_get_subdiv_name(_arg5.uid);
			suffix = _arg5.comp.suffix;
			s_create_button(_arg3 - 10, _arg4 - 8, { onClickAction: s_btn_editor_edit_subdivision, uid: _arg5.uid, image: spr_edit, image_only: true }, obj_button_sqr);
			break;
		case "conf_champ":
			cd = s_get_conference_data(_arg5.uid);
			prefix = cd != -4 ? cd.name : "N/A";
			suffix = _arg5.comp.suffix;
			s_create_button(_arg3 - 10, _arg4 - 8, { onClickAction: s_btn_editor_edit_conference, uid: _arg5.uid, image: spr_edit, image_only: true }, obj_button_sqr);
			break;
	}
	s_editor_create_field_label(_arg3, _arg4, _arg6, _arg8, _arg9);
	s_editor_create_field_label(_arg3 + 105, _arg4, prefix, 0, 8);
	var btn = instance_create_layer(_arg3 + 115, _arg4, id.layer, obj_input_box, {
		text: suffix,
		text_orig: suffix,
		max_length: _arg7,
		image_xscale: 6.5625,
		validate_script: s_editor_field_validate
	});
	if (_arg6 != -4) {
		s_editor_create_field_label(_arg3, _arg4, _arg6, _arg8, _arg9);
	}
	variable_struct_set(_arg0, _arg2, btn);
	variable_struct_set(_arg0, _arg1, { text: prefix + " " + btn.text });
}

function s_editor_create_location_field(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6, _arg7, _arg8, _arg9) {
	if (_arg6 == undefined) {
		_arg6 = 16;
	}
	if (_arg7 == undefined) {
		_arg7 = 2;
	}
	if (_arg8 == undefined) {
		_arg8 = -12;
	}
	if (_arg9 == undefined) {
		_arg9 = 8;
	}
	_arg0.city = instance_create_layer(_arg1, _arg2, id.layer, obj_input_box, {
		text: _arg3,
		text_orig: _arg3,
		max_length: _arg6,
		image_xscale: 10.625,
		validate_script: s_editor_field_validate,
		active: s_editor_location_is_neutral(_arg3, _arg4)
	});
	_arg0.state = instance_create_layer(_arg1 + 180, _arg2, id.layer, obj_input_box, {
		text: _arg4,
		text_orig: _arg4,
		max_length: _arg7,
		image_xscale: 2.5,
		validate_script: s_editor_field_validate,
		active: s_editor_location_is_neutral(_arg3, _arg4)
	});
	_arg0.neutral = instance_create_layer(_arg1, _arg2 + 24, id.layer, obj_checkbox, {
		text: s_str_u("ui_NeutralSite"),
		txt_side: 1,
		fields: _arg0,
		state: s_editor_location_is_neutral(_arg3, _arg4),
		onClickAction: s_editor_location_toggle_neutral_state
	});
	s_editor_create_field_label(_arg1, _arg2, _arg5, _arg8, _arg9);
	s_editor_create_field_label(_arg1, _arg2, ",", 177, _arg9);
}

function s_editor_create_field_label(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5) {
	if (_arg3 == undefined) {
		_arg3 = -12;
	}
	if (_arg4 == undefined) {
		_arg4 = 8;
	}
	if (_arg5 == undefined) {
		_arg5 = 2;
	}
	instance_create_layer(_arg0, _arg1, id.layer, obj_blank, {
		action_draw_gui: s_ui_field_label_draw_gui,
		ox: _arg3,
		oy: _arg4,
		text_align: _arg5,
		text: string_upper(_arg2)
	});
}

function s_ui_field_label_draw_gui() {
	draw_set_font(global.fnt_small_flex);
	draw_set_colour(16777215);
	draw_set_halign(text_align);
	draw_hd_text(x + ox, y + oy, text);
	draw_set_halign(0);
}

function s_editor_field_validate() {
	if (text == "") {
		text = text_orig;
	}
}

function s_editor_location_is_neutral(_arg0, _arg1) {
	return _arg0 != "" || _arg1 != "";
}

function s_editor_location_toggle_neutral_state(_arg0) {
	if (!is_undefined(_arg0)) {
		state = _arg0;
	}
	fields.city.active = state;
	fields.state.active = state;
}

function s_get_editor_mode_data(_arg0) {
	var em = string_split(_arg0, ":");
	var eml = array_length(em);
	var emd = {};
	if (eml > 1) {
		emd.tag = em[0];
		switch (em[0]) {
			case "ed":
				emd.mode = em[1];
				emd.uid = eml > 2 ? em[2] : -4;
				break;
			case "cpy":
				emd.uid = em[1];
				break;
		}
	} else {
		return -4;
	}
	return emd;
}

