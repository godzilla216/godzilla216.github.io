function btn_click_ChooseAFC() {
	with (obj_choose_team) {
		conference = 0;
		if (obj_master.year == 1 && obj_master.week == 1 || global.exhibition) {
			s_update_team_buttons();
		} else {
			s_update_job_offer_buttons();
		}
	}
}

