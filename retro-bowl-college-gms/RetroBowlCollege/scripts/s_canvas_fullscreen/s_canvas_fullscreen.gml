function s_canvas_fullscreen() {
	var _base = argument[0];
	var _bw = browser_width;
	var _bh = browser_height;
	g_pBuiltIn.view_wport[0] = _bw;
	g_pBuiltIn.view_hport[0] = _bh;
	window_set_size(_bw, _bh);
	window_center();
	var _aspect = _bw / _bh;
	if (_aspect < 1) {
		var _vw = _base * _aspect;
		var _vh = _base;
	} else {
		_vw = _base;
		_vh = _base / _aspect;
	}
	camera_set_view_size(g_pBuiltIn.view_camera[0], _vw, _vh);
	surface_resize(g_pBuiltIn.application_surface, g_pBuiltIn.view_wport[0], g_pBuiltIn.view_hport[0]);
}

