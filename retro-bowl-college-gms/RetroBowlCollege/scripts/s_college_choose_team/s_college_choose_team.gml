function s_rm_choose_team_co_init() {
	s_init_rm();
	if (!variable_instance_exists(id, "mode")) {
		if (obj_master.year == 1 && obj_master.week == 1) {
			mode = 1;
		} else {
			mode = 2;
		}
	}
	btns = [];
	btn_major = s_create_button(135, 32, { text: s_get_subdiv_name(1), onClickAction: s_btn_major, image_xscale: 3.125 });
	btn_minor = s_create_button(245, 32, { text: s_get_subdiv_name(2), onClickAction: s_btn_minor, image_xscale: 3.125 });
	tier = 1;
	btn_conf = s_create_button(190, 32, { text: "", onClickAction: -4, colour: global.c_primary, image_xscale: 3.125 });
	btn_back = s_create_button(8, 232, { image: spr_arrowL });
	switch (mode) {
		case 1:
			s_create_title(s_str("ui_ChooseTeam"));
			break;
		case 0:
			s_create_title(s_str("ui_JobOffers"), undefined, true);
			break;
		case 2:
			s_create_title(s_str("ui_JobOffers"), undefined, true);
			btn_reject = s_create_button(370, 232, { text: s_str("ui_RejectAll"), onClickAction: s_choose_team_btn_reject, image_xscale: 3.125 });
			break;
	}
	s_choose_team_subdivision_mode();
}

function s_btn_minor() {
	global.rm.tier = 2;
	s_choose_team_refresh_subdivision();
}

function s_btn_major() {
	global.rm.tier = 1;
	s_choose_team_refresh_subdivision();
}

function s_choose_team_refresh_subdivision() {
	with (global.rm) {
		s_refresh_main_sections_buttons();
		s_destroy_dynamic_buttons(btns);
		btns = s_choose_team_create_conference_buttons(tier);
	}
}

function s_choose_team_refresh_conference() {
	with (global.rm) {
		s_destroy_dynamic_buttons(btns);
		btns = s_choose_team_create_team_buttons(conference);
	}
}

function s_choose_team_create_conference_buttons(_arg0) {
	var cl = s_get_conference_list(_arg0);
	var cb = [];
	var t = s_calc_grid_coords(array_length(cl));
	var btn, jo, name;
	for (var i = 0; i < array_length(cl); i++) {
		name = s_fit_string(cl[i].name, cl[i].tla, 96);
		switch (global.rm.mode) {
			case 1:
				btn = s_create_button(t[i].x, t[i].y, { text: name, conference: cl[i], onClickAction: s_choose_team_btn_conference, image_xscale: 3.125 });
				break;
			case 0:
				jo = s_count_starting_team_selectable_conference(cl[i]);
				btn = s_create_button(t[i].x, t[i].y, {
					text: name + "\n" + s_joboffers_string(jo),
					active: jo > 0,
					conference: cl[i],
					onClickAction: s_choose_team_btn_conference,
					image_xscale: 3.125
				});
				break;
			case 2:
				jo = s_count_joboffers_conference(cl[i]);
				btn = s_create_button(t[i].x, t[i].y, {
					text: name + "\n" + s_joboffers_string(jo),
					active: jo > 0,
					conference: cl[i],
					onClickAction: s_choose_team_btn_conference,
					image_xscale: 3.125
				});
				break;
			case 3:
				btn = s_create_button(t[i].x, t[i].y, { text: name, conference: cl[i], onClickAction: s_btn_editor_conference, image_xscale: 3.125 });
				break;
		}
		array_push(cb, btn);
	}
	return cb;
}

function s_choose_team_btn_conference() {
	global.rm.conference = conference;
	s_choose_team_conference_mode();
}

function s_choose_team_create_team_buttons(_arg0) {
	var tl = s_get_team_list(_arg0.uid);
	var tb = [];
	var t = s_calc_grid_coords(array_length(tl));
	var btn;
	for (var i = 0; i < array_length(tl); i++) {
		switch (global.rm.mode) {
			case 1:
				btn = s_create_button(t[i].x, t[i].y, {
					text: ds_map_find_value(array_get(tl, i), "name"),
					uid: ds_map_find_value(array_get(tl, i), "uid"),
					onClickAction: s_choose_team_btn_fav_team,
					image_xscale: 3.125
				});
				break;
			case 0:
				btn = s_create_button(t[i].x, t[i].y, {
					text: ds_map_find_value(array_get(tl, i), "name"),
					uid: ds_map_find_value(array_get(tl, i), "uid"),
					onClickAction: s_choose_team_btn_fav_team,
					image_xscale: 3.125,
					active: s_is_starting_team_selectable(ds_map_find_value(array_get(tl, i), "uid"))
				});
				break;
			case 2:
				btn = s_create_button(t[i].x, t[i].y, {
					text: ds_map_find_value(array_get(tl, i), "name") + "\n ",
					uid: ds_map_find_value(array_get(tl, i), "uid"),
					onClickAction: s_choose_team_btn_new_team,
					sprite_index: spr_button_104,
					offense: s_get_team_offense_with_reputation_boost(tl[i]),
					defense: s_get_team_defense_with_reputation_boost(tl[i]),
					active: s_team_interested(tl[i])
				}, obj_button_team);
				break;
			case 3:
				btn = s_create_button(t[i].x, t[i].y, {
					text: ds_map_find_value(array_get(tl, i), "name"),
					uid: ds_map_find_value(array_get(tl, i), "uid"),
					onClickAction: s_btn_editor_select_team,
					image_xscale: 3.125
				});
				break;
		}
		array_push(tb, btn);
	}
	return tb;
}

function s_choose_team_btn_fav_team() {
	btn_click_ChooseTeam();
}

function s_choose_team_btn_new_team() {
	btn_click_ChooseTeamNew();
}

function s_choose_team_btn_back() {
	room_goto(rm_details);
}

function s_choose_team_btn_reject() {
	if (!s_offer_data_upgrade()) {
		btn_click_ChooseReject_loading();
	}
}

function s_choose_team_conference_mode() {
	with (global.rm) {
		btn_major.visible = false;
		btn_minor.visible = false;
		btn_conf.visible = true;
		btn_conf.text = s_fit_string(conference.name, conference.tla, 96);
		btn_conf.colour = global.c_primary;
		btn_back.onClickAction = s_choose_team_subdivision_mode;
		switch (mode) {
			case 2:
				btn_back.visible = true;
				break;
		}
		s_choose_team_refresh_conference();
	}
}

function s_choose_team_subdivision_mode() {
	with (global.rm) {
		btn_major.visible = true;
		btn_minor.visible = true;
		btn_conf.visible = false;
		btn_back.onClickAction = s_choose_team_btn_back;
		switch (mode) {
			case 2:
				btn_back.visible = false;
				break;
		}
		s_choose_team_refresh_subdivision();
	}
}

function s_refresh_main_sections_buttons() {
	with (global.rm) {
		btn_major.colour = tier == 1 ? global.c_primary : global.c_background;
		btn_minor.colour = tier == 2 ? global.c_primary : global.c_background;
		if (variable_instance_exists(id, "btn_bowls")) {
			btn_bowls.colour = tier == 3 ? global.c_primary : global.c_background;
		}
	}
}

