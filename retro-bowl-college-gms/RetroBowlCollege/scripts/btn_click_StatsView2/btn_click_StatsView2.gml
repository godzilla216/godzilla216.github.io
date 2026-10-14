function btn_click_StatsView2() {
	slog("showStats(2)");
	obj_master.stat_view = 2;
	if (s_is_co_mode()) {
		obj_master.co_stats_tab = 0;
	}
	room_goto(rm_stats_player);
}

