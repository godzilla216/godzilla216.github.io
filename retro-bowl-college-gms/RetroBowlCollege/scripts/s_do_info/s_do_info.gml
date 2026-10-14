function s_do_info(_arg0) {
	switch (_arg0) {
		case "info_Position":
			s_do_info_position();
			break;
		case "info_Skills":
			s_do_info_skills();
			break;
		case "info_DraftPicks":
			s_do_info_draftpicks();
			break;
		case "info_CoachTrait":
			s_do_info_coachtrait();
			break;
		case "info_Skill_Strength":
			_arg0 = s_str(_arg0);
			if (obj_master.fr_mode) {
				_arg0 += "\n\n" + s_str("info_Strength_Buff");
			}
			s_create_message("", _arg0, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			break;
		case "info_Skill_Speed":
			_arg0 = s_str(_arg0);
			if (obj_master.fr_mode) {
				_arg0 += "\n\n" + s_str("info_Speed_Buff");
			}
			s_create_message("", _arg0, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			break;
		case "info_Skill_Stamina":
			_arg0 = s_str(_arg0);
			if (obj_master.fr_mode) {
				_arg0 += "\n\n" + s_str("info_Stamina_Buff");
			}
			s_create_message("", _arg0, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			break;
		case "info_GPAExplanation":
			s_info_gpa_explanation_open();
			break;
		case "info_Draft":
			if (s_is_co_mode()) {
				s_create_message("", s_str(_arg0), s_str("ui_Continue"), "", s_info_draft_col1, "", global.c_background, 1);
			} else {
				s_create_message("", s_str(_arg0), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			}
			break;
		default:
			s_create_message("", s_str(_arg0), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
			break;
	}
}

function s_info_draft_col1() {
	s_msg_clear();
	s_create_message("", s_str("info_Draft_b"), s_str("ui_Continue"), "", s_info_draft_col2, "", global.c_background, 1);
}

function s_info_draft_col2() {
	s_msg_clear();
	s_create_message("", s_str("info_Draft_c"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
}

