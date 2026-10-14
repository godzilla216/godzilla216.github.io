function s_edit_confirm_conf2() {
	with (obj_master) {
		var txt1 = edit_box1.text;
		if (string_length(txt1) > 0) {
			name_conf2 = txt1;
		}
		s_msg_clear();
		room_goto(rm_team_editor);
	}
}

