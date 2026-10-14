function s_do_info_coachtrait() {
	var msg = "info_coachtrait_" + string(ds_map_find_value(obj_master.player_profile, "trait"));
	msg = s_str(msg);
	switch (ds_map_find_value(obj_master.player_profile, "position")) {
		case 101:
			msg = string_replace_all(msg, "$pos", string_lower(s_str("ui_Defensive")));
			break;
		case 102:
			msg = string_replace_all(msg, "$pos", string_lower(s_str("ui_Offensive")));
			break;
	}
	s_create_message("", msg, s_str("ui_Continue"), "", s_msg_clear, "", global.c_background, 1);
}

