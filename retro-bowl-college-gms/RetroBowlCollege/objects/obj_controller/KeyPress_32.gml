if (!global.debug) {
	exit;
}
if (alarm[0] > 0) {
	alarm[0] = 1;
} else {
	s_set_up_play(true);
}
