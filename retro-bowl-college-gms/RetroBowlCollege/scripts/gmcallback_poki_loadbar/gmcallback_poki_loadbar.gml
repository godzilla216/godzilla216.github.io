function gmcallback_poki_loadbar(_arg0, _arg1, _arg2, _arg3, _arg4, _arg5, _arg6) {
	slog("gmcallback_poki_loadbar");
	var r;
	var pc = _arg1;
	var pt = _arg2;
	var cw = _arg3;
	var ch = _arg4;
	var iw = _arg5;
	var ih = _arg6;
	switch (_arg0) {
		case "image_rect":
			r[0] = ((current_time div 500) mod 4) * (iw div 4);
			r[1] = 0;
			r[2] = 0;
			r[3] = 0;
			return r;
		case "background_color":
			return "#000000";
		case "bar_background_color":
			return "#000000";
		case "bar_foreground_color":
			return "#D2D20A";
		case "bar_border_color":
			return "#2C68FF";
		case "bar_width":
			return round(cw * 0.6);
		case "bar_height":
			return 20;
		case "bar_border_width":
			return 2;
		case "bar_offset":
			return 0;
	}
	return undefined;
}

