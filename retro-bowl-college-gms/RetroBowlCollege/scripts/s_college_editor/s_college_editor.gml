function s_rm_editor_init() {
	s_init_rm();
	s_set_var_if_missing("tier", 1);
	if (tier == -4) {
		tier = 1;
	}
	btns = [];
	s_create_title(s_str("ui_TeamEditor"), undefined, true);
	s_create_slot_label(7, 6);
	btn_major = s_create_button(45, 32, { text: s_get_subdiv_name(1), onClickAction: s_btn_editor_major, image_xscale: 3.125 });
	btn_minor = s_create_button(189, 32, { text: s_get_subdiv_name(2), onClickAction: s_btn_editor_minor, image_xscale: 3.125 });
	btn_bowls = s_create_button(333, 32, { text: s_str("ui_Bowls"), onClickAction: s_btn_editor_bowls, image_xscale: 3.125 });
	btn_conf = s_create_button(190, 32, { text: "", onClickAction: -4, colour: global.c_primary, image_xscale: 3.125 });
	btn_back = s_create_button(5, 32, { image: spr_arrowL, onClickAction: s_btn_editor_back });
	btn_major_edit = s_create_button(btn_major.x + btn_major.sprite_width + 0, btn_major.y, { onClickAction: s_btn_editor_edit_subdivision, uid: 1, image: spr_edit, image_only: true }, obj_button_sqr);
	btn_minor_edit = s_create_button(btn_minor.x + btn_minor.sprite_width + 0, btn_minor.y, { onClickAction: s_btn_editor_edit_subdivision, uid: 2, image: spr_edit, image_only: true }, obj_button_sqr);
	btn_conf_edit = s_create_button(btn_conf.x + btn_conf.sprite_width + 0, btn_conf.y, {
		onClickAction: s_btn_editor_edit_conference,
		uid: conference ? conference.uid : -4,
		image: spr_edit,
		image_only: true
	}, obj_button_sqr);
	btn_restore = s_create_button(5, 232, {
		text: s_str("ui_RestoreAllTeams"),
		onClickAction: s_btn_editor_restore_all,
		image_xscale: 2.8125
	});
	btn_done = s_create_button(381, 232, { text: s_str("ui_Done"), onClickAction: s_btn_editor_done, image_xscale: 2.8125 });
	switch (tier) {
		case 1:
		case 2:
			if (conference != -4) {
				s_editor_conference_mode();
			} else {
				s_editor_subdivision_mode();
			}
			break;
		case 3:
			if (group != -4) {
				s_editor_bowls_competition_mode();
			} else {
				s_editor_bowls_group_mode();
			}
			break;
	}
}

function s_goto_editor() {
	if (s_is_co_mode()) {
		s_goto_room(rm_editor, s_get_editor_status());
	} else {
		room_goto(rm_team_editor);
	}
}

function s_btn_editor_done() {
	s_reset_editor_status();
	room_goto(rm_options);
}

function s_btn_editor_major() {
	global.rm.tier = 1;
	s_choose_team_refresh_subdivision();
}

function s_btn_editor_minor() {
	global.rm.tier = 2;
	s_choose_team_refresh_subdivision();
}

function s_btn_editor_bowls() {
	global.rm.tier = 3;
	s_editor_refresh_bowls_groups();
}

function s_btn_editor_back() {
	var back = s_save_editor_status();
	back.conference = -4;
	back.group = -4;
	s_goto_room(current_room, s_get_editor_status());
}

function s_btn_editor_edit_subdivision() {
	s_save_editor_status();
	s_goto_room(rm_edit_competition, { ed_obj: 1, uid: uid });
}

function s_btn_editor_edit_conference() {
	s_save_editor_status();
	s_goto_room(rm_edit_competition, { ed_obj: 2, uid: uid });
}

function s_btn_editor_conference() {
	global.rm.conference = conference;
	s_editor_conference_mode();
}

function s_btn_editor_select_team() {
	obj_master.edit_team = s_get_team_by_id(uid);
	s_save_editor_status();
	room_goto(rm_edit_team);
}

function s_btn_editor_select_bowl_group() {
	global.rm.group = group;
	s_editor_bowls_competition_mode();
}

