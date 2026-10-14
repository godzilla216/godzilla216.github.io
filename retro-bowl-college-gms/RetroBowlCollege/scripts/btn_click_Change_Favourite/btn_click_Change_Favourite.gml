function btn_click_Change_Favourite() {
	with (obj_master) {
		fname = inst_100025.text;
		lname = inst_100026.text;
		fave_team_check = inst_100037.state;
	}
	if (s_is_co_mode()) {
		s_goto_room(rm_choose_team_college, { mode: global.g_m.team_selections.mode });
	} else {
		room_goto(rm_choose_team);
	}
}

