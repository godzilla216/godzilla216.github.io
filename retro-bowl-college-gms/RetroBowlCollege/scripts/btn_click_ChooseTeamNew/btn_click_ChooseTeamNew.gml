function btn_click_ChooseTeamNew() {
	slog("btn_click_ChooseTeamNew");
	var choose_teamuid = uid;
	with (obj_master) {
		for (var t = 0; t < ds_list_size(teamlist); t++) {
			var team = ds_list_find_value(teamlist, t);
			if (ds_map_find_value(team, "uid") == choose_teamuid) {
				newteam = team;
				var msg = s_str("msg_ChooseNewTeam");
				msg = string_replace(msg, "$teamname", ds_map_find_value(team, "name"));
				s_create_message("", msg, s_str("ui_Cancel"), s_str("ui_Confirm"), s_msg_clear, btn_response_confirm_new_team_loading, global.c_background, 1);
			}
		}
	}
}

function btn_click_qb_mode_ChooseTeamNew() {
	slog("btn_click_qb_mode_ChooseTeamNew");
	var choose_teamuid = uid;
	with (obj_master) {
		for (var t = 0; t < ds_list_size(teamlist); t++) {
			var team = ds_list_find_value(teamlist, t);
			if (ds_map_find_value(team, "uid") == choose_teamuid) {
				newteam = team;
				room_goto(rm_qb_contract);
			}
		}
	}
}

