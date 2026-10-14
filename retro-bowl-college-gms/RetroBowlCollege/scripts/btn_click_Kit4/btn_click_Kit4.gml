function btn_click_Kit4() {
	with (obj_edit_team) {
		s_save_uniform_file2(uid, current_uni, kittype);
		kittype = 3;
		current_uni = 100119;
		s_set_up_edit_screen();
	}
}

