function s_create_camera() {
	with (obj_camera) {
		surface_depth_disable(true);
		if (os_type == 1 && !global.browser) {
			display_width = window_get_width() * 2;
			display_height = window_get_height() * 2;
		} else {
			display_width = display_get_width();
			display_height = display_get_height();
		}
		zoom = 2;
		aspect_ratio = display_width / display_height;
		slog("Aspect Ratio = " + string(aspect_ratio));
		view_height = 270;
		view_width = round(view_height * aspect_ratio);
		if (view_width & 1) {
			view_width++;
		}
		if (view_height & 1) {
			view_height++;
		}
		if (global.browser) {
			max_window_scale = min(display_width / view_width, display_height / view_height);
		} else {
			max_window_scale = min(floor(display_width / view_width), floor(display_height / view_height));
			if (view_height * max_window_scale == display_height) {
				max_window_scale--;
			}
		}
		window_set_size(view_width * max_window_scale, view_height * max_window_scale);
		display_set_gui_size(view_width, view_height);
		alarm[0] = 1;
		surface_resize(g_pBuiltIn.application_surface, view_width * max_window_scale, view_height * max_window_scale);
	}
}

