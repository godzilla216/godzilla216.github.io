function btn_click_ChooseNFC() {
	with (obj_choose_team) {
		conference = 1;
		if (obj_master.year == 1 && obj_master.week == 1 || global.exhibition) {
			s_update_team_buttons();
		} else {
			s_update_job_offer_buttons();
		}
	}
}

