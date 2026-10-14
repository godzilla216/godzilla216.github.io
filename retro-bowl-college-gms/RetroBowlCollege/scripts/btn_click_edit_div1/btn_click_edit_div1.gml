function btn_click_edit_div1() {
	switch (obj_master.edit_conf) {
		case 0:
			s_edit_name(s_str("ui_Division"), obj_master.name_div1, s_edit_confirm_div1);
			break;
		case 1:
			s_edit_name(s_str("ui_Division"), obj_master.name_div1b, s_edit_confirm_div1);
			break;
	}
}

