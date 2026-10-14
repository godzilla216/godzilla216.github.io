function buttons_college_custom() {
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(1);
	var tx = x + sprite_width / 2;
	var ty = y + sprite_height / 2;
	tx += 1;
	ty -= 1;
	if (!active) {
		draw_sprite_ext(sprite_index, 1, x + 2, y - 2, 1, 1, 0, 4210752, 1);
		draw_set_color(4210752);
		draw_custom_increase_wallet(tx, ty, sprite_width, sprite_height);
		draw_set_color(16777215);
	} else if (!clicked) {
		var f = (sin(current_time / 60) + 1) / 2;
		with (obj_msgbg) {
			if (depth < other.depth) {
				f = 0;
			}
		}
		draw_sprite(sprite_index, image_index, x, y);
		if (s_is_ui_selected()) {
			draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, s_ui_selected_color(), 1);
		}
		draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, colour, 1);
		if (flash && f > 0.5) {
			draw_sprite_ext(sprite_index, 2, x, y, 1, 1, 0, global.c_primary, 1);
		}
		if (continue_icon) {
			draw_sprite(continue_icon, 0, x + sprite_width - 8, y + sprite_height * 0.5 - 1);
		}
		draw_custom_increase_wallet(tx, ty, sprite_width, sprite_height);
	} else {
		draw_sprite(sprite_index, image_index, x, y);
		draw_sprite_ext(sprite_index, 2, x - 2, y + 2, 1, 1, 0, colour, 1);
		if (continue_icon) {
			draw_sprite(continue_icon, 0, x + sprite_width - 10, y + sprite_height * 0.5 + 1);
		}
		draw_custom_increase_wallet(tx - 2, ty + 2, sprite_width, sprite_height);
	}
}

function draw_custom_increase_wallet(_arg0, _arg1, _arg2, _arg3) {
	var s1 = string_upper(s_str("ui_increase"));
	var s2 = string_upper(s_str("ui_wallet"));
	var rcw = sprite_get_width(spr_credit_rec);
	var s1H = string_hd_height(s1);
	var s2W = string_hd_width(s2);
	var tx = _arg0;
	var ty = _arg1 - _arg3 / 2 + s1H / 2 + 4;
	draw_hd_text(tx, ty, s1);
	ty += 12;
	draw_sprite(spr_credit_rec, 0, tx - s2W / 2 - rcw / 2, ty);
	draw_hd_text(tx, ty, s2);
}

function draw_custom_recruitment_credits_display(_arg0, _arg1) {
	var tx = _arg0;
	var ty = _arg1;
	draw_set_halign(0);
	var rcw = sprite_get_width(spr_credit_rec);
	var contentTxt = "" + string(obj_master.recruitment_credits) + " ";
	draw_hd_text(tx, ty, contentTxt);
	tx += string_hd_width(contentTxt);
	tx += rcw / 2;
	draw_sprite(spr_credit_rec, 0, tx, ty);
	tx += rcw / 2;
	contentTxt = " / " + string(recruitment_credits_cap_total()) + " ";
	draw_hd_text(tx, ty, contentTxt);
	tx += string_hd_width(contentTxt);
	tx += rcw / 2;
	draw_sprite(spr_credit_rec, 0, tx, ty);
}

function rm_player_profile_show_noncollege_elements(_arg0) {
	inst_100435.visible = _arg0;
	inst_100443.visible = _arg0;
	inst_100441.visible = _arg0;
	inst_100436.visible = _arg0;
	inst_100447.visible = _arg0;
	inst_100448.visible = _arg0;
	inst_100442.visible = _arg0;
	inst_100445.visible = _arg0;
}

function rm_player_profile_show_more(_arg0) {
	var showMore = true;
	if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal() && obj_master.college_admissions_draft_round > 0) {
		showMore = false;
	}
	return showMore;
}

