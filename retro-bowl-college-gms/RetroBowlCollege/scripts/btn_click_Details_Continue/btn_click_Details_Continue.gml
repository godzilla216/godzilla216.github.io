function btn_click_Details_Continue() {
	slog("btn_click_Details_Continue");
	with (obj_master) {
		fname = inst_100025.text;
		lname = inst_100026.text;
		if (fname == "") {
			fname = s_get_random_first_name(true);
		}
		if (lname == "") {
			lname = s_get_random_last_name();
		}
		fname_coach = s_get_random_first_name(true);
		lname_coach = s_get_random_last_name();
		favourite_team_id = real(ds_map_find_value(myteam, "uid"));
		if (inst_100037.state == true) {
			slog("Choosing fave team!");
			myteam_id = real(ds_map_find_value(myteam, "uid"));
			myconference = real(ds_map_find_value(myteam, "conference"));
			mydivision = real(ds_map_find_value(myteam, "division"));
			ds_map_set(myteam, "offense", 1);
			ds_map_set(myteam, "defense", 1);
			if (fr_mode && 1) {
				s_skip_to_week(18);
			}
			if (s_is_co_mode() && s_get_skip_to_week() > 1) {
				s_skip_to_week(s_get_skip_to_week());
				s_competitions_status_update();
			}
		} else {
			if (fr_mode && 1) {
				s_skip_to_week(18);
			}
			if (s_is_co_mode() && s_get_skip_to_week() > 1) {
				s_skip_to_week(s_get_skip_to_week());
				s_competitions_status_update();
			}
			if (s_is_co_mode()) {
				favourite_team_id = global.g_m.team_selections.favorite_team_id;
				myteam_id = global.g_m.team_selections.starting_team_id;
				myteam = s_get_team_by_id(myteam_id);
				myconference = real(ds_map_find_value(myteam, "conference"));
				mydivision = real(ds_map_find_value(myteam, "division"));
				slogf("my team: %1 conf: %2", myteam_id, myconference);
				for (var i = 0; i < ds_list_size(roster); i++) {
					var pmap = ds_list_find_value(roster, i);
					ds_map_set(pmap, "teamid", myteam_id);
					s_college_correct_new_player(pmap);
				}
			}
			if (!s_is_co_mode()) {
				slog("Choosing random team!");
				var sorted_teams = ds_list_create();
				ds_list_copy(sorted_teams, teamlist);
				sorted_teams = s_sort_teams(sorted_teams, 0, true);
				for (var i = 0; i < ds_list_size(sorted_teams); i++) {
					myteam = ds_list_find_value(sorted_teams, i);
					myteam_id = real(ds_map_find_value(myteam, "uid"));
					myconference = real(ds_map_find_value(myteam, "conference"));
					mydivision = real(ds_map_find_value(myteam, "division"));
					slogf("my team: %1 conf: %2", myteam_id, myconference);
					if (s_is_co_mode()) {
						if (myteam_id >= min_team_id && myteam_id != favourite_team_id && !irandom(1)) {
							break;
						}
					} else if (myteam_id != favourite_team_id && !irandom(1)) {
						break;
					}
				}
				ds_list_destroy(sorted_teams);
				sorted_teams = -1;
			}
		}
		s_set_team_morale(60, 90);
		for (var i = 0; i < ds_list_size(fixturelist); i++) {
			ds_map_destroy(ds_list_find_value(fixturelist, i));
			ds_list_set(fixturelist, i, -1);
		}
		ds_list_destroy(fixturelist);
		fixturelist = -1;
		fixturelist = s_create_my_fixture_list();
		for (var i = 0; i < ds_list_size(roster); i++) {
			pmap = ds_list_find_value(roster, i);
			ds_map_set(pmap, "teamid", myteam_id);
			ds_map_set(pmap, "condition", irandom_range(80, 100));
		}
		var weeks_rem = 1;
		var msg = s_str("news_NewCareer");
		if (obj_master.qb_mode) {
			msg = s_str("news_NewCareerQB");
			msg = string_replace_all(msg, "$teamname", s_get_team_name_by_id(myteam_id));
			var pick = irandom(95);
			var rnd = floor(pick / 32);
			msg = string_replace(msg, "$playername", fname + " " + lname);
			msg = string_replace(msg, "$coachname", fname_coach + " " + lname_coach);
			msg = string_replace(msg, "$num", string(pick + 1));
			msg = string_replace(msg, "$round", string(rnd + 1));
			s_set_up_qb_pmap();
		} else {
			msg = string_replace_all(msg, "$teamname", s_get_team_name_by_id(myteam_id));
			msg = string_replace(msg, "$coachname", fname + " " + lname);
			msg = string_replace(msg, "$num", string(weeks_rem));
		}
		if (weeks_rem > 1) {
			msg = string_replace(msg, "$weeks", string_lower(s_str("ui_Weeks")));
		} else {
			msg = string_replace(msg, "$weeks", string_lower(s_str("ui_Week")));
		}
		msg = string_replace(msg, "$lname", lname);
		msg = string_replace(msg, "$randomcollegename", s_get_random_college_name());
		s_add_news(msg);
	}
	if (s_is_co_mode()) {
		s_refresh_strings();
	}
	s_play(0);
}

