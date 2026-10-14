function s_do_postmatch_effects() {
	with (obj_master) {
		s_rehab_effect(50 + facility_rehab * 1.5, true);
		s_injury_effect_on_attitude();
		var fix = s_get_human_fixture_previous();
		if (fix && ds_map_find_value(fix, "human_win") != "win") {
			s_toxic_effect_on_morale();
		}
	}
}

