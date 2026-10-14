function s_edit_confirm_conf1() {
	with (obj_master) {
		var txt1 = edit_box1.text;
		if (string_length(txt1) > 0) {
			name_conf1 = txt1;
		}
		s_msg_clear();
		room_goto(rm_team_editor);
	}
}

