function s_set_up_uniforms() {
	var fixture = s_get_human_fixture_next();
	var teamid_away = ds_map_find_value(fixture, "away_team");
	var teamid_home = ds_map_find_value(fixture, "home_team");
	slog("Team " + string(teamid_away) + " @ Team " + string(teamid_home));
	obj_master.team[0] = ds_list_find_value(obj_master.teamlist, teamid_away);
	obj_master.team[1] = ds_list_find_value(obj_master.teamlist, teamid_home);
	obj_master.playerteamindex = 0;
	if (teamid_home == obj_master.myteam_id) {
		obj_master.playerteamindex = 1;
	}
}

