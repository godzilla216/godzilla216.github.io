function btn_response_confirm_new_team_loading() {
	s_loading_start(btn_response_confirm_new_team);
}

function btn_response_confirm_new_team() {
	with (obj_master) {
		var oldteamname = ds_map_find_value(myteam, "name");
		ds_map_set(myteam, "defense", s_get_team_defense(myteam, false));
		ds_map_set(myteam, "offense", s_get_team_offense(myteam, false));
		s_create_new_roster_cut_old_roster();
		myteam = newteam;
		newteam = -4;
		myteam_id = real(ds_map_find_value(myteam, "uid"));
		myconference = real(ds_map_find_value(myteam, "conference"));
		mydivision = real(ds_map_find_value(myteam, "division"));
		facility_stadium = 1;
		facility_training = 1;
		facility_rehab = 1;
		fans = 10 + irandom(10);
		repeat (3) {
			switch (irandom(3)) {
				case 0:
					facility_stadium++;
					break;
				case 1:
					facility_training++;
					break;
				case 2:
					facility_rehab++;
					break;
				case 3:
					fans += 10;
					break;
			}
		}
		draft_picks[0] = 1;
		draft_picks[1] = 1;
		draft_picks[2] = 1;
		facility_upgraded_stadium = 0;
		facility_upgraded_training = 0;
		facility_upgraded_rehab = 0;
		if (s_is_co_mode()) {
			s_refresh_strings();
		}
		s_create_new_roster_newteam();
		s_create_new_stafflist();
		s_set_team_morale(15, 100);
		var msg = s_str("news_NewJob" + string(1 + irandom(2)));
		if (myteam_id == favourite_team_id) {
			msg += "##" + s_str("news_FavoriteTeam" + string(1 + irandom(2)));
		}
		msg = string_replace_all(msg, "$oldteamname", oldteamname);
		msg = string_replace_all(msg, "$newteamname", ds_map_find_value(myteam, "name"));
		msg = string_replace_all(msg, "$yourname", fname + " " + lname);
		msg = string_replace_all(msg, "$yourlastname", lname);
		msg = string_hash_to_newline(msg);
		s_add_news(msg);
		s_complete_achievement("ACH_TEAMS2");
		s_start_new_season(true);
	}
}

