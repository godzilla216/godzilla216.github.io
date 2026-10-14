function s_remaining_picks_by_round(_arg0) {
	var pick_round = _arg0;
	with (obj_master) {
		if (pick_round < 1) {
			return 0;
		}
		if (pick_round > 3) {
			return 0;
		}
		return draft_picks[pick_round - 1];
	}
}

