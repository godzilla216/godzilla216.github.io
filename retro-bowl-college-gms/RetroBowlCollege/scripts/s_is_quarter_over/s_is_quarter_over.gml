function s_is_quarter_over() {
	var time_up = obj_controller.minutes <= 0 && obj_controller.seconds <= 0;
	if (time_up) {
		slog("is_quarter_over = YES (" + s_get_string_commstage(comm_stage) + ")");
		comm_next_stage = comm_stage;
		comm_stage = 12;
		if (quarter < 5) {
			drives = 0;
		}
		return true;
	}
	slog("is_quarter_over = NO (" + s_get_string_commstage(comm_stage) + ")");
	return false;
}