function s_btn_editor_select_bowl_competition() {
	s_save_editor_status();
	s_goto_room(rm_edit_competition, { ed_obj: 3, uid: uid });
}

function s_save_editor_status() {
	if (current_room == rm_editor) {
		with (global.rm) {
			global.rm_params_save = {
				mode: variable_instance_exists(id, "mode") ? mode : -4,
				tier: variable_instance_exists(id, "tier") ? tier : -4,
				conference: variable_instance_exists(id, "conference") ? conference : -4,
				group: variable_instance_exists(id, "group") ? group : -4
			};
		}
	}
	return global.rm_params_save;
}

function s_get_editor_status() {
	if (variable_global_exists("rm_params_save") && is_struct(global.rm_params_save)) {
		return global.rm_params_save;
	}
	return { mode: 3, tier: -4, conference: -4, group: -4 };
}

function s_reset_editor_status() {
	global.rm_params = -4;
	global.rm_params_save = -4;
}

function s_editor_subdivision_mode() {
	with (global.rm) {
		s_editor_set_buttons(1);
		s_editor_copy_buttons(false);
		s_choose_team_refresh_subdivision();
	}
}

function s_editor_conference_mode() {
	with (global.rm) {
		s_editor_set_buttons(2);
		btn_conf.text = s_fit_string(conference.name, conference.tla, 96);
		btn_conf.colour = global.c_primary;
		btn_conf_edit.uid = conference.uid;
		s_editor_copy_buttons(true);
		s_choose_team_refresh_conference();
	}
}

function s_editor_bowls_group_mode() {
	with (global.rm) {
		s_editor_set_buttons(1);
		s_editor_copy_buttons(false);
		s_editor_refresh_bowls_groups();
	}
}

function s_editor_bowls_competition_mode() {
	with (global.rm) {
		s_editor_set_buttons(2);
		btn_conf.text = s_get_editor_bowl_group_name_by_tag(group);
		s_editor_copy_buttons(true, true);
		s_editor_refresh_bowls_groups(group);
	}
}

function s_editor_set_buttons(_arg0) {
	with (global.rm) {
		btn_major.visible = _arg0 == 1;
		btn_minor.visible = _arg0 == 1;
		btn_bowls.visible = _arg0 == 1;
		btn_back.visible = _arg0 == 2;
		btn_conf.visible = _arg0 == 2;
		btn_major_edit.visible = _arg0 == 1;
		btn_minor_edit.visible = _arg0 == 1;
		btn_conf_edit.visible = _arg0 == 2 && tier != 3;
		btn_restore.visible = _arg0 == 1;
		btn_done.y = _arg0 == 1 ? 232 : 32;
	}
}

function s_editor_refresh_bowls_groups(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	with (global.rm) {
		s_refresh_main_sections_buttons();
		s_destroy_dynamic_buttons(btns);
		btns = s_editor_create_bowls_buttons(_arg0);
	}
}

function s_editor_create_bowls_buttons(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = -4;
	}
	var cb = [];
	var btn, name;
	if (_arg0 == -4) {
		var bl = obj_master.editor.bowls_groups;
		var t = s_calc_grid_coords(array_length(bl), obj_master.editor.bowls_groups_chunks);
		for (var i = 0; i < array_length(bl); i++) {
			btn = s_create_button(t[i].x, t[i].y, {
				text: bl[i].name,
				group: bl[i].tag,
				onClickAction: s_btn_editor_select_bowl_group,
				image_xscale: 3.125
			});
			array_push(cb, btn);
		}
	} else {
		var cl = s_get_competitions_in_editor_group(_arg0);
		var t = s_calc_grid_coords(array_length(cl));
		for (var i = 0; i < array_length(cl); i++) {
			btn = s_create_button(t[i].x, t[i].y, {
				text: cl[i].name,
				uid: cl[i].uid,
				onClickAction: s_btn_editor_select_bowl_competition,
				image_xscale: 3.125
			});
			array_push(cb, btn);
		}
	}
	return cb;
}

