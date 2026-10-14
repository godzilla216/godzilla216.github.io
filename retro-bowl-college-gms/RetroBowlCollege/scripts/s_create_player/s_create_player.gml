function s_create_player_get_RC_cost(_arg0) {
	return floor(ds_map_find_value(_arg0, "salary") / 3 * 6);
}

function s_create_player(_arg0, _arg1, _arg2, _arg3) {
	var lname = s_get_random_last_name();
	while (s_lastname_already_on_roster(lname)) {
		lname = s_get_random_last_name();
	}
	var pmap = ds_map_create();
	ds_map_set(pmap, "randnum", irandom(999));
	ds_map_set(pmap, "fname", s_get_random_first_name(true));
	ds_map_set(pmap, "lname", lname);
	ds_map_set(pmap, "position", _arg0);
	ds_map_set(pmap, "hof", false);
	ds_map_set(pmap, "kr", false);
	var max_age = s_get_max_age(pmap);
	if (_arg1 == 0) {
		var startAge = s_rookie_age_internal() + 1;
		if (s_is_co_mode()) {
			startAge = s_rookie_age_internal();
		}
		ds_map_set(pmap, "age", irandom_range(startAge, max_age));
	} else {
		ds_map_set(pmap, "age", clamp(_arg1, s_rookie_age_internal(), max_age));
	}
	var max_speed = 10;
	var max_strength = 10;
	var max_skill = 10;
	var max_stamina = 10;
	switch (_arg0) {
		case 1:
			max_speed = 7;
			max_strength = 10;
			max_skill = 10;
			ds_map_set(pmap, "speed", irandom_range(1, max_speed));
			ds_map_set(pmap, "strength", irandom_range(1, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 2:
			max_speed = 10;
			max_strength = 9;
			max_skill = 6;
			max_stamina = 9;
			ds_map_set(pmap, "speed", irandom_range(4, max_speed));
			ds_map_set(pmap, "strength", irandom_range(2, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 3:
			max_speed = 7;
			max_strength = 8;
			max_skill = 8;
			max_stamina = 10;
			ds_map_set(pmap, "speed", irandom_range(4, max_speed));
			ds_map_set(pmap, "strength", irandom_range(2, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 4:
			max_speed = 10;
			max_strength = 6;
			max_skill = 10;
			max_stamina = 8;
			ds_map_set(pmap, "speed", irandom_range(5, max_speed));
			ds_map_set(pmap, "strength", irandom_range(2, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 5:
		case 6:
			max_speed = 5;
			max_strength = 10;
			max_skill = 10;
			ds_map_set(pmap, "speed", irandom_range(1, max_speed));
			ds_map_set(pmap, "strength", irandom_range(5, max_strength));
			ds_map_set(pmap, "skill", irandom_range(4, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 7:
			max_speed = 7;
			max_strength = 8;
			max_skill = 8;
			ds_map_set(pmap, "speed", irandom_range(2, max_speed));
			ds_map_set(pmap, "strength", irandom_range(2, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 8:
		case 9:
			max_speed = 9;
			max_strength = 6;
			max_skill = 8;
			ds_map_set(pmap, "speed", irandom_range(4, max_speed));
			ds_map_set(pmap, "strength", irandom_range(2, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
		case 10:
			max_speed = 7;
			max_strength = 10;
			max_skill = 10;
			ds_map_set(pmap, "speed", irandom_range(4, max_speed));
			ds_map_set(pmap, "strength", irandom_range(2, max_strength));
			ds_map_set(pmap, "skill", irandom_range(2, max_skill));
			ds_map_set(pmap, "stamina", irandom_range(1, max_stamina));
			break;
	}
	var des_rating = irandom_range(_arg2, _arg3);
	repeat (5) {
		if (s_get_player_rating(pmap) < des_rating) {
			ds_map_set(pmap, "skill", clamp(ds_map_find_value(pmap, "skill") + 1, 1, max_skill));
		}
		if (s_get_player_rating(pmap) < des_rating) {
			ds_map_set(pmap, "strength", clamp(ds_map_find_value(pmap, "strength") + 1, 1, max_strength));
		}
		if (s_get_player_rating(pmap) < des_rating) {
			ds_map_set(pmap, "speed", clamp(ds_map_find_value(pmap, "speed") + 1, 1, max_speed));
		}
		if (s_get_player_rating(pmap) < des_rating) {
			ds_map_set(pmap, "stamina", clamp(ds_map_find_value(pmap, "stamina") + 1, 1, max_stamina));
		}
		if (s_get_player_rating(pmap) > des_rating) {
			ds_map_set(pmap, "skill", clamp(ds_map_find_value(pmap, "skill") - 1, 1, max_skill));
		}
		if (s_get_player_rating(pmap) > des_rating) {
			ds_map_set(pmap, "strength", clamp(ds_map_find_value(pmap, "strength") - 1, 1, max_strength));
		}
		if (s_get_player_rating(pmap) > des_rating) {
			ds_map_set(pmap, "speed", clamp(ds_map_find_value(pmap, "speed") - 1, 1, max_speed));
		}
		if (s_get_player_rating(pmap) > des_rating) {
			ds_map_set(pmap, "stamina", clamp(ds_map_find_value(pmap, "stamina") - 1, 1, max_stamina));
		}
	}
	var contract = irandom_range(1, 3);
	var attitude = irandom_range(1, 100);
	if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
		attitude = irandom_range(40, 100);
		contract = 2;
	}
	if (s_is_co_mode()) {
		contract = 8;
	}
	ds_map_set(pmap, "attitude", attitude);
	ds_map_set(pmap, "contract", contract);
	ds_map_set(pmap, "salary", s_get_new_salary(pmap));
	ds_map_set(pmap, "creditcost", 0);
	ds_map_set(pmap, "xp", 0);
	if (ds_map_find_value(pmap, "age") > s_rookie_age_internal()) {
		ds_map_set(pmap, "xp", irandom(99));
	}
	ds_map_set(pmap, "xp_level", clamp(ds_map_find_value(pmap, "age") - s_rookie_age_internal(), 1, 9));
	ds_map_set(pmap, "xp_gain", 0);
	ds_map_set(pmap, "skill_points", 0);
	var pot = clamp(31 - ds_map_find_value(pmap, "age"), 0, 10) * 0.5;
	if (ds_map_find_value(pmap, "age") == s_rookie_age_internal() && irandom(1)) {
		pot = 6;
	}
	ds_map_set(pmap, "max_skill", clamp(ds_map_find_value(pmap, "skill") + irandom(pot), 1, max_skill));
	ds_map_set(pmap, "max_speed", clamp(ds_map_find_value(pmap, "speed") + irandom(pot), 1, max_speed));
	ds_map_set(pmap, "max_strength", clamp(ds_map_find_value(pmap, "strength") + irandom(pot), 1, max_strength));
	ds_map_set(pmap, "max_stamina", clamp(ds_map_find_value(pmap, "stamina") + irandom(pot), 1, max_stamina));
	s_round_player_attributes(pmap);
	ds_map_set(pmap, "condition", irandom_range(40, 100));
	if (ds_map_find_value(pmap, "age") == s_rookie_age_internal()) {
		ds_map_set(pmap, "condition", irandom_range(80, 100));
	}
	ds_map_set(pmap, "injury_week", 0);
	ds_map_set(pmap, "resting", 0);
	ds_map_set(pmap, "signed_year", 0);
	ds_map_set(pmap, "teamid", -1);
	ds_map_set(pmap, "outtrade_pick", 0);
	ds_map_set(pmap, "intrade_pick", 0);
	ds_map_set(pmap, "flash_time", 0);
	ds_map_set(pmap, "meetingdone", 0);
	ds_map_set(pmap, "scouted", 0);
	ds_map_set(pmap, "team_leave_reason", "");
	ds_map_set(pmap, "epilogue", "");
	ds_map_set(pmap, "drafted_pro_team", "");
	ds_map_set(pmap, "epilogue_story", "");
	ds_map_set(pmap, "stat_attempts", 0);
	ds_map_set(pmap, "stat_complete", 0);
	ds_map_set(pmap, "stat_yards", 0);
	ds_map_set(pmap, "stat_longest", 0);
	ds_map_set(pmap, "stat_touchdowns", 0);
	ds_map_set(pmap, "stat_fumbles", 0);
	ds_map_set(pmap, "stat_int", 0);
	ds_map_set(pmap, "stat_sacks", 0);
	ds_map_set(pmap, "stat_tackles", 0);
	ds_map_set(pmap, "stat_rush_attempts", 0);
	ds_map_set(pmap, "stat_rush_yards", 0);
	ds_map_set(pmap, "stat_rush_longest", 0);
	ds_map_set(pmap, "stat_rush_touchdowns", 0);
	ds_map_set(pmap, "stat_return_yards", 0);
	ds_map_set(pmap, "stat_return_longest", 0);
	ds_map_set(pmap, "stat_return_tds", 0);
	ds_map_set(pmap, "stat_return_attempts", 0);
	ds_map_set(pmap, "season_games", 0);
	ds_map_set(pmap, "season_attempts", 0);
	ds_map_set(pmap, "season_complete", 0);
	ds_map_set(pmap, "season_yards", 0);
	ds_map_set(pmap, "season_longest", 0);
	ds_map_set(pmap, "season_touchdowns", 0);
	ds_map_set(pmap, "season_fumbles", 0);
	ds_map_set(pmap, "season_int", 0);
	ds_map_set(pmap, "season_sacks", 0);
	ds_map_set(pmap, "season_tackles", 0);
	ds_map_set(pmap, "season_rush_attempts", 0);
	ds_map_set(pmap, "season_rush_yards", 0);
	ds_map_set(pmap, "season_rush_longest", 0);
	ds_map_set(pmap, "season_rush_touchdowns", 0);
	ds_map_set(pmap, "season_return_yards", 0);
	ds_map_set(pmap, "season_return_longest", 0);
	ds_map_set(pmap, "season_return_tds", 0);
	ds_map_set(pmap, "season_return_attempts", 0);
	ds_map_set(pmap, "career_games", 0);
	ds_map_set(pmap, "career_attempts", 0);
	ds_map_set(pmap, "career_complete", 0);
	ds_map_set(pmap, "career_yards", 0);
	ds_map_set(pmap, "career_longest", 0);
	ds_map_set(pmap, "career_touchdowns", 0);
	ds_map_set(pmap, "career_fumbles", 0);
	ds_map_set(pmap, "career_int", 0);
	ds_map_set(pmap, "career_sacks", 0);
	ds_map_set(pmap, "career_tackles", 0);
	ds_map_set(pmap, "career_rush_attempts", 0);
	ds_map_set(pmap, "career_rush_yards", 0);
	ds_map_set(pmap, "career_rush_longest", 0);
	ds_map_set(pmap, "career_rush_touchdowns", 0);
	ds_map_set(pmap, "career_return_yards", 0);
	ds_map_set(pmap, "career_return_longest", 0);
	ds_map_set(pmap, "career_return_tds", 0);
	ds_map_set(pmap, "career_return_attempts", 0);
	ds_map_set(pmap, "walk_on", 0);
	if (ds_map_find_value(pmap, "position") == 10) {
		ds_map_set(pmap, "stat_attempts_XP", 0);
		ds_map_set(pmap, "season_attempts_XP", 0);
		ds_map_set(pmap, "career_attempts_XP", 0);
		ds_map_set(pmap, "stat_complete_XP", 0);
		ds_map_set(pmap, "season_complete_XP", 0);
		ds_map_set(pmap, "career_complete_XP", 0);
	}
	ds_map_set(pmap, "skin", irandom(2));
	ds_map_set(pmap, "face_set", 0);
	switch (ds_map_find_value(pmap, "position")) {
		case 1:
			break;
		case 2:
			if (irandom(4)) {
				ds_map_set(pmap, "skin", 0);
			}
			break;
		case 3:
			if (irandom(1)) {
				ds_map_set(pmap, "skin", 2);
			}
			break;
		case 4:
			if (irandom(4)) {
				ds_map_set(pmap, "skin", 0);
			}
			break;
		case 5:
			break;
		case 6:
		case 7:
		case 8:
		case 9:
			if (irandom(4)) {
				ds_map_set(pmap, "skin", 0);
			}
			break;
		case 10:
			if (irandom(4)) {
				ds_map_set(pmap, "skin", 2);
			}
			break;
	}
	var fgrid = obj_master.face_grid_L;
	switch (ds_map_find_value(pmap, "skin")) {
		case 2:
			fgrid = obj_master.face_grid_L;
			break;
		case 1:
			fgrid = obj_master.face_grid_M;
			break;
		case 0:
			fgrid = obj_master.face_grid_D;
			break;
	}
	if (ds_grid_get_min(fgrid, 0, 0, ds_grid_width(fgrid), ds_grid_height(fgrid)) == 1) {
		slog("Clearing face grid");
		ds_grid_clear(fgrid, 0);
	}
	s_choose_face(pmap, fgrid);
	if (s_is_co_mode()) {
		var rand = random_range(0, 1);
		rand *= rand;
		rand -= 0.5;
		var max_grade = floor(86 + rand * 10);
		var nerd_factor = 0.02;
		if (random_range(0, 1) < nerd_factor) {
			max_grade = irandom_range(92, 100);
		}
		if (max_grade < 83) {
			max_grade = 83;
		}
		ds_map_set(pmap, "max_percent_grade", max_grade);
		ds_map_set(pmap, "percent_grade", irandom_range(61, ds_map_find_value(pmap, "max_percent_grade")));
		ds_map_set(pmap, "suspended", 0);
		ds_map_set(pmap, "rc_cost", s_create_player_get_RC_cost(pmap));
		ds_map_set(pmap, "toxic_dilemmas", 0);
		ds_map_set(pmap, "party_dilemmas", 0);
		ds_map_set(pmap, "party_meter", 0);
		ds_map_set(pmap, "trait", s_get_random_trait());
		ds_map_set(pmap, "hobby", s_get_random_hobby());
		ds_map_set(pmap, "major", s_get_random_study_subject(-1));
		ds_map_set(pmap, "minor", s_get_random_study_subject(ds_map_find_value(pmap, "major")));
		ds_map_set(pmap, "subject_reveal", irandom_range(0, 4));
		ds_map_set(pmap, "hometown", s_get_random_hometown());
		ds_map_set(pmap, "curriculum_vitae", "");
		ds_map_set(pmap, "curriculum_interest", "");
		slog("Created player[" + string(ds_map_find_value(pmap, "fname")) + "] with age:" + string(ds_map_find_value(pmap, "age")) + " and percent_grade:" + string(ds_map_find_value(pmap, "percent_grade")) + " and max_percent_grade(r:" + string(rand) + "):" + string(ds_map_find_value(pmap, "max_percent_grade")) + "( GPA " + string(s_gpa_from_percent_grade(ds_map_find_value(pmap, "percent_grade"))) + ") - Trait: " + string(ds_map_find_value(pmap, "trait")));
	}
	return pmap;
}

