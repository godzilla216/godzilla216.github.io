function s_do_info_draftpicks() {
	var msg = s_str("info_DraftPicks");
	with (obj_master) {
		msg = string_replace(msg, "$num1", string(draft_picks[0]));
		msg = string_replace(msg, "$num2", string(draft_picks[1]));
		msg = string_replace(msg, "$num3", string(draft_picks[2]));
	}
	s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
}

