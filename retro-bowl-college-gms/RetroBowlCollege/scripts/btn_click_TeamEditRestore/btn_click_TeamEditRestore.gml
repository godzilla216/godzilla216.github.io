function btn_click_TeamEditRestore() {
	with (obj_edit_team) {
		s_load_uniform_file2(uid, current_uni, kittype, s_uniforms_default_file());
		s_set_up_edit_screen();
	}
}

