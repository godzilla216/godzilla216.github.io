function s_reset_draft_picks() {
	with (obj_master) {
		draft_picks[0] += 1;
		draft_picks[1] += 1;
		draft_picks[2] += 1;
		s_savegame();
	}
}

