window_center();
with (obj_btn_pause) {
	s_pause_btn_recenter();
	if (variable_instance_exists(id, "is_paused") && is_paused) {
		s_pause_options_recenter();
	}
}
with (obj_btn_audible) {
	s_btn_audible_reposition();
}
with (obj_btn_timeout) {
	s_btn_audible_reposition();
}
with (obj_btn_fieldgoal) {
	s_btn_fieldgoal_reposition();
}
with (obj_btn_kickoff) {
	s_btn_kickoff_recenter();
}
with (obj_msgbg) {
	s_message_recenter();
}
