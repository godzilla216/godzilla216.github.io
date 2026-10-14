function s_opponent_goalside(_arg0) {
	var opp = _arg0;
	switch (opp.facing) {
		case 1:
			if (opp.x > x + 5) {
				return true;
			}
			break;
		case -1:
			if (opp.x < x - 5) {
				return true;
			}
			break;
	}
	return false;
}

