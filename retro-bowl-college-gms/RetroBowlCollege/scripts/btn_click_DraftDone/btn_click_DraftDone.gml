function btn_click_DraftDone() {
	slog("btn_click_DraftRound");
	if (s_is_co_mode()) {
		s_college_admissions_draft_done();
		return;
	}
	var picks = obj_master.draft_picks[obj_master.draft_round - 1];
	slog("Picks = " + string(picks));
	if (picks > 0) {
		var value = picks * (4 - obj_master.draft_round);
		var msg = s_str("msg_SkipDraft");
		if (picks == 1) {
			msg = s_str("msg_SkipDraft1");
		}
		msg = string_replace(msg, "$num", string(picks));
		msg = string_replace(msg, "$value", string(value));
		s_create_message("", msg, s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, btn_response_skip_draft_yes, global.c_background, 1);
	} else {
		s_end_draft_round(false);
	}
}