function s_create_slot_label(_arg0, _arg1) {
	instance_create_layer(_arg0, _arg1, id.layer, obj_blank, {
		sprite_index: spr_box_flex,
		image_xscale: 4,
		image_yscale: 1.25,
		action_draw_gui: s_ui_label_draw_gui,
		text: s_str("ui_SaveSlot" + string(ds_map_find_value(obj_master.map_options, "saveslot")))
	});
}

function s_ui_label_draw_gui() {
	var tx = x + sprite_width / 2;
	var ty = y + sprite_height / 2;
	draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, 16777215, 1);
	draw_set_font(global.fnt_small_flex);
	draw_set_colour(16777215);
	draw_set_halign(1);
	draw_hd_text(tx, ty, text);
	draw_set_halign(0);
}

function s_get_editor_bowl_group_name_by_tag(_arg0) {
	with (obj_master.editor) {
		for (var i = 0; i < array_length(bowls_groups); i++) {
			if (bowls_groups[i].tag == _arg0) {
				return bowls_groups[i].name;
			}
		}
		return "";
	}
}

function s_editor_copy_buttons(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = false;
	}
	with (global.rm) {
		if (!variable_instance_exists(id, "btn_copy1")) {
			var i = 0;
			btn_copy_1 = s_create_button(5 + 94 * i++, 232, { slot: i + 1, is_bowls: _arg1, onClickAction: s_btn_editor_copy, image_xscale: 2.8125 });
			btn_copy_2 = s_create_button(5 + 94 * i++, 232, { slot: i + 1, is_bowls: _arg1, onClickAction: s_btn_editor_copy, image_xscale: 2.8125 });
			btn_copy_3 = s_create_button(5 + 94 * i++, 232, { slot: i + 1, is_bowls: _arg1, onClickAction: s_btn_editor_copy, image_xscale: 2.8125 });
			btn_copy_4 = s_create_button(5 + 94 * i++, 232, { slot: i + 1, is_bowls: _arg1, onClickAction: s_btn_editor_copy, image_xscale: 2.8125 });
			btn_copy_5 = s_create_button(5 + 94 * i++, 232, { slot: i + 1, is_bowls: _arg1, onClickAction: s_btn_editor_copy, image_xscale: 2.8125 });
		}
		s_init_btn_editor_copy(btn_copy_1, _arg0);
		s_init_btn_editor_copy(btn_copy_2, _arg0);
		s_init_btn_editor_copy(btn_copy_3, _arg0);
		s_init_btn_editor_copy(btn_copy_4, _arg0);
		s_init_btn_editor_copy(btn_copy_5, _arg0);
	}
}

function s_init_btn_editor_copy(_arg0, _arg1) {
	with (_arg0) {
		text = s_str(s_strfl(is_bowls ? "ui_CopyCompsSlot%1" : "ui_CopySlot%1", slot));
		if (ds_map_find_value(obj_master.map_options, "saveslot") == slot) {
			active = false;
			text = s_str("ui_Current");
		}
		if (!file_exists(variable_global_get(s_strfl("g_savename%1", slot))) || !(file_exists(s_strfl("uniforms_custom_%1.txt", slot)) || s_custom_data_file_exists(slot))) {
			active = false;
		}
		visible = _arg1;
	}
}

function s_btn_editor_copy() {
	slogf("Copy button %1 action", slot);
	var str = s_str("msg_CopyUniforms");
	str = string_replace(str, "$num", slot);
	global.rm.clicked_slot = slot;
	s_create_message("", str, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_btn_editor_confirm_copy, global.c_background, 1);
}

function s_btn_editor_confirm_copy() {
	var slot = global.rm.clicked_slot;
	global.rm.clicked_slot = -4;
	slogf("copying from slot: %1", slot);
	s_copy_uniforms_from(slot);
	s_custom_data_copy_from(slot);
	s_msg_clear();
	s_goto_editor();
}

function s_btn_editor_restore_all() {
	s_create_message("", s_str("msg_RestoreAllTeams"), s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, s_btn_editor_confirm_restore_all, global.c_background, 1);
}

function s_btn_editor_confirm_restore_all() {
	s_college_restore_all_uniforms();
	s_custom_data_restore();
	s_msg_clear();
	s_goto_editor();
}

