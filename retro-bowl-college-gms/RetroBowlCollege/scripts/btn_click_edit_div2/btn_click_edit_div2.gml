function btn_click_edit_div2() {
	switch (obj_master.edit_conf) {
		case 0:
			s_edit_name(s_str("ui_Division"), obj_master.name_div2, s_edit_confirm_div2);
			break;
		case 1:
			s_edit_name(s_str("ui_Division"), obj_master.name_div2b, s_edit_confirm_div2);
			break;
	}
}

