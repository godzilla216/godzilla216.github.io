function btn_response_skip_draft_yes() {
	s_msg_clear();
	var picks = obj_master.draft_picks[obj_master.draft_round - 1];
	if (picks > 0) {
		var value = picks * (4 - obj_master.draft_round);
		obj_master.coach_credit += value;
	}
	s_end_draft_round(false);
}

