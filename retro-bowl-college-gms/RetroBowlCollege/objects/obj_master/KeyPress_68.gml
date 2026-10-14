if (!global.debug) {
	exit;
}
with (obj_input_box) {
	exit;
}
if (s_is_co_mode()) {
	exit;
}
if (obj_master.qb_mode) {
	s_add_news_dyn("web", "QB wins award!##You won the Retro Bowl MVP award!", s_get_qb_pmap());
	s_check_for_news();
}
