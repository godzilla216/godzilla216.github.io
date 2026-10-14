function s_teams_file() {
	if (s_is_co_mode()) {
		return s_get_versioned_path("Teams_CO.txt");
	}
	return "Teams.txt";
}

