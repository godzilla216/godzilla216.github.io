function btn_click_LeaguePanel(_arg0) {
	inst_100262.visible = true;
	inst_100263.visible = true;
	inst_100260.visible = true;
	inst_100261.visible = true;
	inst_100254.visible = true;
	inst_100255.visible = true;
	inst_100256.visible = true;
	inst_100266.text = obj_master.name_conf1;
	inst_100265.text = obj_master.name_conf2;
	inst_100269.active = true;
	with (obj_league) {
		show_panel = _arg0;
		switch (show_panel) {
			case 0:
				inst_100266.colour = global.c_primary;
				inst_100265.colour = global.c_background;
				inst_100267.colour = global.c_background;
				inst_100254.visible = false;
				inst_100255.visible = false;
				inst_100256.visible = false;
				inst_100257.visible = false;
				break;
			case 1:
				inst_100266.colour = global.c_background;
				inst_100265.colour = global.c_primary;
				inst_100267.colour = global.c_background;
				inst_100254.visible = false;
				inst_100255.visible = false;
				inst_100256.visible = false;
				inst_100257.visible = false;
				break;
			case 2:
				inst_100266.colour = global.c_background;
				inst_100265.colour = global.c_background;
				inst_100267.colour = global.c_primary;
				inst_100262.visible = false;
				inst_100263.visible = false;
				inst_100260.visible = false;
				inst_100261.visible = false;
				inst_100269.active = false;
				inst_100257.visible = true;
				break;
		}
		if (!s_is_co_mode()) {
			s_populate_division(100262, show_panel, 0);
			s_populate_division(100263, show_panel, 1);
			s_populate_division(100260, show_panel, 2);
			s_populate_division(100261, show_panel, 3);
		}
		s_populate_schedulebox();
		with (obj_division) {
			mode = 1;
		}
	}
}

