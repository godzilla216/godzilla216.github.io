function btn_click_KR_Select() {
	with (obj_msgbg) {
		return;
	}
	if (obj_master.tag_kr_message_done < 2) {
		s_create_message("", s_str("msg_TagMessageKR"), "", s_str("ui_Continue"), s_msg_clear, s_msg_clear, global.c_background, 1);
		obj_master.tag_kr_message_done = 2;
	}
	for (var i = 0; i < ds_list_size(obj_master.roster); i++) {
		var pmap = ds_list_find_value(obj_master.roster, i);
		ds_map_set(pmap, "kr", 0);
	}
	selected = !selected;
	ds_map_set(obj_master.player_profile, "kr", selected);
	if (selected) {
		ds_map_set(obj_master.map_options, "op_kickoffs", 1);
	}
}

