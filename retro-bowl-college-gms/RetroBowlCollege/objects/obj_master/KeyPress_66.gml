if (!global.debug) {
	exit;
}
with (obj_input_box) {
	exit;
}
if (room == rm_home && !instance_exists(obj_msgbg) && !instance_exists(obj_input_box)) {
	s_skip_to_week(s_get_bye_week());
	s_competitions_status_update();
	s_update_human_fixtures();
}
