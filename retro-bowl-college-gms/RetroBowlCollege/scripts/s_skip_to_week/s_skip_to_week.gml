function s_skip_to_week(_arg0) {
	slog("s_skip_to_week " + string(_arg0) + " ");
	with (obj_master) {
		do {
			s_do_schedule(true);
			week++;
		} until (!!(week == _arg0));
		draft_round = 4;
	}
}

