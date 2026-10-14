function s_edit_confirm_div4() {
	with (obj_master) {
		var txt1 = edit_box1.text;
		if (string_length(txt1) > 0) {
			switch (edit_conf) {
				case 0:
					name_div4 = txt1;
					break;
				case 1:
					name_div4b = txt1;
					break;
			}
		}
		s_msg_clear();
		room_goto(rm_team_editor);
	}
}

