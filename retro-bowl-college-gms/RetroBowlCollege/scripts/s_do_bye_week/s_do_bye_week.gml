function s_do_bye_week() {
	with (obj_master) {
		s_do_schedule(false);
		s_rehab_effect(facility_rehab * 10, false);
		s_injury_effect_on_attitude();
		s_toxic_effect_on_morale();
		s_add_xp_gain_all(round(8), false);
		var msg = "";
		if (qb_mode) {
			msg = s_choose_dilemma("dilemma_ByeWeek_QB");
		} else {
			msg = s_choose_dilemma("dilemma_ByeWeek");
		}
		ds_map_clear(map_dilemma);
		map_dilemma = s_parse_dilemma(msg, -4, "ui_ByeWeek");
		s_create_dilemma(map_dilemma);
		stage = 5;
	}
}

