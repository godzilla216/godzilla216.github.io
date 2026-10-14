function btn_click_ChooseTeam() {
	var choose_teamuid = uid;
	with (obj_master) {
		for (var t = 0; t < ds_list_size(teamlist); t++) {
			var team = ds_list_find_value(teamlist, t);
			if (real(ds_map_find_value(team, "uid")) == choose_teamuid) {
				myteam = team;
			}
		}
		favourite_team_id = ds_map_find_value(myteam, "uid");
		if (fr_mode && 18 > week) {
			room_goto(rm_details);
			return;
		} else if (s_is_co_mode() && s_get_skip_to_week() > week) {
			switch (global.g_m.team_selections.mode) {
				case 1:
					global.g_m.team_selections.favorite_team_id = choose_teamuid;
					break;
				case 0:
					global.g_m.team_selections.starting_team_id = choose_teamuid;
					break;
			}
			room_goto(rm_details);
			return;
		} else {
			myteam_id = real(ds_map_find_value(myteam, "uid"));
			myconference = real(ds_map_find_value(myteam, "conference"));
			mydivision = real(ds_map_find_value(myteam, "division"));
			ds_list_destroy(fixturelist);
			fixturelist = -1;
			fixturelist = s_create_my_fixture_list();
		}
	}
	room_goto(rm_home);
}

function btn_click_ChooseTeamExhibition() {
	switch (global.exh_choosing) {
		case 0:
			ds_map_set(global.exh_fix, "away_team", uid);
			global.exh_use_roster_p0 = false;
			break;
		case 1:
			ds_map_set(global.exh_fix, "home_team", uid);
			global.exh_use_roster_p1 = false;
			break;
	}
	room_goto(rm_exhibition);
}

function btn_click_ChoosePlayerExhibition() {
	switch (global.exh_choosing) {
		case 0:
			ds_map_set(global.exh_fix, "away_team", uid);
			global.exh_use_roster_p0 = false;
			break;
		case 1:
			ds_map_set(global.exh_fix, "home_team", uid);
			global.exh_use_roster_p1 = false;
			break;
	}
	s_create_message("", s_str("msg_ExhibitionUseStarPlayers"), s_str("ui_No"), s_str("ui_Yes"), btn_click_ChoosePlayerExhibition_cancel, btn_click_ChoosePlayerExhibition_confirm, global.c_background, 1);
}

function btn_click_ChoosePlayerExhibition_confirm() {
	s_msg_clear();
	switch (global.exh_choosing) {
		case 0:
			global.exh_use_roster_p0 = true;
			break;
		case 1:
			global.exh_use_roster_p1 = true;
			break;
	}
	room_goto(rm_exhibition);
}

function btn_click_ChoosePlayerExhibition_cancel() {
	s_msg_clear();
	switch (global.exh_choosing) {
		case 0:
			global.exh_use_roster_p0 = false;
			break;
		case 1:
			global.exh_use_roster_p1 = false;
			break;
	}
	room_goto(rm_exhibition);
}

