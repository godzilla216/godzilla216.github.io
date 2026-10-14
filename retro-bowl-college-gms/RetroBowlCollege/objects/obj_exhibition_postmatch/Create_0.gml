with (obj_master) {
	inst_100817.teamnames[0] = ds_map_find_value(team[0], "tla");
	inst_100817.teamnames[1] = ds_map_find_value(team[1], "tla");
	inst_100817.ratings1[0] = s_get_team_offense(team[0]);
	inst_100817.ratings1[1] = s_get_team_defense(team[0]);
	inst_100817.ratings2[0] = s_get_team_offense(team[1]);
	inst_100817.ratings2[1] = s_get_team_defense(team[1]);
	inst_100817.scores1 = [qtr_scores0[0], qtr_scores0[1], qtr_scores0[2], qtr_scores0[3], tscore[0]];
	inst_100817.scores2 = [qtr_scores1[0], qtr_scores1[1], qtr_scores1[2], qtr_scores1[3], tscore[1]];
	btn_continue_state = 0;
}
