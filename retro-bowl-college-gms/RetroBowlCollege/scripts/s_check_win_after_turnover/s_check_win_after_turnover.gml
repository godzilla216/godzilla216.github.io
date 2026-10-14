function s_check_win_after_turnover() {
	slog("s_check_win_after_turnover:");
	slog("quarter = " + string(quarter));
	slog("drives = " + string(drives));
	slog("Team 0 score = " + string(team_score[0]));
	slog("Team 1 score = " + string(team_score[1]));
	if (college_overtime) {
		s_college_overtime_handle_play_end();
	} else if (quarter == 5 && drives > 1 && team_score[0] != team_score[1] && s_both_teams_had_possession()) {
		slog("winning after turnover");
		comm_stage = 17;
		s_sound_audience_fg();
	}
}

function s_both_teams_had_possession() {
	var log_str = "";
	log_str += "s_both_teams_had_possession:\n";
	log_str += "- week = " + string(obj_master.week) + "\n";
	log_str += "- last_week_regular = " + string(obj_master.last_week_regular) + "\n";
	log_str += "- Team 0 had possession = " + string(had_ot_possession[0]) + "\n";
	log_str += "- Team 1 had possession = " + string(had_ot_possession[1]) + "\n";
	if (obj_master.week <= obj_master.last_week_regular && !global.exhibition && !college_overtime) {
		log_str += "-- regular season game: return true\n";
		slog(log_str);
		return true;
	} else if (had_ot_possession[0] && had_ot_possession[1]) {
		log_str += "-- play off game: return true\n";
		slog(log_str);
		return true;
	} else {
		log_str += "-- return false\n";
		slog(log_str);
		return false;
	}
	slog(log_str);
}

