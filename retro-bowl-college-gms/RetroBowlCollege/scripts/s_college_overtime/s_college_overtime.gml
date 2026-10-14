function s_college_overtime_start() {
	slog("s_college_overtime_start");
	slog("OT !");
	slog("OT !!!");
	slog("OT !!!!!!!!!!!!!!!!!");
	slog(" ");
	college_overtime = true;
	college_overtime_round = 1;
	possession = irandom(1);
	college_overtime_possession = possession;
	s_college_overtime_setup_new_possesion();
	slog("s_college_overtime_start[" + string(college_overtime_round) + "] possesion[" + s_co_poss_str(possession) + "]");
}

function s_college_overtime_handle_play_end() {
	slog(" s_college_overtime_handle_play_end");
	s_college_overtime_score_hack();
	if (s_both_teams_had_possession()) {
		if (team_score[possession] == team_score[!possession ? 1 : 0]) {
			s_college_overtime_next_round();
		} else {
			s_college_overtime_one_team_won();
		}
	} else {
		s_college_overtime_other_teams_turn();
	}
}

function s_college_overtime_setup_new_possesion() {
	slog(" s_college_overtime_setup_new_possesion");
	scrimmage = 25;
	yards = 10;
	comm_stage = 2;
	if (!s_simming_action() && possession == human_team) {
		var human_points_behind = team_score[!human_team ? 1 : 0] - team_score[human_team];
		slog("s_college_overtime_setup_new_possesion: human_points_behind[" + string(human_points_behind) + "]");
		if (college_overtime_round <= 2 && human_points_behind <= 3) {
			s_create_message("", s_str("matchmsg_kickorattack"), s_str("match_co_kick"), s_str("match_co_attack"), btn_response_fg_yes, btn_response_2pt, 16777215, 0.7);
		}
	}
	if (college_overtime_round >= 3) {
		comm_stage = 15;
	}
}

function s_college_overtime_offer_kick() {
	slog("s_college_overtime_offer_kick: ");
	if (college_overtime == false) {
		slog("F:0");
		return false;
	}
	if (s_simming_action()) {
		slog("F:1");
		return false;
	}
	if (possession != human_team) {
		slog("F:2");
		return false;
	}
	if (college_overtime_round > 2) {
		slog("F:3");
		return false;
	}
	if (down == 1) {
		slog("F:4");
		return false;
	}
	var pos_count = s_college_overtime_possession_count();
	slog("s_college_overtime_offer_kick: pos_count[" + string(pos_count) + "]");
	if (pos_count == 1) {
		if (down == 4) {
			slog("T:0");
			return true;
		}
	} else {
		var human_points_behind = team_score[!human_team ? 1 : 0] - team_score[human_team];
		slog("s_college_overtime_offer_kick: human_points_behind[" + string(human_points_behind) + "]");
		if (human_points_behind <= 3) {
			slog("T:1");
			return true;
		}
	}
	slog("F:4");
	return false;
}

function s_college_overtime_next_round() {
	slog("s_college_overtime_next_round");
	slog("OT !");
	slog("OT !!!");
	slog("OT !!!!!!!!!!!!!!!!!");
	slog(" ");
	college_overtime_round += 1;
	had_ot_possession[0] = 0;
	had_ot_possession[1] = 0;
	slog(" s_college_overtime_next_round college_overtime_round:[" + string(college_overtime_round) + "]");
	s_college_overtime_setup_new_possesion();
}

function s_college_overtime_possession_count() {
	var c = 0;
	if (had_ot_possession[0] == 1) {
		c += 1;
	}
	if (had_ot_possession[1] == 1) {
		c += 1;
	}
	return c;
}

function s_college_overtime_one_team_won() {
	slog(" s_college_overtime_one_team_won");
	comm_stage = 17;
}

function s_college_overtime_other_teams_turn() {
	slog("s_college_overtime_other_teams_turn");
	slog("OT !!!!!!!!!!!!!!!!!");
	slog(" ");
	s_college_overtime_flip_possession(true);
	s_college_overtime_setup_new_possesion();
}

function s_college_overtime_trigger_point_conversion() {
	slog(" s_college_overtime_trigger_point_conversion college_overtime_round:[" + string(college_overtime_round) + "]");
	down = 6;
	if (college_overtime_round == 1) {
		slog(" s_college_overtime_trigger_point_conversion... ASK 2P or 1P");
		s_create_message("", s_str("matchmsg_PATor2"), s_str("match_1pt"), s_str("match_2pt"), btn_response_1pt, btn_response_2pt, 16777215, 0.7);
	} else {
		slog(" s_college_overtime_trigger_point_conversion... DIRECT 2P");
	}
}

function s_college_overtime_flip_possession(_arg0) {
	if (_arg0) {
		college_overtime_possession = !college_overtime_possession;
	}
	s_force_possession(college_overtime_possession);
	slog("s_college_overtime_flip_possession (cot_poss:" + s_co_poss_str(college_overtime_possession) + ") (poss:" + s_co_poss_str(possession) + ")");
}

function s_college_overtime_score_hack() {
	if (global.debug_co_overtime == 0) {
		return;
	}
	if (quarter < 4) {
		quarter = 4;
	}
	var sHackTrig = "N/A";
	var doHack = false;
	if (quarter >= 4 && college_overtime_round < 1 && team_score[human_team] != team_score[!human_team ? 1 : 0]) {
		doHack = true;
		sHackTrig = "A";
	}
	if (doHack == false && irandom(1)) {
		doHack = true;
		sHackTrig = "B";
	}
	if (global.debug_co_overtime == 2) {
		doHack = true;
		sHackTrig = "C";
	}
	if (doHack) {
		slog("HACK FORCING TIE SCORES ot_count[" + string(college_overtime_round) + "] global.debug_co_overtime[" + string(global.debug_co_overtime) + "] sHackTrig[" + sHackTrig + "]");
		var m = max(team_score[human_team], team_score[!human_team ? 1 : 0]);
		team_score[human_team] = m;
		team_score[!human_team ? 1 : 0] = m;
	} else {
		slog("NO HACK - Scores unnafected");
	}
}

function s_co_poss_str(_arg0) {
	if (_arg0 == human_team) {
		return "HUMAN";
	}
	return "AI";
}

function btn_click_toggle_college_overtime_debug() {
	global.debug_co_overtime += 1;
	if (global.debug_co_overtime > 2) {
		global.debug_co_overtime = 0;
	}
	s_refresh_btn_overtime_text();
}

function s_refresh_btn_overtime_text() {
	switch (global.debug_co_overtime) {
		case 0:
			inst_100401.text = "DEB. OT: N";
			break;
		case 1:
			inst_100401.text = "DEB. OT: Y";
			break;
		case 2:
			inst_100401.text = "DEB. OT: L";
			break;
	}
}

