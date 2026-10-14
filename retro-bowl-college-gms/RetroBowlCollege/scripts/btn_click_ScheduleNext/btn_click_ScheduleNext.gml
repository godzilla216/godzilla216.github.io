function btn_click_ScheduleNext() {
	inst_100254.sweek = clamp(inst_100254.sweek + 1, 1, obj_master.last_week_regular);
	s_populate_schedulebox();
}

