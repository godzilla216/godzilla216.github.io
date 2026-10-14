function btn_click_Kit3() {
	with (obj_edit_team) {
		s_save_uniform_file2(uid, current_uni, kittype);
		kittype = 2;
		current_uni = 100118;
		s_set_up_edit_screen();
	}
}

