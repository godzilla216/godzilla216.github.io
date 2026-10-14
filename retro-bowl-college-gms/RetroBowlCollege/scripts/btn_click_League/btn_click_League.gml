function btn_click_League() {
	if (s_is_co_mode()) {
		s_goto_room(rm_league_college, { mode: current_room == rm_home ? 0 : 2 });
	} else {
		room_goto(rm_league);
	}
}

