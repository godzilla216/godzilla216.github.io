if (!global.browser) {
	s_set_desktop_dev_window_size();
	display_set_gui_size(480, 270);
	surface_resize(application_surface, 480, 270);
	window_center();
}
