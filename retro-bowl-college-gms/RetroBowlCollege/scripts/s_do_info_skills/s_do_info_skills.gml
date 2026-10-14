function s_do_info_skills() {
	var msg = "";
	switch (ds_map_find_value(obj_master.player_profile, "position")) {
		case 1:
			msg = s_str("info_Skill_Throwing");
			break;
		case 10:
			msg = s_str("info_Skill_Kicking");
			break;
		case 5:
			msg = s_str("info_Skill_Blocking");
			break;
		case 6:
		case 7:
		case 9:
		case 8:
			msg = s_str("info_Skill_Tackling");
			break;
		default:
			msg = s_str("info_Skill_Catching");
			break;
	}
	if (obj_master.fr_mode) {
		msg += "\n\n" + s_str("info_Skill_Buff");
	}
	s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
}

