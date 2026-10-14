function btn_click_OptionsTeamEditor() {
	if (ds_map_find_value(obj_master.map_options, "fullversion") == 1) {
		s_save_options();
		if (s_is_co_mode()) {
			s_goto_room(rm_editor, s_get_editor_status());
		} else {
			room_goto(rm_team_editor);
		}
	} else {
		s_create_message("", s_str("msg_NeedUnlimited"), s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
	}
}

