function btn_click_Kit2() {
	with (obj_edit_team) {
		s_save_uniform_file2(uid, current_uni, kittype);
		kittype = 1;
		current_uni = 100116;
		s_set_up_edit_screen();
	}
}

