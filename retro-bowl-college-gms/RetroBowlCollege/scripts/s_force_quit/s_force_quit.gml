function s_force_quit() {
	with (obj_controller) {
		show_debug_message("force quit match");
		if (obj_master.gamepractice) {
			room_goto(rm_home);
			return;
		}
		team_score[human_team] += 3;
		if (team_score[human_team] > team_score[!human_team ? 1 : 0]) {
			s_end_match(1);
		} else if (team_score[human_team] < team_score[!human_team ? 1 : 0]) {
			s_end_match(-1);
		} else {
			s_end_match(0);
		}
	}
}

