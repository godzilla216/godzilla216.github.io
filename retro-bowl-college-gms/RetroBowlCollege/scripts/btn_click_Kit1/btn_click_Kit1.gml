function btn_click_Kit1() {
	with (obj_edit_team) {
		s_save_uniform_file2(uid, current_uni, kittype);
		kittype = 0;
		current_uni = 100115;
		s_set_up_edit_screen();
	}
}

