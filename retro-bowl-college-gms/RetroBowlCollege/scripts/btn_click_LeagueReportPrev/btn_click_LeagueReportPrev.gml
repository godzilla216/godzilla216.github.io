function btn_click_LeagueReportPrev() {
	with (obj_watermark) {
		page = clamp(page - 1, 1, 3);
	}
	with (obj_season_tally) {
		page = 1;
	}
}

