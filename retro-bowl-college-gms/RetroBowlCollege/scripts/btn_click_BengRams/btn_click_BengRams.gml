function btn_click_BengRams() {
	global.ui_skin += 1;
	if (global.ui_skin > 2) {
		global.ui_skin = 0;
	}
	s_set_ui_colours(global.ui_skin);
	if (global.poki) {
		switch (global.ui_skin) {
			case 1:
				poki_set_team(1);
				break;
			case 2:
				poki_set_team(2);
				break;
			default:
				poki_set_team(0);
				break;
		}
	}
	room_goto(rm_home);
}

function s_update_btn_bengrams() {
	inst_100248.visible = false;
	return;
	s_set_ui_colours(global.ui_skin);
	inst_100248.image_num = global.ui_skin;
	switch (global.ui_skin) {
		case 0:
			inst_100248.colour = make_color_rgb(44, 104, 255);
			break;
		case 1:
			inst_100248.colour = make_color_rgb(0, 76, 84);
			break;
		case 2:
			inst_100248.colour = make_color_rgb(226, 24, 54);
			break;
	}
}

function s_set_ui_colours(_arg0) {
	switch (_arg0) {
		case 0:
			global.c_background = make_color_rgb(44, 104, 255);
			global.c_primary = make_color_rgb(210, 210, 10);
			global.c_backfill = make_color_rgb(0, 0, 0);
			break;
		case 1:
			global.c_background = make_color_rgb(0, 76, 84);
			global.c_primary = make_color_rgb(220, 220, 220);
			global.c_backfill = make_color_rgb(0, 0, 0);
			break;
		case 2:
			global.c_background = make_color_rgb(226, 24, 54);
			global.c_primary = make_color_rgb(252, 205, 21);
			global.c_backfill = make_color_rgb(0, 0, 0);
			break;
	}
}

