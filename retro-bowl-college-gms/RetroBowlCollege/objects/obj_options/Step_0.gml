if (s_is_co_mode()) {
	if (inst_100299.x < inst_100299.x_wrap) {
		inst_100299.x = inst_100299.x_start;
	}
} else if (inst_100299.x < -wcred) {
	inst_100299.x = display_get_gui_width() + wcred * 0.5;
}
