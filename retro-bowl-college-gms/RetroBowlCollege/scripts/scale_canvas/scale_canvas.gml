function scale_canvas(_arg0, _arg1, _arg2, _arg3, _arg4) {
	var _aspect = _arg0 / _arg1;
	if (_arg2 / _aspect > _arg3) {
		var vh = floor(_arg3 * _aspect);
		if (vh & 1) {
			vh++;
		}
		window_set_size(vh, _arg3);
	} else {
		var vw = floor(_arg2 / _aspect);
		if (vw & 1) {
			vw++;
		}
		window_set_size(_arg2, vw);
	}
	if (_arg4) {
		window_center();
	}
	surface_resize(g_pBuiltIn.application_surface, min(window_get_width(), _arg0), min(window_get_height(), _arg1));
}

