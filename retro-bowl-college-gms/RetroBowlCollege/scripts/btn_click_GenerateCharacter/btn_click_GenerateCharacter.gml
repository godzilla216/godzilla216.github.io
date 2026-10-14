function btn_click_GenerateCharacter() {
	slog("btn_click_GenerateCharacter");
	with (obj_master) {
		myface_x = -1;
		myface_y = -1;
		s_choose_random_face_for_me();
		fname = s_get_random_first_name(true);
		if (myface_x == 8) {
			fname = s_get_random_first_name(false);
		}
		lname = s_get_random_last_name();
		myteam_id = s_get_random_team_id();
		slogf("myteam_id is %1", myteam_id);
		myteam = ds_list_find_value(teamlist, myteam_id);
		myconference = ds_map_find_value(myteam, "conference");
		mydivision = ds_map_find_value(myteam, "division");
		slog("myteam name is " + ds_map_find_value(myteam, "name"));
		if (s_is_co_mode()) {
			s_reset_team_selections(true);
			s_refresh_strings();
			for (var i = 0; i < ds_list_size(roster); i++) {
				var pmap = ds_list_find_value(roster, i);
				s_college_correct_new_player(pmap);
			}
		}
	}
	room_goto(rm_details);
}

