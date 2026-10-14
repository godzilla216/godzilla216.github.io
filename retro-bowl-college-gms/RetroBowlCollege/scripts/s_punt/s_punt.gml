function s_punt() {
	slog("s_punt");
	scrimmage += irandom_range(40, 60);
	if (scrimmage > 49) {
		scrimmage = 25;
	}
	comm_txt = string_replace(s_str("comm_stage_Punt"), "$teamname", team_name[possession]);
	s_sound_kick();
	s_subtract_time(5, 10, "COMM_STAGE_PUNT");
	s_change_possession();
	last_play = 5;
}

