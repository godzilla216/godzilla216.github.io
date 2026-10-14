function s_do_info_position() {
	var msg = "info_" + s_get_string_position(ds_map_find_value(obj_master.player_profile, "position"));
	msg = s_str(msg);
	if (0 && s_is_co_mode()) {
		msg += "\nDebug:";
		msg += "\nGRADE:" + s_get_decay_info(obj_master.player_profile);
		msg += "\nPARTY:" + s_get_party_info(obj_master.player_profile);
		msg += "\nSTUDIES:" + s_get_study_info(obj_master.player_profile);
	}
	s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
}

