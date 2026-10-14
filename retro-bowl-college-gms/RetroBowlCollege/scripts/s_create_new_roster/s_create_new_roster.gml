function s_create_new_roster() {
	with (obj_master) {
		for (var i = ds_list_size(roster) - 1; i >= 0; i--) {
			var pmap = ds_list_find_value(roster, i);
			s_remove_player(pmap, "newroster", s_pick_epilogue_story("epi_newteam"));
		}
		ds_list_destroy(roster);
		roster = -1;
		roster = ds_list_create();
		var pmap = s_create_player(1, 0, 2, 4);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		if (year == 1) {
			ds_map_set(pmap, "skill", 8);
			ds_map_set(pmap, "strength", 3);
			ds_map_set(pmap, "speed", 1);
			ds_map_set(pmap, "stamina", 5);
			ds_map_set(pmap, "max_skill", ds_map_find_value(pmap, "skill"));
			ds_map_set(pmap, "max_strength", ds_map_find_value(pmap, "strength"));
			ds_map_set(pmap, "max_speed", ds_map_find_value(pmap, "speed"));
			ds_map_set(pmap, "max_stamina", ds_map_find_value(pmap, "stamina"));
		}
		ds_list_add(roster, pmap);
		var pmap = s_create_player(2, 0, 2, 4);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		var pmap = s_create_player(4, 0, 2, 4);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		var pmap = s_create_player(10, 0, 2, 4);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		var pmap = s_create_player(6, 0, 2, 4);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		if (s_is_co_mode()) {
			for (var i = 0; i < 3; i++) {
				var pos = choose(3, 3, 4, 4, 5);
				if (i > 0) {
					pos = choose(6, 7, 9);
				}
				var pmap = s_create_player(pos, 0, 2, 4);
				ds_map_set(pmap, "signed_year", -1);
				ds_map_set(pmap, "teamid", myteam_id);
				ds_list_add(roster, pmap);
			}
			for (var i = 0; i < ds_list_size(roster) - 1; i++) {
				var pmap = ds_list_find_value(roster, i);
				ds_map_set(pmap, "season_yards", irandom_range(300, 500));
				ds_map_set(pmap, "season_touchdowns", irandom_range(5, 10));
				ds_map_set(pmap, "season_fumbles", irandom_range(2, 3));
				ds_map_set(pmap, "season_tackles", irandom_range(20, 50));
				ds_map_set(pmap, "season_int", irandom_range(3, 5));
				ds_map_set(pmap, "season_sacks", irandom_range(5, 10));
				ds_map_set(pmap, "season_complete", irandom_range(6, 9));
				ds_map_set(pmap, "season_attempts", ds_map_find_value(pmap, "season_complete") + irandom_range(4, 5));
				ds_map_set(pmap, "career_yards", ds_map_find_value(pmap, "season_yards"));
				ds_map_set(pmap, "career_touchdowns", ds_map_find_value(pmap, "season_touchdowns"));
				ds_map_set(pmap, "career_fumbles", ds_map_find_value(pmap, "season_fumbles"));
				ds_map_set(pmap, "career_tackles", ds_map_find_value(pmap, "season_tackles"));
				ds_map_set(pmap, "career_int", ds_map_find_value(pmap, "season_int"));
				ds_map_set(pmap, "career_sacks", ds_map_find_value(pmap, "season_sacks"));
				ds_map_set(pmap, "career_complete", ds_map_find_value(pmap, "season_complete"));
				ds_map_set(pmap, "career_attempts", ds_map_find_value(pmap, "season_attempts"));
			}
		}
		if (year == 1 && obj_master.co_mode == 0) {
			for (var i = 0; i < ds_list_size(roster) - 1; i++) {
				var pmap = ds_list_find_value(roster, i);
				var max_age = s_get_max_age(pmap);
				if (ds_map_find_value(pmap, "age") > max_age - 2) {
					ds_map_set(pmap, "age", max_age - 2);
				}
				if (ds_map_find_value(pmap, "contract") < 2) {
					ds_map_set(pmap, "contract", 2);
				}
			}
		}
		if (year == 1 && s_is_co_mode()) {
			s_college_balance_create_new_roster();
		}
	}
}

