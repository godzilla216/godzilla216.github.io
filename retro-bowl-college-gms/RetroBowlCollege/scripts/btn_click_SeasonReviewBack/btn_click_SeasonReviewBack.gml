function btn_click_SeasonReviewBack() {
	if (obj_master.done_season_review) {
		room_goto(rm_home);
	} else if (s_is_co_mode()) {
		s_goto_room(rm_league_college, { mode: 2 });
	} else {
		room_goto(rm_league);
	}
}

