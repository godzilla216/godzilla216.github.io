function s_get_week_superbowl() {
	var w = 28;
	if (!s_playoffs_12()) {
		w = 30;
	}
	if (obj_master.first_week_playoffs == 19) {
		w += 1;
	}
	return w;
}

