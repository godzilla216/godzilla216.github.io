function s_create_new_roster_newteam() {
	with (obj_master) {
		roster = ds_list_create();
		var max_offense = s_get_team_offense_with_reputation_boost(myteam);
		var max_defense = s_get_team_defense_with_reputation_boost(myteam);
		var pmap = s_create_player(1, 0, max_offense * 0.75, max_offense);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		var pmap = s_create_player(2, 0, max_offense * 0.75, max_offense);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		var pmap = s_create_player(4, 0, max_offense * 0.75, max_offense);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		var pmap = s_create_player(10, 0, max_defense * 0.75, max_defense);
		ds_map_set(pmap, "signed_year", -1);
		ds_map_set(pmap, "teamid", myteam_id);
		ds_list_add(roster, pmap);
		for (var i = 0; i < 4; i++) {
			var pos = choose(3, 3, 4, 4, 5);
			if (i > 0) {
				pos = choose(6, 7, 9);
			}
			var pmap = s_create_player(pos, 0, max_defense * 0.75, max_defense);
			ds_map_set(pmap, "signed_year", -1);
			ds_map_set(pmap, "teamid", myteam_id);
			ds_list_add(roster, pmap);
		}
		if (s_is_co_mode() == false && obj_master.op_difficulty >= 3) {
			for (var i = 0; i < ds_list_size(roster); i++) {
				var pmap = ds_list_find_value(roster, i);
				if (!irandom(10)) {
					ds_map_set(pmap, "contract", 0);
				}
			}
		}
		if (s_is_co_mode()) {
			for (var i = 0; i < ds_list_size(roster); i++) {
				var pmap = ds_list_find_value(roster, i);
				s_college_correct_new_player(pmap);
			}
		}
	}
}

function s_create_new_roster_cut_old_roster() {
	with (obj_master) {
		for (var i = ds_list_size(roster) - 1; i >= 0; i--) {
			var pmap = ds_list_find_value(roster, i);
			s_remove_player(pmap, "newteam", s_pick_epilogue_story("epi_newteam"));
		}
		ds_list_destroy(roster);
		roster = -1;
	}
}

