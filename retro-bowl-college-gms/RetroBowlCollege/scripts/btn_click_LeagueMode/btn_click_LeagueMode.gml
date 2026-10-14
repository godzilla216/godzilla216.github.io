function btn_click_LeagueMode() {
	with (obj_division) {
		mode++;
		if (mode > (s_is_co_mode() ? 4 : 2)) {
			mode = 0;
		}
		s_panel_skip_independents_cnf_view(id);
	}
}

