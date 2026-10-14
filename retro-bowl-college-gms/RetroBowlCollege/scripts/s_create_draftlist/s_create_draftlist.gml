function s_create_draftlist() {
	slog("s_create_draftlist");
	with (obj_master) {
		interviews = 10;
		switch (op_difficulty) {
			case 0:
				interviews = 10 + round((5 + suppress_difficulty) / 2);
				break;
			case 1:
				interviews = 20;
				break;
			case 2:
				interviews = 15;
				break;
			case 3:
				interviews = 10;
				break;
			case 4:
				interviews = 5;
				break;
		}
		interviews += s_count_trait_scout() * 3;
		for (var i = 0; i < ds_list_size(draftlist); i++) {
			ds_map_destroy(ds_list_find_value(draftlist, i));
			ds_list_set(draftlist, i, -1);
		}
		ds_list_clear(draftlist);
		var wins = 0;
		var losses = 0;
		var ties = 0;
		var map = ds_list_find_value(obj_master.history, ds_list_size(obj_master.history) - 1);
		if (map && ds_exists(map, 1) && ds_map_exists(map, "wins")) {
			wins = real(ds_map_find_value(map, "wins"));
			losses = real(ds_map_find_value(map, "losses"));
			ties = real(ds_map_find_value(map, "ties"));
		}
		var str = string(wins) + "-" + string(losses) + "-" + string(ties);
		slog(str);
		var num_games = wins + losses + ties;
		var prc = 0;
		if (num_games > 0) {
			prc = (wins + ties * 0.5) / num_games;
		}
		for (var i = 0; i < ds_list_size(history); i++) {
			var map = ds_list_find_value(history, i);
			if (map && ds_map_exists(map, "year") && real(ds_map_find_value(map, "year")) == year - 1) {
				if (ds_map_find_value(map, "tla") != ds_map_find_value(myteam, "tla")) {
					prc = (s_get_team_offense_with_reputation_boost(myteam) + s_get_team_defense_with_reputation_boost(myteam)) * 0.05;
				}
				break;
			}
		}
		for (var i = 1; i <= 50; i++) {
			var max_skill = lerp(8.5, 5.5, prc);
			if (year == 2) {
				max_skill = 8;
			}
			if (i < 5) {
				max_skill = 8;
			}
			pos = i mod 10;
			pos += 1;
			if (irandom(1) && (pos == 8 || pos == 9)) {
				pos = irandom_range(1, 10);
			}
			if (pos == 10) {
				max_skill *= random_range(0.5, 0.8);
			}
			var pmap = s_create_player(pos, s_rookie_age_internal(), 2, round(max_skill));
			if (pos == 1 && ds_map_find_value(pmap, "strength") > 4) {
				ds_map_set(pmap, "strength", 4);
				ds_map_set(pmap, "salary", s_get_new_salary(pmap));
				if (s_is_co_mode()) {
					ds_map_set(pmap, "rc_cost", s_create_player_get_RC_cost(pmap));
				}
			}
			if (s_is_co_mode()) {
				s_college_correct_new_player(pmap);
				if (ds_map_find_value(pmap, "percent_grade") < 79) {
					ds_map_set(pmap, "percent_grade", 79);
					s_refresh_suspended(pmap, false);
				}
			}
			ds_list_add(draftlist, pmap);
		}
		draftlist = s_sort_players(draftlist, 2);
		s_savegame();
	}
}

