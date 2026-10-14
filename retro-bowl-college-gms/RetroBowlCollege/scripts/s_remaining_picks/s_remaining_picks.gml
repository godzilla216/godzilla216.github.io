function s_remaining_picks() {
	with (obj_master) {
		if (draft_round < 1) {
			return 0;
		}
		if (draft_round > 3) {
			return 0;
		}
		return draft_picks[draft_round - 1];
	}
}

