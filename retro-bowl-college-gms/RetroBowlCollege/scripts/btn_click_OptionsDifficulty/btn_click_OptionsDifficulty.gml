function btn_click_OptionsDifficulty() {
	obj_master.op_difficulty += 1;
	if (obj_master.op_difficulty > 4) {
		obj_master.op_difficulty = 0;
	}
	s_update_options();
}

