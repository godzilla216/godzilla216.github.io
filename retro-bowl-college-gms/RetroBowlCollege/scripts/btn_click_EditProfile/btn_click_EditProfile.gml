function btn_click_EditProfile() {
	s_msg_clear();
	with (obj_master) {
		if (player_profile) {
			if (ds_map_find_value(map_options, "fullversion") == 1 || ds_map_find_value(player_profile, "position") == 100) {
				var is_staff = s_is_staff(ds_map_find_value(player_profile, "position"));
				face_type_coach = is_staff;
				s_edit_field(s_str("ui_FirstName"), s_str("ui_LastName"), ds_map_find_value(player_profile, "fname"), ds_map_find_value(player_profile, "lname"), ds_map_find_value(player_profile, "skin"), ds_map_find_value(player_profile, "face_x"), ds_map_find_value(player_profile, "face_y"), is_staff, ds_map_find_value(player_profile, "face_set"));
			} else {
				s_create_message("", s_str("msg_NeedUnlimited"), s_str("ui_No"), s_str("ui_Yes"), s_msg_clear, s_open_store, global.c_background, 1);
			}
		}
	}
}