function rm_player_profile_college_create_p1() {
	var tx = 40;
	var ty = 56;
	var c = 0;
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(0);
	draw_set_valign(1);
	if (rm_player_profile_show_more(pmap)) {
		obj_playerprofile_rm.co_page1[c++] = instance_create_layer(176, 152, "Instances", obj_button_thin, { text: s_str("ui_More"), onClickAction: btn_rm_player_profile_college_showP2 });
	}
	obj_playerprofile_rm.co_page1[c++] = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_college_age_label(ds_map_find_value(pmap, "age")), draw_box: false, halign: 0 });
	ty += 12;
	var attitudeText = string_upper(s_str("ui_Attitude") + ": " + s_get_string_attitude(ds_map_find_value(pmap, "attitude")));
	co_attitude = instance_create_layer(tx, ty, "Instances", obj_text, { text: attitudeText, draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page1[c++] = co_attitude;
	x_attitude = co_attitude.x + string_hd_width(co_attitude.text + "  ");
	y_attitude = co_attitude.y;
	var conditionText = string_upper(s_str("ui_Condition") + ": ");
	var co_condition = instance_create_layer(tx, ty, "Instances", obj_text, { text: conditionText, draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page1[c++] = co_condition;
	x_condition = co_condition.x + string_hd_width(conditionText);
	y_condition = co_condition.y;
	x_condition2 = x_condition + string_hd_width(txt_condition + "  ");
	var gpaText = s_str("ui_GPA") + ": ";
	var gpaTextVal = string_format(s_gpa_from_percent_grade(ds_map_find_value(pmap, "percent_grade")), 1, 1);
	var gpaCol = s_player_gpa_color(pmap);
	obj_playerprofile_rm.co_page1[c++] = instance_create_layer(tx, ty, "Instances", obj_text, { text: gpaText, draw_box: false, halign: 0 });
	obj_playerprofile_rm.co_page1[c++] = instance_create_layer(tx + 32, ty, "Instances", obj_text, { text: gpaTextVal, tcolour: s_player_gpa_color(pmap), draw_box: false, halign: 0 });
	if (gpaCol != 16777215) {
		obj_playerprofile_rm.co_page1[c++] = instance_create_layer(tx + 32 - 1, ty + 1, "Instances", obj_text, { text: gpaTextVal, tcolour: 0, draw_box: false, halign: 0 });
	}
	ty += 12;
	var co_rating = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_str("ui_Rating") + ": ", draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page1[c++] = co_rating;
	x_star_rating = co_rating.x + string_hd_width(co_rating.text) + sprite_get_width(spr_star_rating_cb) / 10 * star_rating / 2;
	y_star_rating = co_rating.y;
	var co_potential = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_str("ui_Potential") + ":  ", draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page1[c++] = co_potential;
	x_star_potential = co_potential.x + string_hd_width(co_potential.text) + sprite_get_width(spr_star_rating_cbn) / 10 * star_potential / 2;
	y_star_potential = co_potential.y;
	if (ds_map_find_value(pmap, "suspended")) {
		col_condition = 255;
		i_condition = 4;
	}
}

function rm_player_profile_college_create_p2() {
	var tx = 40;
	var ty = 56;
	var c = 0;
	draw_set_font(global.fnt_small_flex);
	draw_set_halign(0);
	draw_set_valign(1);
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(176, 152, "Instances", obj_button_thin, { text: s_str("ui_Back"), onClickAction: btn_rm_player_profile_college_showP1 });
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_str("ui_Major"), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx + 12, ty, "Instances", obj_text, { text: s_get_major_name(pmap, true), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_str("ui_Minor"), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx + 12, ty, "Instances", obj_text, { text: s_get_minor_name(pmap, true), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_str("ui_OrientationWeek"), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx + 12, ty, "Instances", obj_text, { text: s_get_hobby_name(pmap, true), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx, ty, "Instances", obj_text, { text: s_str("ui_Hometown"), draw_box: false, halign: 0 });
	ty += 12;
	obj_playerprofile_rm.co_page2[c++] = instance_create_layer(tx + 12, ty, "Instances", obj_text, { text: s_get_hometown_name(pmap), draw_box: false, halign: 0 });
	ty += 12;
}

function rm_player_profile_college_create() {
	rm_player_profile_show_noncollege_elements(false);
	rm_player_profile_college_create_p1();
	rm_player_profile_college_create_p2();
	if (obj_master.college_profile_page_num == 2 && rm_player_profile_show_more(pmap)) {
		btn_rm_player_profile_college_showP2();
	} else {
		btn_rm_player_profile_college_showP1();
	}
}

function btn_rm_player_profile_college_showP1() {
	slog("back");
	for (var i = 0; i < array_length(obj_playerprofile_rm.co_page1); i++) {
		obj_playerprofile_rm.co_page1[i].visible = true;
	}
	for (var i = 0; i < array_length(obj_playerprofile_rm.co_page2); i++) {
		obj_playerprofile_rm.co_page2[i].visible = false;
	}
	obj_playerprofile_rm.show_spr_star_rating_cb = true;
	obj_playerprofile_rm.show_spr_star_rating_cbn = true;
	obj_playerprofile_rm.show_spr_attitude = true;
	obj_playerprofile_rm.show_spr_condition = true;
	obj_master.college_profile_page_num = 1;
}

function btn_rm_player_profile_college_showP2() {
	slog("more");
	for (var i = 0; i < array_length(obj_playerprofile_rm.co_page1); i++) {
		obj_playerprofile_rm.co_page1[i].visible = false;
	}
	for (var i = 0; i < array_length(obj_playerprofile_rm.co_page2); i++) {
		obj_playerprofile_rm.co_page2[i].visible = true;
	}
	obj_playerprofile_rm.show_spr_star_rating_cb = false;
	obj_playerprofile_rm.show_spr_star_rating_cbn = false;
	obj_playerprofile_rm.show_spr_attitude = false;
	obj_playerprofile_rm.show_spr_condition = false;
	obj_master.college_profile_page_num = 2;
}

function rm_player_profile_college_step() {
	co_attitude.text = string_upper(s_str("ui_Attitude") + ": " + s_get_string_attitude(ds_map_find_value(pmap, "attitude")));
	x_attitude = co_attitude.x + string_hd_width(co_attitude.text + "  ");
	y_attitude = co_attitude.y;
}

function btn_click_Profile_College_Cut() {
	var pmap = obj_master.player_profile;
	var msg = s_str("msg_CutPlayer");
	var playername = ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
	msg = string_replace(msg, "$playername", playername);
	msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
	s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Cut"), s_msg_clear, btn_response_cut_player_yes, global.c_background, 1);
}

function btn_click_Profile_College_Cut_During_Admission_Draft() {
	var pmap = obj_master.player_profile;
	var msg = s_str("msg_CutPlayerForRC");
	var rc_space = recruitment_credits_space();
	var rc_reward = s_get_college_player_cut_RC(pmap);
	if (rc_space == 0) {
		msg = s_str("msg_CutPlayerForRCWalletFull");
	} else if (rc_reward > rc_space) {
		msg = s_str("msg_CutPlayerForRCWalletFilling");
	}
	var playername = ds_map_find_value(pmap, "fname") + " " + ds_map_find_value(pmap, "lname");
	msg = string_replace(msg, "$playername", playername);
	msg = string_replace(msg, "$position", s_get_string_position_full(ds_map_find_value(pmap, "position")));
	msg = string_replace(msg, "$num", rc_reward);
	s_create_message(s_str("ui_TradePlayer"), msg, s_str("ui_Cancel"), s_str("ui_Cut"), s_msg_clear, btn_response_cut_player_for_RC_yes, global.c_background, 1);
}

function btn_response_cut_player_for_RC_yes() {
	s_msg_clear();
	with (obj_master) {
		var patt = ds_map_find_value(player_profile, "attitude");
		var RC_to_add = s_get_college_player_cut_RC(player_profile);
		recruitment_credits_add(RC_to_add);
		if (current_room == rm_profile_player) {
			var del = s_remove_player(player_profile, "cut", s_pick_epilogue_story("epi_admisscut"));
			if (del) {
				player_profile = -1;
			}
		} else {
			ds_list_delete(roster, ds_list_find_index(roster, player_profile));
			ds_map_destroy(player_profile);
			player_profile = -1;
		}
		s_complete_achievement("ACH_CUT");
		if (patt > 15) {
			s_meter_change(4, s_get_morale(), rm_roster, "");
			var i = -s_get_attitude_icon(patt);
			s_adjust_team_morale_ignore_freshman(i * 2, i);
			if (current_room == rm_profile_player) {
				return;
			}
		}
	}
	room_goto(rm_roster);
}

function s_get_college_player_cut_RC(_arg0) {
	var rc = 0;
	if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal() + 1) {
		rc = 2;
	}
	if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal() + 2) {
		rc = 3;
	}
	if (ds_map_find_value(_arg0, "age") == s_rookie_age_internal() + 3) {
		rc = 4;
	}
	if (ds_map_find_value(_arg0, "position") == 1) {
		rc += 2;
	}
	if (ds_map_find_value(_arg0, "position") == 4) {
		rc += 1;
	}
	if (ds_map_find_value(_arg0, "position") == 2) {
		rc += 1;
	}
	return rc;
}

function btn_rm_stats_player_showAwards() {
	slog("showAwards");
	obj_master.co_stats_tab = 1;
	room_goto(rm_stats_player);
}

function btn_rm_stats_player_showEpilogue() {
	slog("showEpilogue");
	obj_master.co_stats_tab = 2;
	room_goto(rm_stats_player);
}

function stats_player_button_entry(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5) {
	var btn = instance_create_layer(_arg0, _arg1, "Instances", obj_button_9s, { image_xscale: 2.35, text: s_str(_arg2), onClickAction: _arg3 });
	switch (_arg4) {
		case 0:
			if (obj_master.co_stats_tab == _arg4 && obj_master.stat_view == _arg5) {
				btn.colour = global.c_primary;
			}
			break;
		default:
			if (obj_master.co_stats_tab == _arg4) {
				btn.colour = global.c_primary;
			}
	}
}

function rm_stats_player_configure_college() {
	inst_100528.visible = false;
	inst_100527.visible = false;
	inst_100519.visible = false;
	inst_100523.visible = false;
	inst_100520.visible = false;
	inst_100524.visible = false;
	inst_100521.visible = false;
	inst_100525.visible = false;
	inst_100522.visible = false;
	inst_100526.visible = false;
	inst_100529.visible = false;
	inst_100530.visible = false;
	var px = 397;
	var py = 232;
	var deltaX = 81;
	pmap = obj_master.player_profile;
	var inRoster = ds_list_find_index(obj_master.roster, pmap) >= 0;
	var hasLeft = obj_master.viewing_hof_players == true && inRoster == false;
	var hasCurriculumVitae = false;
	if (ds_map_exists(pmap, "curriculum_vitae") && string_length(ds_map_find_value(pmap, "curriculum_vitae")) > 0) {
		hasCurriculumVitae = true;
	}
	var forceShowStatsTab = hasCurriculumVitae || hasLeft;
	var pos = real(ds_map_find_value(pmap, "position"));
	switch (pos) {
		case 1:
			stats_player_button_entry(px, py, "ui_Rushing", btn_click_StatsView2, 0, 2);
			px -= deltaX;
			stats_player_button_entry(px, py, "ui_Passing", btn_click_StatsView1, 0, 1);
			px -= deltaX;
			break;
		case 5:
			if (forceShowStatsTab) {
				stats_player_button_entry(px, py, "ui_Blocking", btn_click_StatsView1, 0, 1);
				px -= deltaX;
			}
			break;
		case 2:
			stats_player_button_entry(px, py, "ui_Rushing", btn_click_StatsView2, 0, 2);
			px -= deltaX;
			stats_player_button_entry(px, py, "ui_Receiving", btn_click_StatsView1, 0, 1);
			px -= deltaX;
			break;
		case 3:
		case 4:
			if (forceShowStatsTab) {
				stats_player_button_entry(px, py, "ui_Receiving", btn_click_StatsView1, 0, 1);
				px -= deltaX;
			}
			break;
		case 6:
		case 7:
		case 9:
		case 8:
			if (forceShowStatsTab) {
				stats_player_button_entry(px, py, "ui_Defense", btn_click_StatsView1, 0, 1);
				px -= deltaX;
			}
			break;
		case 10:
			if (forceShowStatsTab) {
				stats_player_button_entry(px, py, "ui_Kicking", btn_click_StatsView1, 0, 1);
				px -= deltaX;
			}
			break;
	}
	if (hasCurriculumVitae) {
		stats_player_button_entry(px, py, "ui_Awards", btn_rm_stats_player_showAwards, 1, 0);
		px -= deltaX;
	}
	if (hasLeft) {
		stats_player_button_entry(px, py, "ui_Epilogue", btn_rm_stats_player_showEpilogue, 2, 0);
		px -= deltaX;
	}
	inst_100509.y = 60;
	inst_100510.y = 60;
	inst_100511.y = 60;
	inst_100509.image_yscale = 1.3;
	inst_100510.image_yscale = 1.3;
	inst_100511.image_yscale = 1.3;
	inst_100512.y = 60;
	inst_100514.y = 60;
	inst_100515.y = 60;
	if (ds_map_exists(pmap, "class_of")) {
		if (ds_map_find_value(pmap, "team_leave_reason") == "graduated" || ds_map_find_value(pmap, "team_leave_reason") == "drafted") {
			if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() + 3) {
				instance_create_layer(248, 40, "Instances", obj_text, {
					text: s_str("ui_ClassOf") + string(ds_map_find_value(pmap, "class_of")),
					draw_box: false,
					halign: 1
				});
			}
		}
	}
	inst_100509.visible = false;
	inst_100510.visible = false;
	inst_100511.visible = false;
	inst_100512.visible = false;
	inst_100514.visible = false;
	inst_100515.visible = false;
	switch (obj_master.co_stats_tab) {
		case 0:
			inst_100509.visible = true;
			inst_100510.visible = true;
			inst_100511.visible = true;
			inst_100512.visible = true;
			inst_100514.visible = true;
			inst_100515.visible = true;
			break;
		case 1:
			s_set_cv_list_from_player(pmap);
			instance_create_layer(32, 60, "Instances", obj_hof_achievements, { image_xscale: 2.6, image_yscale: 1, use_player_awards: true, title: s_str("ui_Awards") });
			break;
		case 2:
			var epi_text = s_str("ui_No_Epilogue") + " (" + ds_map_find_value(pmap, "team_leave_reason") + ")";
			if (ds_map_exists(pmap, "epilogue") && ds_map_find_value(pmap, "epilogue") != "") {
				epi_text = s_epilogue_story_to_str(ds_map_find_value(pmap, "epilogue"));
				epi_text = s_parse_player_message(epi_text, pmap);
			}
			var msg = instance_create_layer(display_get_gui_width() * 0.5, -8 + display_get_gui_height() * 0.5, "Instances", obj_messagebox);
			msg.text = epi_text;
			msg.colour = global.c_background;
			break;
	}
	var singleUnitView = false;
	if (obj_master.profile_back_to == 1) {
		singleUnitView = true;
	}
	if (obj_master.profile_back_to == 2) {
		singleUnitView = true;
	}
	if (s_doing_college_draft()) {
		singleUnitView = true;
	}
	if (singleUnitView) {
		inst_100516.visible = false;
		inst_100517.visible = false;
	}
}

function s_change_panel_division_mode(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = self;
	}
	if (_arg0) {
		with (_arg0) {
			mode++;
			if (mode >= 5) {
				mode = 0;
			}
			s_panel_skip_independents_cnf_view(_arg0);
		}
	}
}

function s_panel_skip_independents_cnf_view(_arg0) {
	with (_arg0) {
		if (s_is_co_mode() && variable_instance_exists(id, "_conf_stats") && !_conf_stats && mode == 0) {
			mode = 2;
		}
	}
}

function s_panel_scroll_init(_arg0) {
	if (_arg0 == undefined) {
		_arg0 = 0;
	}
	active = true;
	clicked = false;
	ms_offset = 0;
	action_global_flick = s_panel_scroll_global_flick;
	s_set_var_if_missing("_scroll", false);
	s_set_var_if_missing("_scroll_x", 0);
	s_set_var_if_missing("_scroll_y", 0);
	_scroll_arrow_top = false;
	_scroll_arrow_bottom = false;
	_scroll_flick_y = 0;
	s_panel_scroll_set_height(_arg0);
}

function s_panel_scroll_step() {
	if (global.gamepad && active && global.gp.ui_selected == id) {
		if (global.gp.triggerl) {
			_scroll_flick_y += 0.5;
		} else if (global.gp.triggerr) {
			_scroll_flick_y -= 0.5;
		} else {
			_scroll_flick_y -= global.gp.axisr_v * 0.5;
		}
	}
	if (abs(_scroll_flick_y)) {
		_scroll_y += _scroll_flick_y;
	}
	if (s_is_touch_allowed()) {
		if (mouse_check_button_pressed(1) && mouse_x > x && mouse_x < x + sprite_width && mouse_y > y && mouse_y < y + sprite_height) {
			clicked = true;
		}
		if (mouse_check_button(1) && clicked) {
			if (ms_offset == 0) {
				ms_offset = _scroll_y - mouse_y;
			}
			_scroll_y = ms_offset + mouse_y;
			_scroll_flick_y = 0;
		} else {
			ms_offset = 0;
		}
		if (mouse_check_button_released(1) && clicked) {
			clicked = false;
		}
	}
	_scroll_flick_y *= 0.9;
	_scroll_y = clamp(_scroll_y, _scroll_height, 0);
}

function s_panel_scroll_set_height(_arg0) {
	_scroll_height = -_arg0 + sprite_height;
}

function s_panel_scroll_global_flick() {
	if (s_is_touch_allowed()) {
		if (mouse_y > y && mouse_y < y + sprite_height) {
			if (mouse_x > x && mouse_x < x + sprite_width) {
				_scroll_flick_y = ds_map_find_value(event_data, "diffY");
			}
		}
	}
}

function s_panel_scroll_draw_gui() {
	if (_scroll_arrow_top) {
		draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + 12, 0.5, 0.5, -90, 16777215, 1);
	}
	if (_scroll_arrow_bottom) {
		draw_sprite_ext(spr_arrowL2, 0, x + sprite_width - 10, y + sprite_height - 12, 0.5, 0.5, 90, 16777215, 1);
	}
	_scroll_arrow_top = false;
	_scroll_arrow_bottom = false;
}

function s_panel_scroll_is_inside(_arg0, _arg1) {
	if (_arg1 == undefined) {
		_arg1 = 4;
	}
	if (!_scroll) {
		return true;
	}
	if (_arg0 < y + _arg1) {
		_scroll_arrow_top = true;
		return false;
	}
	if (_arg0 > y + sprite_height - _arg1) {
		_scroll_arrow_bottom = true;
		return false;
	}
	return true;
}

