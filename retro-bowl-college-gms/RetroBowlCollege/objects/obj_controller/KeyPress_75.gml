if (!global.debug) {
	exit;
}
if (state == 2) {
	if (keyboard_check(16)) {
		possession = !possession;
	}
	scrimmage = -15;
	s_set_up_kickoff();
}
