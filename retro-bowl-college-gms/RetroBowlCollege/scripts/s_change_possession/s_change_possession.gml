function s_change_possession() {
	slog("s_change_possession");
	with (obj_controller) {
		scorer = "";
		down = 1;
		yards = 10;
		scrimmage = -scrimmage;
		possession = !possession;
		last_play = comm_stage;
		comm_stage = 2;
		phase = 0;
		drives += 1;
		slog("scrimmage = " + string(scrimmage));
	}
}

function s_force_possession(_arg0) {
	if (_arg0 != possession) {
		s_change_possession();
	}
}

