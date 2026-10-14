function btn_click_HOF_Select() {
	with (obj_msgbg) {
		return;
	}
	if (obj_master.tag_hof_message_done == 0) {
		s_create_message("", s_str("msg_TagMessageHOF"), "", s_str("ui_Continue"), s_msg_clear, s_msg_clear, global.c_background, 1);
		obj_master.tag_hof_message_done = 1;
	}
	var count = s_count_hof_entries();
	if (!selected && count >= 50) {
		s_create_message("", s_str("msg_HofListTooBig"), s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
		return;
	}
	if (obj_master.viewing_hof_players && ds_list_find_index(obj_master.roster, obj_master.player_profile) < 0) {
		s_create_message("", s_str("msg_RemoveFromHallOfFame"), s_str("ui_Cancel"), s_str("ui_Remove"), s_msg_clear, btn_response_hof_select, global.c_background, 1);
	} else {
		selected = !selected;
		ds_map_set(obj_master.player_profile, "hof", selected);
	}
}

