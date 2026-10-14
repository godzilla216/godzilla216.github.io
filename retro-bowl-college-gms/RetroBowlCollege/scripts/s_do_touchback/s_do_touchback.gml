function s_do_touchback() {
	if (s_is_kickoff(true) && s_can_touchback()) {
		var ddir = -1;
		with (obj_controller) {
			ddir = drivedir;
		}
		if (x < 300 && ddir == 1 || x > 2300 && ddir == -1) {
			s_set_anim(19);
			return true;
		}
	}
	return false;
}

